Maintaining consistency
-------------------------

To maintain consistency each task must 

1. Maintain a time for each interface, up to which it has achieved flux consistency.
2. Have access to the corresponding information from the task on the other side
   of the interface.

Each task must be able to rely on that both tasks make the same assumptions about
update order and method to resolve flux inconsistency.  To achieve this without
a need for negotiations, we can use the simple rules that 1) the "consistency marker"
must always move forward in time, and 2) the task that lags behind in consistency
time has "the right-of-way"; it can move its marker ahead of the other task.

Task B cannot know (should not need to know) if task A will be updated during its
own update (it could check the ``bits%busy`` bit, but that might be set only after
the task B update has started).

If the consistency time of task A is ahead of that of task B then, by the first
rule above, both task A and task B can trust that fluxes agree up to the earlier
of the two consistency times.  By the 2nd rule, the leading task can trust that
the other task respects its flux choice(s) in the time interval between the two
consistency times.

So, the rules holding at an interface are:

1. the task which leads in consistency time can assume that the other task
   will adjust the fluxes used, up to the leading time
2. the task which lags in consistency time has the obligation to fix consistency
   up to the leading time, and should then move its own consistency time on ahead
   to the end of its time step

::

   |<---dtA1------->|<----dtA2------->|
   0----------------+-----------------+----------------+------------+--- task A
   |-----fA1--------|------fA2--------|-------fA3------|
   |-----fA1----|fA1|----fB2----|-fA2-|---fB3--|
   0------------+---------------+--------------+------------+---------- task B
   |<--dtB1---->|<----dtB2----->|<---dtB3----->|


.. toctree::
   :maxdepth: 4
