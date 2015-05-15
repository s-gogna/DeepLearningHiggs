require 'torch'
require 'nn'
require 'optim'

-- Define a file reading function
function readFile( filename, useLowLevel, useHighLevel )

	-- Open the file
	local count = 0
	local file = assert(io.open(filename, 'r'))

	-- Clear the trainData table
	local dataTable = { data = {}, labels = {} }
	collectgarbage()

	-- Read the data from the file
	local line = file:read()
	while line ~= nil do

		-- Split the line at every comma and add the values to a vector
		local vector = {}
		local wCount = 0
		for word in string.gmatch(line, '([^,]+)') do

			-- Check if value should be added
			if wCount == 0 then

				-- Insert label into the label table
				-- NOTE: + 1 is to prevent the out-of-range error in the 'forward' function of the criterion
				table.insert( dataTable.labels, tonumber(word) + 1 )

			elseif useLowLevel and wCount >= 1 and wCount <= 21 then

				-- Insert the low level feature
				table.insert( vector, tonumber(word) )

			elseif useHighLevel and wCount >= 22 then

				-- Insert the high level feature
				table.insert( vector, tonumber(word) )

			end

			-- Increment the counter
			wCount = wCount + 1
		end

		-- Add the vector to the rest of the data
		table.insert( dataTable.data, vector )

		-- Read next line
		line = file:read()

		-- Use 'count' to periodically collect garbage
		-- NOTE: Collecting garbage often leads to very slow loading
		count = count + 1
		if count == 250000 then
			collectgarbage()
			count = 0
		end
	end

	-- Close the file
	file:close()
	collectgarbage()

	-- Return
	return dataTable
end

-- Training Function
function train_model(model, trainData)

	-- Initialize variables
	local count = 0
	local batchSize = 64
	local confusion = optim.ConfusionMatrix( {'1', '2'} )
	local shuffle = torch.randperm( #trainData.data )
	local criterion = nn.ClassNLLCriterion()
	local parameters, gradParameters = model:getParameters()

	-- Switch model to training mode
	model:training()

	-- Do one epoch
	for t = 1, #trainData.data, batchSize do

		-- Initialize variables
		local inputs = {}
		local targets = {}

		-- Display progress
		-- xlua.progress( t, #trainData.data )

		-- Build the mini-batch
		for i = t, math.min( t+63, #trainData.data ) do

			-- Load a new sample
			local input = trainData.data[ shuffle[i] ]
			local target = trainData.labels[ shuffle[i] ]
			input = torch.Tensor(input):double()
			table.insert(inputs, input)
			table.insert(targets, target)
		end

		-- Build a closure
		local feval = function(x)

			-- Ensure parameters are the same
			if x ~= parameters then parameters:copy(x) end

			-- Zero out the gradient parameters
			gradParameters:zero()

			local totalErr = 0
			for i = 1, #inputs do

				-- Forward the input through the model
				local output = model:forward(inputs[i])

				-- Get the result back
				output = torch.reshape(output, 2)

				-- Compute the error using the criterion
				local err = criterion:forward(output, targets[i])
				totalErr = totalErr + err

				-- Do a backward pass through the criterion using the correct answer
				local df_do = criterion:backward(output:double(), targets[i])
				model:backward(inputs[i], df_do)

				-- Add to the confusion matrix
				confusion:add(output, targets[i])
			end

			-- Divide by the input size
			gradParameters:div(#inputs)
			totalErr = totalErr / #inputs

			-- Return
			return totalErr, gradParameters
		end

		-- Do gradient descent
		optim.sgd( feval, parameters, { learningRate = 0.05, weightDecay = 0.01, momentum = 0.01, learningRateDecay = 5e-7 } )

		-- Use 'count' to periodically collect garbage
		-- NOTE: Collecting garbage often leads to very slow loading
		count = count + 1
		if count == 2000 then
			collectgarbage()
			count = 0
		end
	end

	-- Print the resulting confusion matrix
	print(confusion)
end

-- Testing Function
function test_model(model, testData)

	-- Initialize variables
	local confusion = optim.ConfusionMatrix( {'1', '2'} )

	-- Switch model to testing/evaluate mode
	model:evaluate()

	-- Loop through all the test data
	for t = 1, #testData.data do

		-- Convert the table to a tensor
		local input = torch.Tensor( testData.data[t] ):double()
		local target = tonumber(testData.labels[t])

		-- Forward the input through the model
		local pred = model:forward(input)

		-- Reshape the output and add to the confusion matrix
		pred = torch.reshape(pred, 2)
		confusion:add(pred, target)
	end

	-- Print the resulting confusion matrix
	print(confusion)
end
