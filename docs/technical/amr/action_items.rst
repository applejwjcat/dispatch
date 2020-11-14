MPI action items
----------------------------

Action items to ensure correct handling of AMR task under MPI:

* Ensure that new AMR tasks added are created with a valid nbor list = one that
  may be used to fill its guard zones in the first update. [x]

* Ensure that new AMR tasks are immediately added to the ready queue, since there
  is no other mechanism to put them there, and since they are indeed ready to be
  updated. [x]

* Ensure proper handling of ``bits%init_nbors``, which should trigger a call to
  ``init_nbors()`` from ``task_list_t%update()``, after its call to
  ``task%update()``, and before its call to ``load_balance`` for active tasks,
  and a similar call to ``init_nbors()`` from the ``task_mesh_t%unpack()``
  procedure for virtual tasks. [x]

* Ensure that the nbors of a new task, as well as of task to be removed, get 
  their ``bits%init_nbors`` set, and that that bit travels with boundary tasks
  as is acted upon by the ``task_mesg_t%unpack()`` procedure when it unpacks
  virtual tasks. [x]

* Ensure that any ``add_nbor_xxx()`` call is accompanied by a ``check_ready()``
  call of that task link.  This is done by adding a ``check_nbors()`` to the
  end of the ``init_nbors()`` call that possible added a new task. [x]
  
* Ensure that no locking of other task links occur.  The choice is made by
  not setting ``omp_lock%links`` in task%refine, and to make this choice
  permanent, all section of the code with ``if (omp_lock%links) ...`` should 
  be removed. [x]

* In addition one should search explicitly for ``%lock%set`` in the code. [ ]


.. toctree::
   :maxdepth: 4
