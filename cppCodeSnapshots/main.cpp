/* Discrete Source Flame

STRUCTURE:
main.cpp					Interface and main control parameters
run.cpp						Modular single-run code
Particle2D.cpp				Particle object for organization
mt19937ar.cpp				Mersenne Twister 19937 in C (Nishimura et al.) for compatibility for older C++ versions

MATH:
interaction_functions.cpp	Temperature contribution function wrappers
DictionaryExp.cpp			Interpolated exponential function
erfc.cpp					Interpolated / Taylor erfc function
*/

#include <string>
#include <ctime>
#include <iostream>
#include <sstream>
#include <stdlib.h>
#include <fstream>

#include "run.hpp"
#include "erfc.hpp"
#include "DictionaryExp.hpp"
#include "controls.hpp"

// Physical parameters
double theta_ign = 0;  // Ignition temperature
double t_r = 0;        // Reaction time of source
double heat_loss_parameter = 0;
double width_X = 0;    // Width of domain in x (propagation)
double width_Y = 0;    // Width of domain in y (width-wise)
double width_Z = 0;    // Width of domain in z (height-wise)

// Problem numerical parameters
double dt = 0;                        // Ignition search timestep
double t_timeout = 0;                 // Timeout for problem
int num_images = 1;                   // Number of periodic images to place (1 == 1 on both sides)
double ei_table_resolution = 1e-99;    // Resolution of ei_table used for Ei(x) (linear) interpolation
double erfc_table_resolution = 1e-99;  // Resolution of erfc_table used for erfc(x) (linear) interpolation
double ignite_ratio = 0.1;            // Percent of the domain to ignite (number of particles)
double initiation_density_factor = 1; // Factor of density of particles in initiation zone (boost >1 or chill <1 flame)

// Fixed parameters
const double pooling_x_skip = 2; //9 //1.5    // Distance beyond farthest ignited particle to look in for next ignition (arbitrary, tuned)
const int input_lines_to_skip = 1;     // Number of input lines to skip in reading SOLN files
const double tol_bisection = 1e-7;     // Tolerance for bisection for ignition time
const double tol_bisection_rms = 1e-4; // Tolerance for bisection for ignition iso-contour position (post-processing)
const double promotion_delay = 1e-9;   // Makes sure there's no update miss: interpl'n

// Program flags
bool gen_cloud = true;  // Generate cloud from random number generator
bool gen_field = false; // Generate temperature field (discrete sampling)
bool find_rms = false;  // Search for front and take standard-deviation of front x-position

// Post-processing numerical parameters
int field_resolution_x = 0; // Divisions of discretization in direction of flame propagation (for finding front)
int field_resolution_y = 0; // Resolution of front-searching grid in width-wise dimension
int field_resolution_z = 0; // Resolution of front-searching grid in height-wise dimension
double field_start_t = 0;   // First value of t to sample
double field_end_t = 0;		// Last value of to sample
int field_steps = 0;	    // Number of steps used to divide sampling into interval (log), (sampled points == field_steps + 1)

// Set analysis variables
int ensemble_size;
double nominal_dimension;
double spread_factor;
int spread_radius;
double aspect_ratio;

// File names
std::string config_file_name = "batch_config.dat";

// Temporary variables
std::string erfc_table_file_name = "";

void parse_int(std::ifstream& input_file, int& input){
	std::string buffer;
	getline(input_file, buffer);
	// Find in next line, after "=" symbol
	std::istringstream iss(buffer.substr(buffer.find("=") + 1));
	iss >> input;
	// Clear string stream (destroyed anyway)
	// iss.str(std::string());
	// iss.clear();
}

void parse_double(std::ifstream& input_file, double& input){
	std::string buffer;
	getline(input_file, buffer);
	// Find in next line, after "=" symbol
	std::istringstream iss(buffer.substr(buffer.find("=") + 1));
	iss >> input;
}

std::string format_tag(std::string key, std::string value){
	std::stringstream ss;
	ss << "{" << key << ":" << value << "}";
	return ss.str().c_str();
}

std::string format_tag(std::string key, double value){
	std::stringstream ss;
	ss << "{" << key << ":" << value << "}";
	return ss.str().c_str();
}

std::string format_tag(std::string key, int value){
	std::stringstream ss;
	ss << "{" << key << ":" << value << "}";
	return ss.str().c_str();
}

// Config reader
void get_batch_config(){
	// Open config file
	std::ifstream input_file(config_file_name);
	// Reads everything in this hard-coded fashion
	parse_double(input_file, theta_ign);
	parse_double(input_file, t_r);
	parse_double(input_file, dt);
	parse_double(input_file, t_timeout);
	parse_double(input_file, width_X);
	parse_double(input_file, width_Y);
	parse_double(input_file, width_Z);
	parse_int(input_file, num_images);
	parse_double(input_file, erfc_table_resolution);
	parse_double(input_file, ignite_ratio); // Percent of space that initiation zone takes up
	parse_double(input_file, initiation_density_factor);
	parse_int(input_file, ensemble_size);
	parse_double(input_file, nominal_dimension);
	parse_double(input_file, spread_factor);
	parse_int(input_file, spread_radius);
	parse_double(input_file, aspect_ratio);
	parse_double(input_file, heat_loss_parameter);
	input_file.close();
}

