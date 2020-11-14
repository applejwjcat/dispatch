Consistency with MPI
---------------------

The removal or addition of a task that is a boundary task should be
reflected in the nbor list of nbors that are virtual tasks, and there could
possibly be a signficant delay before that happens.   The sequence of events 
should be:

* A thread always sends a boundary task to rank nbors, after updating or creating
  it.  At that time, a bit (``bits%init_nbors``) must be set, which triggers the
  receiving rank to update the nbor lists of the task; either creating it if is
  a new task, or removing it and the task, if the task is to be removed.
  
  + So, when should an ``init_nbors()`` call be made from ``task_mesg_t%unpack``?
    Clearly, when a new task is being created, but also when a task that is an
    nbor is removed or one that should become one is created.  The first type
    causes a call automatically (should it?), while the 2nd type is triggered
    by the ``bits%init_nbors`` being set.
    
  + The first type occurs when a task has just been created by AMR, and for a
    boundary task it happens both on the owner rank and on virtual nbor ranks.

* As a consequnce of that, all nbors of that (virtual) task on the rank nbor
  should also have their nbor lists renewed.  This includes those boundary tasks
  that appear as virtual tasks on the first rank.

* As the nbor lists of those virtual tasks are being modified, they thread that
  is doing the modifications must, correspondinly, take the appropriate action
  (i.e. calling check_nbors() for new tasks, as well as for tasks that are
  being removed.

.. toctree::
   :maxdepth: 4
