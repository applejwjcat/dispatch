Flux consistency
----------------

For a property such as mass to be conserved across patch boundaries, it is
necessary that the two tasks agree, at least on average, on the mass flux
passing through the boundary between the tasks.  In the guard zones, task A 
can only estimate the flux computed and used by task B, especially if they 
have different resolutions and/or timesteps, since the flux for example depends
on slope limiters that act differently for different resolution, and since flux
calculations are based on forward predictor steps that result in different values
at different times.

The solution is that tasks communicate the flux that was used in previous 
timesteps, so nbor tasks can compensate -- *a posteriori* -- for differences.
The flux must be defined as exactly the flux that was used in the update.
To keep and communicate it, one needs an array size of 6*N*N per time slice 
and per variable.

Since MPI bandwidth is usually not a bottleneck, one may -- as a simple temporary
solution -- increase ``mw`` by one and communicate the flux values for the whole
patch.  Optimization is straightforward and can be done later -- the main goal
is to demonstrate that flux consistency can be achieved, and how it should be done.

To explore this, the sub-sections below progress from the simplest case to the
most general case:

.. toctree::
   :maxdepth: 4

   same_resolution_same_timestep
   same_resolution_different_timestep
   same_resolution_time_extrapolation 
   different_resolution
   maintaining_consistency
   divB
