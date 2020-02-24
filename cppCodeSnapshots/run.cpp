#include "run.hpp"

// Compare by ignition time
bool CompareParticlesByTau(Particle* left, Particle* right){
	return left->tau < right->tau;
}

// Compare by position along direction of front propagation
bool CompareParticlesByX(Particle* left, Particle* right){
	return left->x < right->x;
}

// Parses 2D file into 3D
void parse_file_3D (std::string file_name, std::vector<Particle*>& universe)
{
    // Open file for reading
    std::ifstream input_file(file_name.c_str());
    std::string buff;

    // Skip lines
    for (int i = 0; i < input_lines_to_skip; ++i)
        std::getline(input_file, buff);

    int ID;
    double x, y, z, tau;

    while (input_file >> ID){
        input_file >> x >> y >> tau;
        Particle* p = new Particle(ID, x, y, z, tau);
        universe.push_back(p);
    }
}

// Generates particle cloud (by reference)
int generate_cloud(std::vector<Particle*>& universe, int run_num)
{
	// Seed generation
	// Generate seed from ns since the last second: 0 to 999,999,999
	std::chrono::milliseconds epoch_ms =
		std::chrono::duration_cast<std::chrono::milliseconds> (
		std::chrono::system_clock::now().time_since_epoch());
	std::chrono::microseconds epoch_us =
		std::chrono::duration_cast<std::chrono::microseconds> (
		std::chrono::system_clock::now().time_since_epoch());
	std::chrono::nanoseconds epoch_ns =
		std::chrono::duration_cast<std::chrono::nanoseconds> (
		std::chrono::system_clock::now().time_since_epoch());
	int time_seed = 1000000 * epoch_ms.count() + 1000 * epoch_us.count() + epoch_ns.count();
	// Generate seed from run number and theta_ign combination: theta = 0.375, run 12 -->  12375
	int run_seed = int(theta_ign * 1000) + run_num * 1000;

	// Fixing seed to generate same cloud for testing
#ifdef FIX_SEED
	// Initialize MT19937 with seed 1 to generate the same random cloud for parametric testing
	init_genrand(1);
#else
	// Initialize MT19937 normally
	unsigned long seed_array[2] = { time_seed, run_seed };
	init_by_array(seed_array, 2);
#endif

	// Cloud generation (cylinder geometry, rectangular geometry)
#ifdef CYL_GEOM
#ifdef EXACT_DENSITY
	// Calculate number of particles (rounded down)
	int num_particles = int(0.25*M_PI*width_Y*width_Z*width_X);

	// Else: increase or decrease the density of particles in the initiation zone
	// Accounting for number of particles in initiation zone and outside of initiation zone
	int num_particles_init = num_particles*ignite_ratio*initiation_density_factor;
	int num_particles_noninit = num_particles*(1 - ignite_ratio);
	// Update total number of particles
	num_particles = num_particles_init + num_particles_noninit;
	// Reserve memory  for universe vector
	universe.reserve(num_particles);
	double x_gen, y_gen, z_gen;
	// Generate particles in initiation zone first
	for (int i = 0; i < num_particles_init; ++i){
		// Cookie cutter for uniform random distribution in cylinder
		do{
			y_gen = 0.5*width_Y*(2.0*genrand_real1() - 1.0); // Inclusive endpoints [0,1] generation
			z_gen = 0.5*width_Z*(2.0*genrand_real1() - 1.0); // Inclusive endpoints [0,1] generation
		} while (y_gen*y_gen + z_gen*z_gen > 0.25 * width_Y*width_Z);
		x_gen = width_X*ignite_ratio*genrand_real1();
		Particle* p = new Particle(-1, x_gen, y_gen, z_gen, 0);
		universe.push_back(p);
	}
	// Generate particles in non-initiation zone
	for (int i = 0; i < num_particles_noninit; ++i){
		// Cookie cutter for uniform random distribution in cylinder
		do{
			y_gen = 0.5*width_Y*(2.0*genrand_real1() - 1.0); // Inclusive endpoints [0,1] generation
			z_gen = 0.5*width_Z*(2.0*genrand_real1() - 1.0); // Inclusive endpoints [0,1] generation
		} while (y_gen*y_gen + z_gen*z_gen > 0.25 * width_Y*width_Z);
		x_gen = width_X*(1 - ignite_ratio)*(1-genrand_real2()) + ignite_ratio*width_X; // (0,1] generation
		Particle* p = new Particle(-1, x_gen, y_gen, z_gen, 1e10);
		universe.push_back(p);
	}
#else
	// Calculate number of particles (rounded down)
	int num_particles = int(width_Y*width_Z*width_X);

	// Else: increase or decrease the density of particles in the initiation zone
	// Accounting for number of particles in initiation zone and outside of initiation zone
	int num_particles_init = num_particles*ignite_ratio*initiation_density_factor;
	int num_particles_noninit = num_particles*(1 - ignite_ratio);
	// Update total number of particles
	num_particles = num_particles_init + num_particles_noninit;
	// Reserve memory  for universe vector
	universe.reserve(num_particles);
	double x_gen, y_gen, z_gen;
	// Generate particles in initiation zone first
	for (int i = 0; i < num_particles_init; ++i){
		// Generate coordinates
		y_gen = 0.5*width_Y*(2.0*genrand_real1() - 1.0); // Inclusive endpoints [0,1] generation
		z_gen = 0.5*width_Z*(2.0*genrand_real1() - 1.0); // Inclusive endpoints [0,1] generation
		// Keep point only if it's inside the cylinder
		if (y_gen*y_gen + z_gen*z_gen <= 0.25 * width_Y*width_Z){
			x_gen = width_X*ignite_ratio*genrand_real1();
			Particle* p = new Particle(-1, x_gen, y_gen, z_gen, 0);
			universe.push_back(p);
		}
	}
	// Generate particles in non-initiation zone
	for (int i = 0; i < num_particles_noninit; ++i){
		// Generate coordinates
		y_gen = 0.5*width_Y*(2.0*genrand_real1() - 1.0); // Inclusive endpoints [0,1] generation
		z_gen = 0.5*width_Z*(2.0*genrand_real1() - 1.0); // Inclusive endpoints [0,1] generation
		if (y_gen*y_gen + z_gen*z_gen <= 0.25 * width_Y*width_Z){
			x_gen = width_X*(1 - ignite_ratio)*(1 - genrand_real2()) + ignite_ratio*width_X; // (0,1] generation
			Particle* p = new Particle(-1, x_gen, y_gen, z_gen, 1e10);
			universe.push_back(p);
		}
	}
	// Update again the number of particles
	num_particles = universe.size();
#endif
#else
	// Calculate number of particles
	int num_particles = int(width_X *width_Y*width_Z);
	// Accounting for number of particles in initiation zone and outside of initiation zone
	int num_particles_init = num_particles*ignite_ratio*initiation_density_factor;
	int num_particles_noninit = num_particles*(1-ignite_ratio);
	// Update total number of particles
	num_particles = num_particles_init + num_particles_noninit;
	// Reserve memory  for universe vector
	universe.reserve(num_particles);
	// Generate particles in initiation zone first
	for (int i = 0; i < num_particles_init; ++i){
		Particle* p = new Particle(-1, width_X*ignite_ratio*genrand_real1(), width_Y*genrand_real2(), width_Z*genrand_real1(), 0);
		universe.push_back(p);
	}
	// Generate the rest of the particles
	for (int i = 0; i < num_particles_noninit; ++i){
		Particle* p = new Particle(-1, width_X*(1-ignite_ratio)*(1-genrand_real2()) + ignite_ratio*width_X,
			width_Y*genrand_real2(), width_Z*genrand_real1(), 1e11);
		universe.push_back(p);
	}
	
#endif
	// Sort universe by x
	std::sort(universe.begin(), universe.end(), CompareParticlesByX);
	// Give particles their particle numbers
	for (int i = 0; i < num_particles; ++i){
		universe[i]->particle_number = i + 1;
	}
}

