#ifndef RUN_HPP_INCLUDED
#define RUN_HPP_INCLUDED

#include <fstream>
#include <string>
#include <ctime>
#include <sstream>
#include <queue>
#include <iostream>
#include <iomanip>
#include <list>
#include <time.h>
#include <algorithm>
#include <math.h>
#include <chrono>
#include "mt19937ar.h" // Included random library for HPC cluster C++ compiler version compatibility issues
#include "controls.hpp"
#include "Particle.hpp"
#include "interaction_functions.hpp"

// Physical parameters
extern double theta_ign;
extern double t_r;
extern double width_X;
extern double width_Y;
extern double width_Z;

// Problem numerical parameters
extern double dt;
extern double t_timeout;
extern int num_images;
extern double ignite_ratio;
extern double initiation_density_factor;
extern double table_resolution;

// Fixed parameters
extern const double pooling_x_skip;
extern const int input_lines_to_skip;
extern const double tol_bisection;
extern const double tol_bisection_rms;
extern const double promotion_delay;

// Program flags
extern bool gen_field;
extern bool gen_cloud;
extern bool find_rms;

// Post-processing numerical parameters
extern int field_resolution_x;
extern int field_resolution_y;
extern int field_resolution_z;
extern double field_start_t;
extern double field_end_t;
extern int field_steps;

// Functions
double run(std::string input_file_name, int run_label);
void parse_file_3D(std::string file_name, std::vector<Particle*>& universe);
int generate_cloud(std::vector<Particle*>& universe, int run_num);
int generate_pool(std::forward_list<Particle*>& pool, std::vector<Particle*>& list_on, std::forward_list<Particle*>& list_candidate);

#endif // RUN_HPP_INCLUDED
