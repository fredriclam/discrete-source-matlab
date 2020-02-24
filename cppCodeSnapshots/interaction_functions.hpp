#ifndef INTERACTION_FUNCTIONS_HPP_INCLUDED
#define INTERACTION_FUNCTIONS_HPP_INCLUDED

#include "Particle.hpp"
#include "erfc.hpp"
#include "DictionaryExp.hpp"
#include "controls.hpp"
#include <math.h>

// Pull physical parameters from main.cpp
extern int num_images;
extern double t_r;
extern double width_X;
extern double width_Y;
extern double width_Z;
extern double heat_loss_parameter;

// Generate dictionary table for interpolation
// #ifdef USE_ZERO_T_R
extern DictionaryExp dict;
// #endif

double theta_i_free_3D_newtonian(Particle* p_source, double x_target, double y_target, double z_target, double t);
double theta_i_periodic_3D_newtonian(Particle* p_source, double x_target, double y_target, double z_target, double t);

#endif // INTERACTION_FUNCTIONS_HPP_INCLUDED