// Generates pool of appropriate particles to work with
int generate_pool(std::forward_list<Particle*>& pool, std::vector<Particle*>& list_on, std::forward_list<Particle*>& list_candidate)
{
    pool.clear();
    int pool_count = 0;
    double front_x = -1e9;
    // Find the farthest x-coordinate of the ignited particles
    for(std::vector<Particle*>::iterator it = list_on.begin(); it != list_on.end(); ++it)
        if ((*it)->x > front_x)
            front_x = (*it)->x;
    // Fill pool with candidate particles
	for (std::forward_list<Particle*>::iterator it = list_candidate.begin(); it != list_candidate.end(); ++it)
        if ((*it)->x < front_x + pooling_x_skip){
            pool.push_front(*it);
            ++pool_count;
        }
    return pool_count;
}

// Executes a run. Assumes universe sorted by x (not too important)
double run(std::string file_name, int run_label)
{
    // Particle lists
    std::vector<Particle*> univ;
    std::forward_list<Particle*> list_off;
    std::vector<Particle*> list_on;
    std::forward_list<Particle*> pool;
    std::vector<Particle*> list_try;
    // Initialize
    double t = 0.;
    double t_section_long = t;
    double t_section_short = t;
    int ignite_count = 0;
    Particle* last_ignited = NULL;
    bool lock_to_wait_list = false;
    int initial_unignited_particles = 0;
    int size_pool = 0;
    int size_list_off = 0;
	int size_list_on = 0;
	int seed = 1;

    // Parse into univ
	if (file_name == ""){
		seed = generate_cloud(univ, run_label);
	}
	else
		parse_file_3D(file_name, univ);
    // Copy all particles with tau == 0 as forced-ignite; everything else is a free-igniting particle
	for (std::vector<Particle*>::iterator it = univ.begin(); it != univ.end(); ++it){
		if ((*it)->tau > 0){
			list_off.push_front(*it);
			++initial_unignited_particles;
		}
		else{
			list_on.push_back(*it);
			++size_list_on;
		}
	}

	// Compute size of list of "off" particles
    size_list_off = initial_unignited_particles;

    // Generate time-stamped file output stream, file names etc.
    std::ostringstream oss;
	// Name according to run number or file name
	if (file_name == ""){
		oss << "n" << run_label << "s" << seed;
	}
	else
		oss << "-" << file_name << "-fixed";
	std::string label = oss.str().c_str();

#if OUTPUT_MODE==1
	// Empty output string stream and write abbreviated date string
	oss.str(std::string());
	//// Simple string
	//oss << "SOLN" << label << ".dat";

	// Date string
	oss << "SOLN" << (int(1000 * theta_ign)) << "+" << int(1000 * t_r) << "+";
	time_t current_time = time(0);
	struct tm *now = localtime(&current_time);

#ifdef CYL_GEOM
	std::string geom_identifier = "cyl";
#else
	std::string geom_identifier = "slab";
#endif

	oss << now->tm_mon + 1 << "-" <<
		now->tm_mday << " " <<
		now->tm_hour << "h" <<
		now->tm_min << "m" <<
		now->tm_sec << "s" <<
		run_label << "id" <<
		"+" << geom_identifier << 1000000 * theta_ign + 1000*t_r;
		".dat";

	std::ofstream output_file(oss.str().c_str(), std::ofstream::out);
	// Backup (live outputstream)
	oss.str(std::string());
	oss << "BACK" << label << ".dat";
	std::ofstream live_output_file(oss.str().c_str(), std::ofstream::out);
	// Misc output: t / <h> / first-last thickness
	oss.str(std::string());
	oss << "MISC" << label << ".dat";
	std::ofstream aux_file(oss.str().c_str(), std::ofstream::out);
	// Temperature field
	oss.str(std::string());
	oss << "TFLD" << label << ".dat";
	std::string field_output_name = oss.str().c_str();
	std::ofstream field_output;
	if (gen_field)
		field_output.open(field_output_name, std::ofstream::out);
	// RMS width
	oss.str(std::string());
	oss << "RMSW" << label << ".dat";
	std::string rms_output_name = oss.str().c_str();
	std::ofstream rms_file;
	if (find_rms)
		rms_file.open(rms_output_name, std::ofstream::out);
	// Height function output
	oss.str(std::string());
	oss << "HOFY" << label << ".dat";
	std::string h_output_name = oss.str().c_str();
	std::ofstream h_file;
	if (find_rms)
		h_file.open(h_output_name, std::ofstream::out);

	// Grab date
	oss.str(std::string());
	oss << now->tm_mon + 1 << "-" <<
		now->tm_mday << " " <<
		now->tm_hour << "h" <<
		now->tm_min << "m" <<
		now->tm_sec << "s";
	// Write output tag
	output_file << std::scientific << "PARAMETERS - theta_ign: " << theta_ign << " dt: " << dt <<
		" x_skip: " << pooling_x_skip << " tau_c (t_r): " << t_r << " t_timeout: " << t_timeout <<
		" table_res: " << erfc_table_resolution << " images: " << num_images <<
		" X: " << width_X << " Y: " << width_Y << " Run date: " << oss.str().c_str() << '\n';
#elif OUTPUT_MODE==2
	// Alternative output code
	// Front speed output
	oss.str(std::string()); // Empty output string stream and write abbreviated date string
	oss << "FSPD" << label << ".dat";
	std::ofstream fspd_output_file(oss.str().c_str(), std::ofstream::out);

	// PDF contribution output
	oss.str(std::string());
	oss << "PDFC" << label << ".dat";
	std::ofstream pdf_output_file(oss.str().c_str(), std::ofstream::out);

	// Grab date
	oss.str(std::string());
	time_t current_time = time(0);
	struct tm *now = localtime(&current_time);
	oss << now->tm_mon + 1 << "-" <<
		now->tm_mday << " " <<
		now->tm_hour << "h" <<
		now->tm_min << "m" <<
		now->tm_sec << "s";

	// Write output tag
	output_file << std::scientific << "PARAMETERS - theta_ign: " << theta_ign << " dt: " << dt <<
		" x_skip: " << pooling_x_skip << " tau_c (t_r): " << t_r << " t_timeout: " << t_timeout <<
		" table_res: " << erfc_table_resolution << " images: " << num_images <<
		" X: " << width_X << " Y: " << width_Y << " Run date: " << oss.str().c_str() << '\n';
#else
#endif


    // Init update queue
    std::queue<double> update_queue;

    // Outer loop -- until particles run out
    while (ignite_count < initial_unignited_particles && t < t_timeout){
        // Introduce newly ignited particle
        if (last_ignited != NULL){
			for (std::forward_list<Particle*>::iterator it = pool.begin(); it != pool.end(); ++it)
                (*it)->link_particle(last_ignited);
            update_queue.push(t + Particle::poly_promotion_time + 1e-9);
            last_ignited = NULL;
        }
        // Pooling
        if (lock_to_wait_list)
            pool = list_off;
        else{
            // Deep copy vector
            std::vector<Particle*> pool_prev;
			for (std::forward_list<Particle*>::iterator it = pool.begin(); it != pool.end(); ++it)
                pool_prev.push_back(*it);
            size_pool = generate_pool(pool, list_on, list_off);
			for (std::forward_list<Particle*>::iterator it = pool.begin(); it != pool.end(); ++it){
                bool isNew = true;
                // Check if particle is fresh
                for (std::vector<Particle*>::iterator jt = pool_prev.begin(); jt != pool_prev.end(); ++jt)
                    if ((*it) == (*jt))
                        isNew = false;
                if (isNew){
                    (*it)->update_all(list_on, t);
                }
            }
        }
        if (size_pool >= size_list_off)
            lock_to_wait_list = true;

        bool close_in = false;
        double t_over = 0.;
        double t_under = 0.;
        Particle* first_ignited_particle = NULL;

        // Inner loop -- search for ignition
        while (!close_in && t < t_timeout){
            list_try.clear();
            // Update hierarchy
            if (t-t_section_long > Particle::t_section_long_max){
				for (std::forward_list<Particle*>::iterator it = pool.begin(); it != pool.end(); ++it){
                    (*it)->update_all(list_on, t);
                }
                // Update section time variables
                t_section_long = t;
                t_section_short = t;
                // Flush queue
                std::queue<double> new_queue;
                std::swap(new_queue,update_queue);
            }
            else if (t-t_section_short > Particle::t_section_short_max){
				for (std::forward_list<Particle*>::iterator it = pool.begin(); it != pool.end(); ++it){
                    (*it)->update_poly_short(t);
                }
                t_section_short = t;
            }
            else if (update_queue.size() > 0 && t > update_queue.front()){
				for (std::forward_list<Particle*>::iterator it = pool.begin(); it != pool.end(); ++it){
                    (*it)->update_nonpoly(t);
                }
                update_queue.pop();
            }

			for (std::forward_list<Particle*>::iterator it = pool.begin(); it != pool.end(); ++it){
                double theta;
                // Use approx theta or override
#ifndef USE_THETA_EXACT
				theta = (*it)->theta_approx(t); ////////
#else
				theta = (*it)->theta_exact(list_on, t);
#endif
                if (theta > Particle::poly_adjust_factor * theta_ign){
                    theta = (*it)->theta_exact(list_on, t);
                }
                // Check for ignition
                if (theta > theta_ign){
                    t_over = t;
                    t_under = t - dt;
                    close_in = true;
                    list_try.push_back(*it);
					// On ignition event
                }
            }
            // Time-step
            if (!close_in){
                t += dt;
            }
            // Bisection root-finding
            else{
                // Check for each eligible particle's ignition
                for (std::vector<Particle*>::iterator it = list_try.begin(); it != list_try.end(); ++it){
                    double t_low = t_under;
                    double t_high = t_over;
                    while (t_high - t_low > tol_bisection){
						double phi = (*it)->theta_exact(list_on, 0.5 * (t_high + t_low)) - theta_ign;
                        if (phi >= 0)
                            t_high = 0.5 * (t_high + t_low);
                        else
                            t_low = 0.5*(t_high + t_low);
                    }
                    // Save the time to particle's memory
                    (*it)->memory = 0.5*(t_high + t_low);
                }
                // Filter out first ignition
                first_ignited_particle = list_try.front();
                double t_ignition_earliest = first_ignited_particle->memory;
                for (std::vector<Particle*>::iterator it = ++list_try.begin(); it != list_try.end(); ++it){
                    if ((*it)->memory < t_ignition_earliest){
                        first_ignited_particle = *it;
                        t_ignition_earliest = (*it)->memory;
                    }
                }
                // Set time to the earliest ignition time
                t = t_ignition_earliest;
            }

            // Process ignited particle if found
            if (close_in){
                first_ignited_particle->tau = t;
                list_on.push_back(first_ignited_particle);
                list_off.remove(first_ignited_particle);
                last_ignited = first_ignited_particle;
                --size_list_off;
				++size_list_on;
				// Disabled stdout and live output
				// std::cout << std::scientific << std::setprecision(15) << first_ignited_particle->particle_number << "\t" << t << std::endl;
                // Live file output
#if OUTPUT_MODE==1
                live_output_file << std::scientific << std::setprecision(15) << first_ignited_particle->particle_number << "\t" <<
					first_ignited_particle->x << "\t" <<
					first_ignited_particle->y << "\t" <<
					first_ignited_particle->z << "\t" <<
					first_ignited_particle->tau << '\n';
#endif

				// Extract first-on-last-off
				double x_min = width_X;
				double x_max = 0;
				for (std::vector<Particle*>::iterator it = list_on.begin(); it != list_on.end(); ++it){
					double x = (*it)->x;
					if (x > x_max)
						x_max = x;
				}
				for (std::forward_list<Particle*>::iterator it = list_off.begin(); it != list_off.end(); ++it){
					double x = (*it)->x;
					if (x < x_min)
						x_min = x;
				}
#if OUTPUT_MODE==1
				aux_file << std::scientific << std::setprecision(15) << t << "\t" << x_max - x_min << "\n";
#endif

                first_ignited_particle->cleanup();
                ++ignite_count;
				// Debug
#if OUTPUT_MODE==1
				std::cout << ignite_count << " @ " << t << std::endl;
				if (ignite_count % 1000 == 0)
					std::cout << ignite_count * 100.0 / univ.size() << "%" << std::endl;
#endif
            }
        }
    }
    // Sort list by tau
	//std::forward_list<Particle*> output_list;
	// Copy list_on to new output list (container change for sorting)
	//for (std::vector<Particle*>::iterator it = list_on.begin(); it != list_on.end(); ++it)
	//	output_list.push_front(*it);
	//output_list.sort(CompareParticlesByTau);

	double final_front_x = 0;
	for (std::vector<Particle*>::iterator it = list_on.begin(); it != list_on.end(); ++it){
#ifndef SUPPRESS_INDIVIDUAL_OUTPUT
		output_file << (*it)->particle_number << "\t" << std::scientific << std::setprecision(15) << (*it)->x << "\t" << (*it)->y << "\t" << (*it)->z << "\t" << (*it)->tau << '\n';
#endif
		double x_temp = (*it)->x;
		if (x_temp > final_front_x)
			final_front_x = x_temp;
	}
	int num_cold_particles = 0;
	for (std::forward_list<Particle*>::iterator it = list_off.begin(); it != list_off.end(); ++it){
#ifndef SUPPRESS_INDIVIDUAL_OUTPUT
		output_file << (*it)->particle_number << "\t" << std::scientific << std::setprecision(15) << (*it)->x << "\t" << (*it)->y << "\t" << (*it)->z << "\t" << (*it)->tau << '\n';
#endif
		num_cold_particles++;
	}

	// Cleanup
	for (std::vector<Particle*>::iterator it = univ.begin(); it != univ.end(); ++it){
		delete (*it);
	}


	// Return max front distance
	return (final_front_x - width_X*ignite_ratio) / (width_X*(1 - ignite_ratio));
	//// Return final ignition proportion
	//return 1. -  double(num_cold_particles) / double(initial_unignited_particles); // ignite_count * 100.0 / univ.size();

}