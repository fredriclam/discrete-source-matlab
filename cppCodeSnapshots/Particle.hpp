// Particle Class, wrapping all the important elements of the particle.
// N.B. The prediction used for Newton interpolation continues even with the transition past burn time: the
// kink is ignored, which might be problematic. But not likely: since the function looks C0, and introducing
// a burn time makes the function smoother than the base case (instantaneous heat release described by the
// Green's function.

#ifndef PARTICLE_HPP
#define PARTICLE_HPP

#include <vector>
#include <forward_list>
#include <cstddef>
#include <math.h>
#include "controls.hpp"

//#define EXPF dict.dexp // dict.dexp , exp
//extern DictionaryExp dict;
extern int num_images;

class Particle
{
    public:
        // Ctor Dtor
        Particle(int particle_number, double x, double y, double z, double tau);
        virtual ~Particle();

        // Cutoff properties from the MATLAB error surface of each polynomial (for open BCs, 2D inst. burn)
        static const double poly_cutoff_t_long_3;
		static const double poly_cutoff_x_long_3;
		static const double poly_cutoff_t_long_5;
		static const double poly_cutoff_x_long_5;
		static const double poly_cutoff_t_short_3;
		static const double poly_cutoff_x_short_3;
		static const double poly_cutoff_t_short_5;
		static const double poly_cutoff_x_short_5;
		static const double poly_cutoff_min_x_standoff;
        // Long and short sections
		static const double t_section_long_max;
		static const double t_section_short_max;
        // Time to promote nonpoly to any polynomial representation; minimum of the poly_cutoff_t values
        static const double poly_promotion_time;
        // Factor to account for the uniform percent error of the series representations, with some safety margin (0.95)
		static const double poly_adjust_factor;
        // Static fields
        static const double poly_nodes[];
		//static const double tol_periodic;

        // Methods
        void calculate_contributions_3 (Particle* p_source, double t, double h, double poly[]);
        void calculate_contributions_5 (Particle* p_source, double t, double h, double poly[]);
        void update_all (std::vector<Particle*>& list_on, double t);
        void update_poly_short (double t);
        void update_nonpoly(double t);
        void link_particle(Particle* p);
        double theta_approx(double t);
		double theta_exact(std::vector<Particle*>& list_on, double t);
        void cleanup();

        // Fields
        int particle_number;
        double x, y, z, tau;
        double poly_long[5];
        double poly_short[5];
        double pivot_long;
        double pivot_short;
        double memory;
		std::vector<Particle*> list_poly_short;
		std::forward_list<Particle*> list_nonpoly;
};

#endif // PARTICLE_HPP