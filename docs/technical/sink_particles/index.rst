Sink-particles
==============

A sinkparticle is represented by a task data type (``sink_patch_t``) 
that is primarily an extension of a ``gpatch_t`` data type, with a ``patch%mem``
that has a limited extent (~8 cell radius).
Sink particles are formed at the same resolution level as the patch they are
formed in.

From the point of view of the dispatcher task_list, the task appears as a
normal patch, but with special case handling that causes all interior 
values to be downloaded from and to its normal MHD patch nbors.
The particle aspect of a sinkparticle is kept in a ``partcle_list_t`` data
type, which stores several positions in time for the particle, making it
possible to interpolate its position to any given time, when computing
interactions (forces).

The sink particle position is updated by an N-body solver, which gets
access to the other sink particle histories by being an extension on top of
the ``task_list_t`` data type.

The particle position update method is always one particle at a
time, since particle updates use variable time steps, which differ from
particle to particle. A particle "update" in the DISPATCH context
thus consists of these steps

1) pre_update: estimate the mid-point position to use, in order to make the
   update time-reflexive
2) compute the forces at some point in time (e.g. the initial time for the
   1st K step in KDK) and update the velocity
3) update the position (e.g. with D step in KDK)
4) compute the forces at some other point in time (e.g. at final time for
   2nd K step in KDK) and update the velocity

.. toctree::
   :maxdepth: 4

   ad_hoc
   forces
   hierarchy
   reflexive
   updates
   winds
