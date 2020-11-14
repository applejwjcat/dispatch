Forces
-------

The forces that involve sink particles are of two types:

1. Gravitational forces between particles.  These can be computed
   very efficiently, by first caching the particles from list form
   to array form, and then using vectorization over the particles.
   The cost per particle is low enough to accept, for each particle,
   direct computation for hundreds of the most significant sink particles.
   Each force computation is used to accumulate both the force of A on B,
   and the force of B on A.

2. Gravitational forces between gas and particles may, likewise, be
   computed by direct summation over particles, costing of order a few
   nanoseconds per sink particle, and thus allowing hundreds of sink
   particles w/o more than doubling the cost per cell.

   As with the particle-particle force, one can accumulate, without
   additional cost, the force of the gas on the particles, from the
   action = reaction principle.  This yields for each patch and time,
   a force field from all the direct summation sink particles.

   To use this information in the calculation of the forces acting on
   each particle requires (only) that one interpolates in time, for
   each patch. For each patch we know the force on each particle, at
   a discrete set of times.  From that information one can interpolate
   to the exact particle time, using high order time interpolation
   (``lagrange_mod.f90``).

   To quickly find the right ``patch_force_t`` instance, given the particle
   and MHD patch IDs, we use a hash table with ``(particle%id,patch%id)``
   as a 2-dimensional key, and an anonymous pointer with the address to
   the ``patch_force_t`` data type as value. 

.. toctree::
   :maxdepth: 4

