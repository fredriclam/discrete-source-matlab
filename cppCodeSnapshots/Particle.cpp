#include "Particle.hpp"
#include "interaction_functions.hpp"

const double Particle::poly_nodes[] = { 0.02447174185, 0.2061073739, 0.5, 0.7938926261, 0.9755282581 };

// Cutoff properties from the MATLAB error surface of each polynomial -- from 2D open boundaries
const double Particle::poly_cutoff_t_long_3 = 1;
const double Particle::poly_cutoff_x_long_3 = 10;
const double Particle::poly_cutoff_t_long_5 = 0.4;
const double Particle::poly_cutoff_x_long_5 = 6.;
const double Particle::poly_cutoff_t_short_3 = 0.12;
const double Particle::poly_cutoff_x_short_3 = 3.5;
const double Particle::poly_cutoff_t_short_5 = 0.045;
const double Particle::poly_cutoff_x_short_5 = 2.2;
 //const double Particle::poly_cutoff_t_long_3 = 0.97;
 //const double Particle::poly_cutoff_x_long_3 = 9;
 //const double Particle::poly_cutoff_t_long_5 = 0.37;
 //const double Particle::poly_cutoff_x_long_5 = 5.7;
 //const double Particle::poly_cutoff_t_short_3 = 0.11;
 //const double Particle::poly_cutoff_x_short_3 = 3.4;
 //const double Particle::poly_cutoff_t_short_5 = 0.043;
 //const double Particle::poly_cutoff_x_short_5 = 2.15;
// Long and short sections
 const double Particle::t_section_long_max = 1e-1;
 const double Particle::t_section_short_max = 1e-2;
// Time to promote nonpoly to any polynomial representation; minimum of the poly_cutoff_t values
 const double Particle::poly_promotion_time = poly_cutoff_t_short_5;
// Factor to account for the uniform percent error of the series representations, with some safety margin (0.95)
#ifndef IGNITION_CHECK_FACTOR
 const double Particle::poly_adjust_factor = 0.98;
#else
 const double Particle::poly_adjust_factor = IGNITION_CHECK_FACTOR;
#endif

Particle::Particle(int particle_number_, double x_, double y_, double z_, double tau_)
{
    particle_number = particle_number_;
    x = x_;
    y = y_;
	  z = z_;
    tau = tau_;
    // Set polynomial coefficient arrays to zero
    for (int i = 0; i < 5; ++i){
        poly_short[i] = 0;
        poly_long[i] = 0;
    }
    // Set to zero the pivot times
    pivot_short = 0;
    pivot_long = 0;
}

Particle::~Particle()
{
    cleanup();
}

// Calculates polynomial contribution of one particle using 3 nodes (low precision)
void Particle::calculate_contributions_3(Particle* p_source, double t, double h, double poly[])
{
    // Local arrays to compute Newton DDs
    double values[3] = {0,0,0};
    double temp[3] = {0,0,0};
	// Sample points in future
#pragma unroll(3)
	for (int i = 0; i < 3; ++i){
		values[i] = THETA_I(p_source, this->x, this->y, this->z, t + h*Particle::poly_nodes[2 * i]);
	}
    // Compute Newton Divided Differences
#pragma unroll
    for (int i = 1; i < 3; ++i){
        for (int j = i; j < 3; ++j)
            temp[j] = (values[j]-values[j-1])/
                      (h*(Particle::poly_nodes[2*j]-Particle::poly_nodes[2*(j-i)]));
        for (int j = i; j < 3; ++j)
            values[j] = temp[j];
    }
#pragma unroll
    for (int i = 0; i < 3; ++i)
        poly[2*i] += values[2-i];
}

// Calculates polynomial contribution of one particle using 5 nodes (high precision)
void Particle::calculate_contributions_5(Particle* p_source, double t, double h, double poly[])
{
    int nodes = 5;
    // Local arrays to compute Newton DDs
    double values[5] = {0,0,0,0,0};
    double temp[5] = {0,0,0,0,0};
	// Sample points in future
	for (int i = 0; i < nodes; ++i)
		values[i] = THETA_I(p_source, this->x, this->y, this->z, t + h*Particle::poly_nodes[i]);
	// Compute Newton Divided Differences
	for (int i = 1; i < nodes; ++i){
        for (int j = i; j < nodes; ++j)
            temp[j] = (values[j]-values[j-1])/
                      (h*(Particle::poly_nodes[j]-Particle::poly_nodes[j-i]));
        for (int j = i; j < nodes; ++j)
            values[j] = temp[j];
    }
    for (int i = 0; i < nodes; ++i)
        poly[i] += values[nodes-1-i];
}

