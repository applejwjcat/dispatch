experiment_mod.f90
====================

The ``experiment_mod.f90`` module defines the highest level data type,
which *extends* (inherits) the ``solver_t`` data type, and optionally
overloads (or "intercepts") calls to the standar ``init``, ``update``,
``output``, and possible other procedures.  The main purposes of these
are:

1. ``init``: read in and use input parameters from an input namelist,
   by convention called ``experiment_params``.
2. ``update``: do whatever specific actions that are required (or not)
   before and after calling the solver update procedure to update the
   state of a single *patch* (or more generally: *task*)
3. ``output:`` this is called immediately *before* call to the ``update``
   procedure (because that's the point where ghost zones have been loaded,
   boundary conditions have been applied, etc).

Any or all of these procedures may be omitted, in which case calls are
instead caught by the corresponding ``solver_t`` procedures.  One can
also pass on calls to these, with for example::

  SUBROUTINE output (self)
    class(experiment_t):: self
    !...........................................................................
    call self%solver_t%output
    ... whatever else one may want to do, e.g. via the HDF5 interface
  END SUBROUTINE output


.. toctree::
   :maxdepth: 4

