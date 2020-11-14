Same resolution, different timesteps
-------------------------------------

Assume two task with the same resolution and different timesteps are being
updated by *one* thread:::

   tA1              tA2               tA3
    |<---dtA1------->|<----dtA2------->|
    0----------------+-----------------+----------------+------------+--- task A
    |       ´    |   |           |     |
    |-----fA1----|fA1|----fB2----|-fA2-|
    |            |   |           |     |
    0------------+---------------+--------------+------------+----------- task B
    |<--dtB1---->|<----dtB2----->|<---dtB3----->|
   tB1          tB2             tB3

Assume the thread updates task A first, and that its timestep is a bit longer
than that of task B.  It makes the flux it used (fA1) available to task B.

Then the thread updates task B, and computes a somewhat different flux than task A
(because the flux is based on prediction of the state at a different time).  If it
uses that flux, the mass flux between the two tasks becomes inconsistent, and mass
is either gained or lost.

To use consistent fluxes, without changing the state of task A a posteriori (and
there is no reason to do that -- it made an accurate estimate), task B should use
the flux from task A (fA1) in the 1st time step.

The thread will then select task B again, for a 2nd update, because task A is
ahead of task B.  Here, task B should use the remaining part of the task A flux, 
and then use the flux (fB2) it computed (possibly even correctly time centered),
for the remaining part of the time step.

The next task to be updates is task A, which should use flux fB2 from task B for
the first part of the interval, and a flux (fA2) that it estimates itself for the
last part of the timestep.

Correctly centering the partial timestep fluxes would mean to use predictor
values at, for example ``tB3 + (dtA2-(tB3-tA2))/2`` instead of at ``tA2 + dtA2/2``.

.. toctree::
   :maxdepth: 4
