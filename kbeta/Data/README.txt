This directory contains the convolution-based method for introducing k-beta into a discrete source model. Space is not discretized; only time.

This code is really a prototype for anyone who is interested in developing it. The scalability of the method is questionable, since it costs quite a bit more to extend the simulation time and to add more particles.

Using out of the box:
Run kbParticle_run with the appropriate arguments.
To change constants: find the constant name in documentation at the top of kbParticle_run.m, and look for the appropriate variable in either kbParticle_run.m or kbParticle_alpha.m.

Key files:
kbParticle_run.m -- Contains the business logic, for loops etc. Heavily uses the class "kbParticle_alpha" from kbParticle_alpha.m
kbParticle_alpha.m -- Contains lower-level logic like physical constants, convolutions, and properties pertaining to particles.

Auxiliary files:
kbParticle_runLoop.m -- Example of how to use kbParticle_run.m

Data directories:
\Data -- Contains a set of runs produced by kbParticle_runLoop.m
\Arrhenius and Proportional Test -- Contains some old convergence testing against FDM