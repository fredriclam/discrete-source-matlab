/// Fast exponential interpolation from dictionary for negative values
/// WARNING! Returns 0 for any positive value, since the Green's function shouldn't even go there

#ifndef DICTIONARYEXP_HPP
#define DICTIONARYEXP_HPP

#include <vector>
#include <array>
#include <math.h>

const double dexp_resolution = 1e-5; // Dictionary spacing 1e-5 (1e-6)
const double dexp_max_magnitude = 25; // Maximum magnitude of argument; beyond this, (e.g. arg < -this, return 0.)
const int entry_count = int(dexp_max_magnitude / dexp_resolution + 2); // Include last element and one more

class DictionaryExp
{
public:
	// Ctor
	DictionaryExp();
	// Fields
	std::vector<double> dict;
	// Methods
	double dexp(double u);
};

#endif // DICTIONARYEXP_HPP