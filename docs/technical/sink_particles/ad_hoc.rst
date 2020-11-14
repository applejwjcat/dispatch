Ad hoc sink particles
---------------------

To allow testing, one can create *ad hoc* sink particles, using namelist entries
similar to::

   &sink_patch_params      verbose=2 on=t n_ad_hoc=2 /
   &sink_params            x=0.52 y=0.52 z=0.52 vx=0.1 mass=1 /
   &sink_params            x=0.48 y=0.48 z=0.48 vx=0.2 mass=1 /

Whereas sink particles normally are created and added to the task list by one
of the refinement criteria, the *ad hoc* particles are created after the task
list with normal MHD patches has been created, via a call from ``extras_t%init_task_list``,
which gets called once for every patch, just before updates of the task list start.

The call has the current task list as an argument, which makes it possible to append
the new tasks, corresponding to the *ad hoc* sink particles.

.. toctree::
   :maxdepth: 4

