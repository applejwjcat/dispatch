Nbor task access protocol
--------------------------

In addition to accessing nbor tasks nbor lists, the thread updating a task also
needs to access and modify nbor task structures.  Setting bits in the status
word is inherently (by construction) atomic, so that should cause no problem, 
and should not require task locking.  Changes of ``patch_t%mem`` should be 
protected by setting ``task_t%lock``. This includes

* ``task_t%rotate()``, where the memory slots are rotated, to create a circular
  buffer

* ``timestep_t%update()`` for ``stagger2/`` solvers, and corresponding sections
  of other solvers, where their ``patch_t%mem`` arrays are being modified

The direct costs of applying such locks by the owner thread are negligible.
Locking other tasks while accessing their memory could impact a more significant
cost, and should be avoided when possible.  

A relevant example is the access of ``patch_t%mem`` from other tasks in the
form of ``source%mem`` in ``download_mod.f90``.  In principle, one should apply
a lock there, but the chance that something bad happens is very small, since
most of the time, the access will be to two pairs of memory slots that have
essentially zero chance of being modified during the access.
Since the access time in ``download_mod`` is a tiny fraction (of order 0.1%)
of a task update time, if the source task happens to be under update (the
chance is a few %, since most task are dormant at any one time), the update is
not likely to finish during the brief access time.  Therefore, in this case it
is necessary to lock the source task during access only when the oldest slot
that is accessed corrsponds to ``task_t%new`` in the source.


.. toctree::
   :maxdepth: 4
