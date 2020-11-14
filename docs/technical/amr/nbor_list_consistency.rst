nbor list consistency
---------------------

The nbor lists of two tasks must always be *consistent*, in the sense that no
deadlock can occur because of the state of the nbor lists of two task that may
or may not be nbors.

A deadlock could occur if a task A depends on another task B being updated,
because B is in the nbor list of A and is the logical flag ``needed`` is true
for the B entry in A's nbor list, while at the same time A is not in the nbor
list of B, and hence B will not include A when doing check_nbors().  This could
cause a deadlock because the mechanism that puts task A in the ready queue is
that a thread working on B, updating the time past the one that task A is
waiting for, is supposed to be that the thread updating B then calls check_ready
on the A-task.

Hence, we must either have the thread that updates nbor relations take care of
updating both nbor lists "at the same time" (under lock), or we must make sure
that an inconsistency does not have negative consequences.

If an nbor task (B) is present in the nbor list of a task (A), but that task (A)
is not present in the nbor list of the nbor (B), then task (A) might find that
it cannot update because B is not up-to-date, but when B updates it does not
check if A becomes ready, because it is not on the nbor list.  That problem
could be handled by letting the addition of a new task to an nbor list always
have the consequence to run check_nbors() on the nbor list (or at least to run
check_ready() on the new nbor).

That simple fix might make it OK to delay the update of nbor lists until the
thread that takes on an update can do it.

The implementation would then rely on these two mechanisms:

1) When adding or removing a task from the nbor list of the task a thread is
  working on, it must set a bit in the other task, triggering the next thread
  that starts to work on that task to update it nbor list accordingly; i.e.,
  either remove the task has set the status bit, or add it.  This means the
  actual nbor relation must match the action; if the action was "add", then
  the task must actually be a new, overlapping task, and if the action was
  "remove", then the task must actually either a) not exist any more, or b)
  have a flag set that indicates it is about to be removed.

2) After taking such an action, the thread must call check_ready() on a task
   that was added to an nbor list, and must run check_nbors() on the nbors of
   a task that is being removed -- in case they will become updateable *because*
   the task is being removed.   Again, the check_ready() must then recognize the
   bit that indicates a task is about to be removed   

.. toctree::
   :maxdepth: 4
