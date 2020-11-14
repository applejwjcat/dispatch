
# Option groups
#OPTS = full_debug
#OPTS = debug
#OPTS =
OPTS = optimized

# Default target and methods
EXEC            = dispatch.x
SOLVER          = heat_diffusion
TOP             = ../..

# Tomida & Hori, with opacity
#EOS             = data/eos/Tomida+Hori_2016/e
#OPACITY         = Tomida+Hori_2016

sinclude $(TOP)/config/Makefile

#VPATH := $(VPATH):$(TOP)/microphysics/opacities/stub

# List the .o files the main program depends on after the colon:
$(EXEC)                 : setup_mod.o cartesian_mod.o dispatcher_mod.o
experiment_mod.o        : io_mod.o trace_mod.o solver_mod.o
