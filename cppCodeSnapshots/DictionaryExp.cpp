#include "DictionaryExp.hpp"

DictionaryExp::DictionaryExp(){
	// Generate the dictionary
	for (int i = 0; i < entry_count; ++i)
		dict.push_back(0);
	// Populate dictionary
#pragma vector always
#pragma ivdep
#pragma distribute_point
	for (int i = 0; i < entry_count; ++i)
		dict[i] = exp(-i*dexp_resolution);
}

double DictionaryExp::dexp(double u)
{
	if (u > 0 || u < -dexp_max_magnitude)
		return 0;
	int i = int(-u / dexp_resolution);
	// Interpolation: (1-t)*v_0 + t*v_1 where 0 <= t < 1
	// Note: u < 0; i > 0
	double t = (-u - i*dexp_resolution) / dexp_resolution;
	return (1-t)*dict[i] + t*dict[i+1];
	// Theoretical FLOPS < 5 + 8 = 13
}