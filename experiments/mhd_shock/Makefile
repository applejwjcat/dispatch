
# Option groups
#OPTS = full_debug
#OPTS = debug
#OPTS =
OPTS = optimized

# Default target and methods
UPD             = adams_bashforth
#SOLVER          = zeus3d
#SOLVER          = zeus3d/zeustw
#SOLVER          = stagger2
#SOLVER          = stagger2/e
SOLVER          = ramses/mhd
EXEC            = dispatch.x
TOP             = ../..
sinclude $(TOP)/config/Makefile

# List the .o files the main program depends on after the colon:
$(EXEC): cartesian_mod.o setup_mod.o dispatcher_mod.o

# Dependencies
experiment_mod.o	: trace_mod.o io_mod.o kinds_mod.o mesh_mod.o solver_mod.o index_mod.o pboundary_mod.o mpi_mod.o bits_mod.o
pboundary_mod.o		: io_mod.o trace_mod.o mesh_mod.o kinds_mod.o
