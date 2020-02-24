#include "erfc.hpp"
#include <iostream>

// Table declaration--contains the data
std::vector<double> erfcTable::table;

// Table constants
const double erfcTable::table_max_magnitude = 15; // Maximum magnitude of argument; returns outside of interval [0, this]
int erfcTable::entry_count = 0; // Temporary value

// Read the values of the EI table from file specified
void erfcTable::init(){
	double val;
	
	// Open file for reading
	std::ifstream input_file(erfc_table_file_name.c_str());
	// Update entry_count
	erfcTable::entry_count = int(erfcTable::table_max_magnitude / erfc_table_resolution + 2); // Include last element and one more

	std::cout << entry_count;

	// Reserve size of table
	erfcTable::table.reserve(entry_count);

	while (input_file >> val){
		erfcTable::table.push_back(val);
	}
}

double erfcTable::erfc(double u)
{
	// Outside estimation bounds (note Ei(15) ~ 7e-100, close to zero) return instant result
	if (u < 0)
		return 1;
	else if (u > table_max_magnitude)
		return 0;
	// Calculate lower mark
	int i = int(u / erfc_table_resolution);
	// Interpolation: (1-t)*v_0 + t*v_1 where 0 <= t < 1; note that u < 0; i > 0
	double t = (u - i*erfc_table_resolution) / erfc_table_resolution;
	
	// Linear interpolation
	return (1 - t)*erfcTable::table[i] + t*erfcTable::table[i + 1];
}