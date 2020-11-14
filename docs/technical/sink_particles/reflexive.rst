Reflexive time steps
--------------------

To make the particle evolution near-symplectic the most important
aspect is that the time step determination should be *reflexive*,
in the sense that when taking a timestep forward from ``t_A`` to
``t_B``, the timestep should be evaluated in such a way that starting
from ``t_B`` and moving backwards in time one should end up exactly
at ``t_A``.  (Aiming for exact symplectic expressions would be overkill
when there are weak and non-conservative perturbations from the moving gas).

A simple and efficient approximate method to achive this is to extrapolate
the position forward one half (time index) step, using the previous positions,
which are stored in the particle history.  Details of the extrapolation may
differ, e.g. in using or ignoring speed information -- the main goal should
be to obtain an estimate that is both cheap and accurate.

.. toctree::
   :maxdepth: 4

