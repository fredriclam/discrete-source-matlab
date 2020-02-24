# Use icc
CXX=icpc
CXXFLAGS= -std=c++11  -ansi-alias -O2  -ftz #-use-intel-optimized-headers -ipo -I -GS -MT -EHsc -xhost -u -X -Oi -Ot -NODEFAULTLIB
DEPS = controls.hpp DictionaryExp.hpp erfc.hpp interaction_functions.hpp Particle.hpp run.hpp mt19937ar.h
OBJ = main.o run.o Particle.o interaction_functions.o erfc.o DictionaryExp.o mt19937ar.o
SRCS = main.cpp run.cpp Particle.cpp interaction_functions.cpp erfc.cpp DictionaryExp.cpp mt19937ar.cpp

all: FFR

%.o: %.cpp $(DEPS)
	$(CXX) -c -o $@ $< $(CXXFLAGS)

FFR: $(OBJ)
	$(CXX) -o $@ $^ $(CXXFLAGS)

# depend:
# 	makedepend -f Makefile $(DEPS) $(SRCS)