#ifndef CONTROLS_HPP
#define CONTROLS_HPP

// Problem control switches: muy importante!
//#define CYL_GEOM
#define EXACT_DENSITY // Place exact number of particles when generating cloud
//#define USE_ZERO_T_R
#define OUTPUT_MODE 1
//#define USE_THETA_EXACT // Exact method of calculating heat release function (no interpolation)
//#define FIX_SEED

// Stricter ignition threshold check: leave undefined for default (0.98)
//#define IGNITION_CHECK_FACTOR 0.5

// Hard-coded operation flags
#define GEN_CLOUD true
#define GEN_FIELD false // Must be set to true if FIND_RMS is set to true
#define FIND_RMS false

// Interaction function: if cylindrical, use open boundary; if rectangular slab, use periodic boundary
#ifdef CYL_GEOM
#define THETA_I theta_i_free_3D_newtonian
#else
#define THETA_I theta_i_periodic_3D_newtonian
#endif

#define EXP dict.dexp // dict.dexp
//#define EXP exp // dict.dexp

// Pi
#ifndef M_PI
#define M_PI 3.1415926535897932384626433832795028841971693993751
#endif

#endif // CONTROLS_HPP