void Particle::update_all(std::vector<Particle*>& list_on, double t)
{
    for (int i = 0; i < 5; ++i){
        poly_long[i] = 0;
        poly_short[i] = 0;
    }
    list_nonpoly.clear();
    list_poly_short.clear();
    pivot_long = t;
    pivot_short = t;

    for (std::vector<Particle*>::iterator it = list_on.begin(); it != list_on.end(); ++it){
        double time = t-(*it)->tau;
		double dx = fabs(x - (*it)->x);
        bool in_non_poly = false;
        bool in_poly_short = false;

        if (time > poly_cutoff_t_long_3 || dx > poly_cutoff_x_long_3)
            calculate_contributions_3(*it, t, Particle::t_section_long_max, poly_long);
		else if (time > poly_cutoff_t_long_5 || dx > poly_cutoff_x_long_5)
            calculate_contributions_5(*it, t, Particle::t_section_long_max, poly_long);
		else if (time > poly_cutoff_t_short_3 || dx > poly_cutoff_x_short_3){
            calculate_contributions_3(*it, t, Particle::t_section_short_max, poly_short);
            in_poly_short = true;
        }
		else if (time > poly_cutoff_t_short_5 || dx > poly_cutoff_x_short_5){
            calculate_contributions_5(*it, t, Particle::t_section_short_max, poly_short);
            in_poly_short = true;
        }
        else
            in_non_poly = true;

        if (in_non_poly)
            list_nonpoly.push_front(*it);
        else if (in_poly_short)
            list_poly_short.push_back(*it);
    }
}

void Particle::update_poly_short (double t)
{
    // Wipe polynomial array
    for (int i = 0; i < 5; ++i)
        poly_short[i] = 0;
    pivot_short = t;
    for (std::vector<Particle*>::iterator it = list_poly_short.begin(); it != list_poly_short.end(); ++it){
        double time = t-(*it)->tau;
        if (time > poly_cutoff_t_short_3)
            calculate_contributions_3((*it), t, Particle::t_section_short_max, poly_short);
        else
            calculate_contributions_5((*it), t, Particle::t_section_short_max, poly_short);
    }
}

void Particle::update_nonpoly (double t)
{
	// Operate on front of list
	while (!list_nonpoly.empty() && t - (*list_nonpoly.begin())->tau > poly_cutoff_t_short_5){
		// Move to poly-short list
		calculate_contributions_5((*list_nonpoly.begin()), pivot_short, Particle::t_section_short_max, poly_short);
		list_poly_short.push_back(*list_nonpoly.begin());
		// Remove from non-poly list
		list_nonpoly.pop_front();
	}
	if (!list_nonpoly.empty()){
		// Fast and slow pointers for deletion
		std::forward_list<Particle*>::iterator it_slow = list_nonpoly.begin();
		std::forward_list<Particle*>::iterator it_fast = list_nonpoly.begin();
		// Desync iterators
		it_fast++;

		// If list is not size 1
		if (it_fast != list_nonpoly.end()){
			do {
				// Check for promotion
				if (t - (*it_fast)->tau > poly_cutoff_t_short_5){
					// Move to poly-short list
					calculate_contributions_5((*it_fast), pivot_short, Particle::t_section_short_max, poly_short);
					list_poly_short.push_back(*it_fast);
					// Remove from non-poly list
					it_fast = list_nonpoly.erase_after(it_slow);
				}
				else{
					++it_slow;
					++it_fast;
				}
			} while (it_fast != list_nonpoly.end());
		}
	}


	// O(m*n) version
	// for (std::forward_list<Particle*>::iterator it = list_nonpoly.begin(); it != list_nonpoly.end(); ++it){
	//     if (t-(*it)->tau > poly_cutoff_t_short_5){
	//         calculate_contributions_5((*it), pivot_short, Particle::t_section_short_max, poly_short);
	//         list_poly_short.push_back(*it);
			//// Remove from list
			//list_nonpoly.remove(*it);
	//     }
	// }
	// // Eats speed, but trashes the pointers in the nonpoly list
	// for (std::vector<Particle*>::iterator it = list_poly_short.begin(); it != list_poly_short.end(); ++it){
	//     list_nonpoly.remove(*it);
	// }
}

void Particle::link_particle(Particle* p)
{
    list_nonpoly.push_front(p);
}

double Particle::theta_approx(double t)
{
    double theta = 0;
    // Compute long contribution
    double time = t-pivot_long;
    for (int i = 0; i < 5; ++i){
        theta *= time - t_section_long_max * poly_nodes[4-i];
        theta += poly_long[i];
    }
    // Compute short contribution
    double temp = 0;
    time = t-pivot_short;
    for (int i = 0; i < 5; ++i){
        temp *= time - t_section_short_max * poly_nodes[4-i];
        temp += poly_short[i];
    }
    theta += temp;
    // Compute non polynomial contribution
#pragma unroll
    for (std::forward_list<Particle*>::iterator it = list_nonpoly.begin(); it != list_nonpoly.end(); ++it){
		theta += THETA_I(*it, this->x, this->y, this->z, t);
    }
    return theta;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
double Particle::theta_exact(std::vector<Particle*>& list_on, double t)
{
    double theta = 0;

	for (std::vector<Particle*>::iterator it = list_on.begin(); it != list_on.end(); ++it){
		theta += THETA_I(*it, this->x, this->y, this->z, t);
	}

    return theta;
}

void Particle::cleanup()
{
    list_nonpoly.clear();
    list_poly_short.clear();
}
