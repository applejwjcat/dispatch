New AMR tasks
---------------------

A new AMR task (A) is ready to update immediately, since it was  spawned from a
task that was ready to update at that specific time.  To update, with guard
cells filled, it needs to have an nbor list.  The nbor list must have 
the required nbors, and the nbor links must have ``needed`` and ``download``
both set to true.

When that task (A) nbor list was created, and indeed when any new nbor list is
created, that very action should trigger an ``init_nbors()`` in the nbors of
the A task (but not in nbors of nbors!).  So, the caller of the ``init_nbors()``
must also call ``set_init_nbors()``, which set ``bits%init_nbors`` in all nbors
of the 1st task.

One of those nbors (B) may be virtual, and that tasks should also get new nbor
lists, both on the rank (a) that triggers the chain of events, and on the rank
(b) that are owns task (B).

The rank (b) that owns the virtual task (B) also has (or will get) a copy of 
the task (A) that triggered the event chain, and since the principle is that 
the virtual tasks behave exactly as their originals do, we need only to ensure 
that the thread on rank (b) that unpacks the virtual copy of (A) also performs a 
``set_init_nbors()`` call, which then triggers an ``init_nbors()`` in the next
update of the boundary task (B) on rank (b), which then gets send in copy to
rank (a), as un update of its virtual task (B), where it gets a new nbor list,
*provided* that the ``bits%init_nbors`` that caused the thread on rank (b) to
generate a new nbor list still is set when the copy of the task arrives in rank
(a).

Hence, when a thread updating a boundary task discovers a ``bits%init_nbors``,
it should not clear that bit until after the ``send_to_vnbors()`` call.


.. toctree::
   :maxdepth: 4
