#include <iostream>
#include <fstream>
using namespace std;

// Function definitions
void readFileAndWriteResults(ifstream&, ofstream&, int);

// Main Program
int main()
{
	// Initialize variables
	ifstream finLow("LowLevelResults.txt");
	ifstream finHigh("HighLevelResults.txt");
	ifstream finAll("AllLevelResults.txt");
	ofstream fout("NN_Results.csv");

	// Read and write
	readFileAndWriteResults(finLow, fout, 0);
	readFileAndWriteResults(finHigh, fout, 1);
	readFileAndWriteResults(finAll, fout, 2);

	// Close the files
	finLow.close();
	finHigh.close();
	finAll.close();
	fout.close();

	// Return
	return 0;
}

// Function Implementation
void readFileAndWriteResults(ifstream& fin, ofstream& fout, int tag)
{
	// Read the results
	char buffer[1024];
	for( int i = 0; i < 8; ++i )
	{
		// Read "Training ..."
		fin.getline(buffer, 1024);

		// Loop over the 5 iterations
		for( int j = 0; j < 5; ++j )
		{
			// Initialize variables
			double value;

			// Skip over the confusion matrix
			fin.getline(buffer, 1024);
			fin.getline(buffer, 1024);
			fin.getline(buffer, 1024);
			fin.getline(buffer, 1024);
			fin.getline(buffer, 1024);

			// Read three words and the number
			fin >> buffer >> buffer >> buffer;

			// Read the value
			fin >> value;

			// Read the rest of the line
			fin.getline(buffer, 1024);

			// Write the value out to the file
			fout << tag << ' ' << (i * 5) + j << ' ' << value << endl;
		}
		
	}
}
