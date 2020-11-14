
Overview
========

DISPATCH

* is a code framework, rather than just another MHD/HD code
* is a system for task based computing with, in principle, unlimited scaling
* supports different kinds of (co-existing) tasks (e.g., cell-, ray- & particle-based),
  using HD, MHD, RMHD, non-ideal MHD, and / or particle-in-cell solvers
* can support and boost the performance of both existing and new solvers
* relieves solvers from dealing with MPI communication and OpenMP parallelization
* makes it trivial to implent new solvers, which are required to perform only two tasks:

  1. choose a time step size, based on local variables
  2. update its state, given guard cell or other neighbor information, provided by the framework



.. toctree::
   :maxdepth: 3

   presentations
   publications
   license
   collaboration

