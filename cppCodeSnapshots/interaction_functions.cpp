#include "interaction_functions.hpp"

#define COEFF_3D 0.022448390265645820211135247953461594410273242929353
#define ONE_OVER_4_PI 0.079577471545947667884441881686257181017229822870228

double theta_i_free_3D_newtonian(Particle* p_source, double x_target, double y_target, double z_target, double t)
{
	double time = t - p_source->tau;
	if (time < 1e-9)
		return 0;
#ifdef USE_ZERO_T_R
	double dx = (x_target - p_source->x);
	double dy = (y_target - p_source->y);
	double dz = (z_target - p_source->z);

	return EXP(-heat_loss_parameter*time) * COEFF_3D/(time * sqrt(time)) *
		EXP(-0.25*(dx*dx + dy*dy + dz*dz) / time);
#else
	double dx = (x_target - p_source->x);
	double dy = (y_target - p_source->y);
	double dz = (z_target - p_source->z);
	double r = sqrt(dx*dx + dy*dy + dz*dz);
	double sum = erfcTable::erfc(0.5*r / sqrt(time));
	double time_prime = time - t_r;
	if (time_prime > 1e-9)
		sum -= erfcTable::erfc(0.5*r / sqrt(time_prime));
	return EXP(-heat_loss_parameter*time) * sum * ONE_OVER_4_PI / r / t_r;
#endif
}

double theta_i_periodic_3D_newtonian(Particle* p_source, double x_target, double y_target, double z_target, double t)
{
	// Time since ignition of this source
	double time = t - p_source->tau;
	// Limit as t->tau is zero, along with step (causality) condition: dividing by small number
	if (time < 1e-9)
		return 0.;
	double dx = x_target - p_source->x;
	double dy = y_target - p_source->y;
	double dz = z_target - p_source->z;
	double p_sum = dx*dx + dz*dz;
	double dy_prime;
#ifdef USE_ZERO_T_R
	double inner_coeff = -0.25/time;
	double theta = EXP(inner_coeff*(p_sum + dy*dy));
#pragma unroll
	for (int i = 1; i <= num_images; ++i){
		dy_prime = dy + i*width_Y;
		theta += EXP(inner_coeff*(p_sum + dy_prime*dy_prime));
		dy_prime = dy - i*width_Y;
		theta += EXP(inner_coeff*(p_sum + dy_prime*dy_prime));
	}
	theta *= EXP(-heat_loss_parameter*time) * COEFF_3D / time / sqrt(time);

	return theta;
#else
	double r = sqrt(p_sum + dy*dy);
	double sum = erfcTable::erfc(0.5*r / sqrt(time)) / r;
	double time_prime = time - t_r;
	if (time_prime > 1e-9)
		sum -= erfcTable::erfc(0.5*r / sqrt(time_prime)) /r;

	for (int i = 1; i <= num_images; ++i){
		r = sqrt(p_sum + (dy + i*width_Y)*(dy + i*width_Y));
		sum += erfcTable::erfc(0.5*r / sqrt(time)) / r;
		if (time_prime > 1e-9)
			sum -= erfcTable::erfc(0.5*r / sqrt(time_prime)) / r;

		r = sqrt(p_sum + (dy - i*width_Y)*(dy - i*width_Y));
		sum += erfcTable::erfc(0.5*r / sqrt(time)) / r;
		if (time_prime > 1e-9)
			sum -= erfcTable::erfc(0.5*r / sqrt(time_prime)) / r;
	}

	return EXP(-heat_loss_parameter*time) * ONE_OVER_4_PI * sum / t_r;
#endif // USE_ZERO_T_R

}
