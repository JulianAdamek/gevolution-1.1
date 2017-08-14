# programming environment
COMPILER     := CC
INCLUDE      := -I../LATfield2_particles
LIB_CPU      := -lfftw3 -lm -lhdf5 -lgsl -lgslcblas
LIB_GPU      := -lcufftw -lcufft -lm -lhdf5 -lgsl -lgslcblas

# target and source
EXEC         := gevolution
SOURCE       := main.cpp
HEADERS      := $(wildcard *.hpp)
EXEC_CPU     := $(addsuffix _cpu,$(EXEC))
EXEC_GPU     := $(addsuffix _gpu,$(EXEC))

# compiler settings (LATfield2)
DLATFIELD2_CPU := -DFFT3D -DHDF5 -DH5_HAVE_PARALLEL
DLATFIELD2_GPU := -DFFT3D_ACC -DHDF5 -DH5_HAVE_PARALLEL

# optional compiler settings (gevolution)
DGEVOLUTION  := -DPHINONLINEAR -DBENCHMARK -DCOLORTERMINAL

# further compiler options
OPT_CPU      := -O3 -std=c++11
OPT_GPU      := -O3 -std=c++11 -acc -Mcuda

all: gpu cpu

gpu: ${EXEC_GPU}

cpu: ${EXEC_CPU}

tests: ${EXEC_CPU}
	./test.sh

gevolution_cpu: main.cpp $(HEADERS) makefile
	$(COMPILER) $< $(INCLUDE) $(DLATFIELD2_CPU) $(DGEVOLUTION) $(LIB_CPU) $(OPT_CPU) -o $@

gevolution_gpu: main.cpp $(HEADERS) makefile
	$(COMPILER) $< $(INCLUDE) $(DLATFIELD2_GPU) $(DGEVOLUTION) $(LIB_GPU) $(OPT_GPU) -o $@

clean:
	rm -f $(EXEC_CPU) $(EXEC_GPU) *.o *~

