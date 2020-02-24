/// Erfc Estimator operating over range 0 to 20+. Uses hard-coded static table to interpolate
/// non-negative values. Only interpolates, returns zero outside of operating range.

#ifndef ERFC_HPP
#define ERFC_HPP

#include <vector>
#include <fstream>
#include <string>
#include <math.h>
#include "controls.hpp"

// External file parameters
extern double erfc_table_resolution;
extern std::string erfc_table_file_name;

class erfcTable
{
public:
	static void init();
	static std::vector<double> table;
	static double erfc(double u);
	static const double table_max_magnitude; // Maximum magnitude of argument
	static int entry_count; // Include last element and one more
};

#endif // ERFC_HPP