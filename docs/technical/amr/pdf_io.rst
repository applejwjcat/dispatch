PDF I/O for AMR
----------------

The ``pdf_io_mod.f90`` module outputs snapshots of the density *probability
distribution function* (PDF) at regular intevals (``out_time``in the namelist
``pdf_io_params``).  The PDF is accumulated as patches progress past the next
output time (``patch_t%pdf_next``), at which time the density data is interpolated
to the exact output time its contribution is accumulated in ``pdf_io_t%counts``.

When a new AMR task is created, ``pdf_next`` is set to the next multiple of
``out_time``, thus triggering a call to ``pdf_io_t%update`` when the task
reaches that time.  The number of tasks that need to be accumulated before the
PDF is complete is (provisionally -- cf. below) equal to ``io%nwrite``, which
is also the number of tasks that contribute to AMR snapshots of the patch
values.

When one snapshot of the PDF finishes, the count of the number of tasks expected
in the next snapshot is set equal to the number of tasks existing at that time,
which is the value of ``io%nwrite`` at that time.  If/when new AMR tasks are
added, with ``pdf_next`` set to the next multiple of ``out_time``, this increases
the number of tasks that should be output with one.  The counter that keeps
track of tasks remaining to be output should thus be incremented by one.
Correspondingly, if an AMR task is deleted, the count of remaining tasks to
accumulate should be decremented by one.

There may be borderline cases, where a task is created just after the time
when an output should happen, but these should really not caue problems, if
the procedure above is followed.

.. toctree::
   :maxdepth: 4

