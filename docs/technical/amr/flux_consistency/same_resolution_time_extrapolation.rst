Same resolution, time extrapolation
------------------------------------

Assume two task with the same resolution and the different timesteps are being
update by *several* threads, with a ``grace`` value giving an allowed window for
time extrapolation:::

   tA1              tA2               tA3
    |<---dtA1------->|<----dtA2------->|
    0----------------+-----------------+----------------+------------+--- task A
    |-----fA1--------|------fA2--------|-------fA3------|
    |-----fA1----|fA1|----fB2----|-fA2-|---fB3--|
    0------------+---------------+--------------+------------+----------- task B
    |<--dtB1---->|<----dtB2----->|<---dtB3----->|
   tB1          tB2             tB3

Assume that after task A and task B have updated as in the previous case, one
thread takes task B to do the 2nd time step of it, while another one takes task
A, which has also been deemed ready to update, because it is within the grace
interval ahead of task B.

Task B will update as in the previous example, using first the fA1 flux from
task A, and then its own fl2 flux.  Task A will use its own flux (fA2), since 
task B has not yet made fB2 available.  This creates and inconsistency, which
needs to be corrected subsequently.

To avoid imposing any new constraints on which task updates before the other, we
assume that task A is still ahead by less than the ``grace`` value, and hence
the two tasks could happen to be updated simultaneously again.

The inconsistency in the fB2 interval may be rectified if task A adds (fB2-fA2) times
the length of the time interval.  Task B is free to choose to use fA2 in the
overlapping time interval, and then its own fB3 value, while task A cannot use
new information from task B regarding fluxes, since none is available, and hence
it will use fA3 over the whole interval.  The situation after the update is thus
the same as after the previous update, and may be corrected in the same way, in
the next round of updates.

.. toctree::
   :maxdepth: 4