//void get_config(){
//	// Open config file
//	std::ifstream input_file(config_file_name);
//	// Reads everything in this hard-coded fashion
//	parse_double(input_file, theta_ign);
//	parse_double(input_file, t_r);
//	parse_double(input_file, dt);
//	parse_double(input_file, t_timeout);
//	parse_double(input_file, width_X);
//	parse_double(input_file, width_Y);
//	parse_double(input_file, width_Z);
//	parse_int(input_file, num_images);
//	parse_double(input_file, ei_table_resolution);
//	parse_int(input_file, field_resolution_x);
//	parse_int(input_file, field_resolution_y);
//	parse_int(input_file, field_resolution_z);
//	parse_double(input_file, field_start_t);
//	parse_double(input_file, field_end_t);
//	parse_int(input_file, field_steps);
//	parse_double(input_file, ignite_ratio);
//	parse_double(input_file, initiation_density_factor);
//	input_file.close();
//}

// #ifdef USE_ZERO_T_R // Must be here to resolve dictionary externally
// Create dictionary exponential object
DictionaryExp dict;
// #endif

int main(int argc, char* argv[])
{
	std::cout << "Discrete Source Flame 3D\n";
	// Management variables
	std::string file_name = "";
	std::string buffer;
	int num_runs;
	int run_number;
	int set_number = 0; // The number identifying this set of runs
	std::string* files_to_run;

	// Read configurations
	get_batch_config();

	// Replace parameters with command line arguments **** -- never mind, just use standard input
	// 1. Theta_ign
	// 2. Tau_c
	// 3. nominal_dimension
	std::cin >> buffer;
	theta_ign = atof(buffer.c_str());
	std::cin >> buffer;
	t_r = atof(buffer.c_str());
	std::cin >> buffer;
	nominal_dimension = atof(buffer.c_str());
	std::cin >> buffer;
	set_number = atoi(buffer.c_str());

	//// Replace parameters with command line arguments ***** 1:
	//// 1. Theta_ign
	//// 2. Tau_c
	//// 3. nominal_dimension
	//for (int i = 1; i < argc; i++){
	//	if (i == 1)
	//		theta_ign = atof(argv[1]);
	//	else if (i == 2)
	//		t_r = atof(argv[2]);
	//	else if (i == 3)
	//		nominal_dimension = atof(argv[3]);
	//	else if (i == 4)
	//		set_number = atof(argv[4]);
	//}

#ifdef USE_ZERO_T_R // When t_r = 0, use Green's function solution
	std::cout << "Using zero t_r: ignoring t_r value.\n";
#else
	// Check for t_r = 0 in a t_r != 0 compilation, and if so quit program
	if (t_r == 0){
		std::cout << "Error: using zero t_r in nonzero t_r implementation.\n";
		std::cout << "Change to zero t_r compilation or change settings.\n";
		std::cin >> buffer;
		return 0;
	}
	// Table path based on resolution
	if (erfc_table_resolution == 1e-6){
		erfc_table_file_name = "erfc_table_6.dat";
	}
	else if (erfc_table_resolution == 1e-5){
		erfc_table_file_name = "erfc_table_5.dat";
	}
	else{
		std::cout << "Unknown erfc table size; check config.dat\n";
		std::cin >> buffer;
		return 1;
	}
	std::cout << "\"" << erfc_table_file_name << "\" must be locatable!\n";
	std::cout << std::endl;
	std::cout << "Loading table...may take ~30 seconds for 1e-5 tables!\n";

	// Initialize table
	erfcTable::init();
	std::cout << "Loading complete.\n";
#endif

    // Output all run parameters to stdout
	std::cout << "theta_ign:\t\t\t" << theta_ign << "\n";
#ifndef USE_ZERO_T_R
	std::cout << "t_r: \t\t" << t_r << "\n";
#endif
	std::cout << "\n";
	std::cout << "dt: \t\t\t\t" << std::scientific << dt << "\n";
	std::cout << "t_timeout: \t\t\t" << t_timeout << "\n";
	std::cout << "width_X: \t\t\t" << width_X << "\n";
	std::cout << "width_Y: \t\t\t" << width_Y << "\n";
	std::cout << "width_Z: \t\t\t" << width_Z << "\n";
	std::cout << "num_images: \t\t\t" << num_images << "\n";
	std::cout << "field_resolution_x: \t\t" << field_resolution_x << "\n";
	std::cout << "field_resolution_y: \t\t" << field_resolution_y << "\n";
	std::cout << "field_resolution_z: \t\t" << field_resolution_z << "\n";
	std::cout << "field_interval: \t\t" << field_start_t << " to " << field_end_t << " by " << field_steps << " steps\n";
	std::cout << "ignite_ratio: \t\t\t" << ignite_ratio << "\n";
	std::cout << "initiation_density_factor: \t" << initiation_density_factor << "\n";
	std::cout << std::endl;

	// Hard-coded control flags
	gen_cloud = GEN_CLOUD;
	gen_field = GEN_FIELD;
	find_rms = FIND_RMS;

	// Prepare output file
#ifdef CYL_GEOM
	std::string geometry = "cylinder";
#else
	std::string geometry = "slab";
#endif
	// Get time
	std::ostringstream oss;
	oss.str(std::string());
	oss << "PROP" << (int(1000 * theta_ign)) << "+" << int(1000*t_r) << geometry << set_number << "+";
	time_t current_time = time(0);
	struct tm *now = localtime(&current_time);
	oss << now->tm_mon + 1 << "-" <<
		now->tm_mday << " " <<
		now->tm_hour << "h" <<
		now->tm_min << "m" <<
		now->tm_sec << "s" <<
		".dat";
	// Propagation details output
	std::ofstream prop_output_file(oss.str().c_str(), std::ofstream::out);

	// Parameters header
	prop_output_file << "PARAMETERS:";
	prop_output_file << format_tag("geometry", geometry);
	prop_output_file << format_tag("tau_c", t_r);
	prop_output_file << format_tag("theta_ign", theta_ign);
	prop_output_file << format_tag("dt", dt);
	prop_output_file << format_tag("t_timeout", t_timeout);
	prop_output_file << format_tag("num_images", num_images);
	prop_output_file << format_tag("table_resolution", erfc_table_resolution);
	prop_output_file << format_tag("ignite_ratio", ignite_ratio);
	prop_output_file << format_tag("initiation_density_factor", initiation_density_factor);
	prop_output_file << format_tag("ensemble_size", ensemble_size);
	prop_output_file << format_tag("nominal_dimension", nominal_dimension);
	prop_output_file << format_tag("spread_factor", spread_factor);
	prop_output_file << format_tag("spread_radius", spread_radius);
	prop_output_file << format_tag("aspect_ratio", aspect_ratio);
	prop_output_file << "\n";

	// Set run number (kind of for seeding purposes)
	run_number = 1;

	// Run once at nominal dimension

	// Process domain size
	width_Z = nominal_dimension;
	width_X = aspect_ratio*nominal_dimension;
#ifdef CYL_GEOM
	width_Y = nominal_dimension;
#else
	width_Y = aspect_ratio*nominal_dimension;
#endif

	prop_output_file << nominal_dimension << '\t';
	// Run ensemble for current geometry
	for (int j = 0; j < ensemble_size; ++j){
		double percent_ignited = run("", set_number * 10000 + run_number); // Mixed identifier
		// Output propagation percentage
		prop_output_file << percent_ignited << '\t';
		++run_number;
	}
	prop_output_file << '\n';


	for (int i = 1; i <= spread_radius; ++i){

		// Calculate primary dimension
		//double lower_primary_dimension = nominal_dimension * pow(1-spread_factor,i); // Using exponential spread
		double lower_primary_dimension = nominal_dimension * (1 - i*spread_factor); // Using linear spread
		double higher_primary_dimension = nominal_dimension + (nominal_dimension - lower_primary_dimension);

		// Process domain size
		width_Z = lower_primary_dimension;
		width_X = aspect_ratio*lower_primary_dimension;
#ifdef CYL_GEOM
		width_Y = lower_primary_dimension;
#else
		width_Y = aspect_ratio*lower_primary_dimension;
#endif

		prop_output_file << lower_primary_dimension << '\t';
		// Run ensemble for current geometry
		for (int j = 0; j < ensemble_size; ++j){
			double percent_ignited = run("", run_number);
			// Output propagation percentage
			prop_output_file << percent_ignited << '\t';
			++run_number;
		}
		prop_output_file << '\n';

		// Process domain size
		width_Z = higher_primary_dimension;
		width_X = aspect_ratio*higher_primary_dimension;
#ifdef CYL_GEOM
		width_Y = higher_primary_dimension;
#else
		width_Y = aspect_ratio*higher_primary_dimension;
#endif

		prop_output_file << higher_primary_dimension << '\t';
		// Run ensemble for current geometry
		for (int j = 0; j < ensemble_size; ++j){
			double percent_ignited = run("", set_number*10000+run_number); // Mixed identifier
			// Output propagation percentage
			prop_output_file << percent_ignited << '\t';
			++run_number;
		}
		prop_output_file << '\n';

	}


}
