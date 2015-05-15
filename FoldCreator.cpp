#include <iostream>
#include <fstream>
using namespace std;

// Main program
int main()
{
	// Initialize variables
	char buf[1024];
	ifstream fin("HIGGS.csv");
	ofstream fout_1("Higgs_1.csv");
	ofstream fout_2("Higgs_2.csv");
	ofstream fout_3("Higgs_3.csv");
	ofstream fout_4("Higgs_4.csv");
	ofstream fout_5("Higgs_5.csv");
	ofstream fout_6("Higgs_6.csv");
	ofstream fout_7("Higgs_7.csv");
	ofstream fout_8("Higgs_8.csv");
	ofstream fout_test("Higgs_Test.csv");

	// Loop through the file
	for( int counter = 1; counter <= 11000000; ++counter )
	{
		// Read the line
		fin.getline(buf, 1024);

		// Add the point to the correct file
		if( counter <= 1312500 )
		{
			fout_1 << buf;
			if( counter != 1312500 ) { fout_1 << endl; }
		}
		else if( counter <= (2 * 1312500) )
		{
			fout_2 << buf;
			if( counter != (2 * 1312500) ) { fout_2 << endl; }
		}
		else if( counter <= (3 * 1312500) )
		{
			fout_3 << buf;
			if( counter != (3 * 1312500) ) { fout_3 << endl; }
		}
		else if( counter <= (4 * 1312500) )
		{
			fout_4 << buf;
			if( counter != (4 * 1312500) ) { fout_4 << endl; }
		}
		else if( counter <= (5 * 1312500) )
		{
			fout_5 << buf;
			if( counter != (5 * 1312500) ) { fout_5 << endl; }
		}
		else if( counter <= (6 * 1312500) )
		{
			fout_6 << buf;
			if( counter != (6 * 1312500) ) { fout_6 << endl; }
		}
		else if( counter <= (7 * 1312500) )
		{
			fout_7 << buf;
			if( counter != (7 * 1312500) ) { fout_7 << endl; }
		}
		else if( counter <= (8 * 1312500) )
		{
			fout_8 << buf;
			if( counter != (8 * 1312500) ) { fout_8 << endl; }
		}
		else
		{
			fout_test << buf;
			if( counter != 11000000 ) { fout_test << endl; }
		}
	}

	// Close the files
	fin.close();
	fout_1.close();
	fout_2.close();
	fout_3.close();
	fout_4.close();
	fout_5.close();
	fout_6.close();
	fout_7.close();
	fout_8.close();
	fout_test.close();

	// Return
	return 0;
}
