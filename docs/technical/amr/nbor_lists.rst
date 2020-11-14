Task handling
-----------------

A new AMR task:

* isn't engaged in ``check_ready()`` of nearby tasks until it has
  been added to their nbor lists.

* also isn't involved in ``check_ready()`` performed by other threads
  until it has been added to the nbor lists of those nearby threads.

* is generally born ready to update, since it is formed as part of
  a parent patch that was about to be updated, and is given the same task time.

* may be added to the ready queue on an ad hoc basis, w/o necessarily having
  been given an nbor list at all

* does not need to be sent to the nbor ranks until after it has updated, at
  which time it will have a valid nbor list on the owner rank, and will be given
  one automatically -- as for all new tasks on a node -- when arriving on another
  rank

This argues in favor of delaying the call to ``init_nbors (task%link)`` until
the next time it has been picked by a thread for updating.  At that time, as
part of the ``refine_t%check_current()``, it needs to generate an nbor list,
for use in ``task%dnload``.

* At the time when it comes to calling ``check_nbors``, it knows who the nbors
  are, but they may not yet know about the new task, and instead may rely on
  the still existing parent task.

* If the nbors don't have the new AMR task in their nbor lists yet, they cannot
  be denied updating based on the new AMR task, and thus at some point they will
  end up in the ready queue, and perhaps only then will they generate their own,
  new nbor lists

* but if a task generates a new nbor list after being selected, it may find that
  some of the new nbors may not be up-to-date, so this argues for generating new
  nbor lists at the end of a task update, rather than at the start

* except: a new AMR task needs to have a first nbor list, so it can get authoritative
  guard zone values.  It is not necessary that the virtual copies get their nbor
  lists in any special way; they get theirs when created.

Using this strategy, we should be able to avoid calling ``init_nbor_nbors()``
after creating a new AMR task, and we should also be able to avoid calling
``check_nbor_nbors()``, since the nbors will take care of their own.


.. toctree::
   :maxdepth: 4

