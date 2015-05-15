require 'torch'
require 'nn'
require 'optim'

-- Import the functions
dofile( "NN_Funcs.lua" )

-- Build the neural net architecture for AllLevel (Low + High)
local model = nn.Sequential()
model:add(nn.Linear( 28, 150 ))
model:add(nn.PReLU())
model:add(nn.Linear( 150, 150 ))
model:add(nn.PReLU())
model:add(nn.Linear( 150, 150 ))
model:add(nn.PReLU())
model:add(nn.Dropout(0.5))
model:add(nn.Linear( 150, 2 ))
model:add(nn.LogSoftMax())

-- Define the table of file names
filenames = {}
for i = 1, 8 do
	table.insert( filenames, "Higgs_" .. i .. ".csv" )
end

-- Randomize the order of the training data files
fileShuffle = torch.randperm(8)

-- Load the 'i' file
for i = 1, 8 do

	-- Load the shuffled training file
	local trainData = readFile( filenames[ fileShuffle[i] ], true, true )
	print( 'Training ( ' .. i .. ' / 8 ) . . .' )

	-- Do 'j' epochs with it
	for j = 1, 5 do
		train_model(model, trainData)
		collectgarbage()
	end
end

-- Test the model
local testData = readFile( "Higgs_Test.csv", true, true )
print( "Testing . . ." )
test_model(model, testData)











