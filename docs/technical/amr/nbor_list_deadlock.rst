Nbor list dead-lock
--------------------

A deadlock could occur if a task A depends on another task B being updated,
because B is in the nbor list of A and the logical flag ``needed`` is true
for the B entry in A's nbor list, while at the same time A is not in the nbor
list of B, and hence B will not include A when doing ``check_nbors()``.  This could
cause a deadlock because the mechanism that puts task A in the ready queue is
that a thread working on B, updating the time past the one that task A is
waiting for, then calls ``check_ready()`` on the A-task.

But if the reason that the A task is not on the nbor list of B is just a time
delay (e.g. because of latency in MPI communication), then one just neeeds to
make sure that the ``check_ready()`` call actually happens when A -- after the
delay -- gets put on the nbor list of B.  This will be ensured if the adding
of a task to an nbor list always is accompanied by a ``check_ready()`` call.
One call too many does not hurt.

So, at guarantee against nbor-list caused deadlocking is to add a
``check_nbors()`` call into the ``init_nbors()`` call.  This will work, as long
as ``init_nbors()`` is the method used to update the nbor lists from
``task_mesg_t%unpack()``.  If the method is changed the new method needs to
do something similar.


.. toctree::
   :maxdepth: 4
