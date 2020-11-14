Snapshot save 
--------------

A saved AMR snapshot must contain -- effectively -- a list of tasks to read in,
initialize, and fill with values from the snapshot.

In the case of for example the ``ppd_zoom`` experiment, the task list consists of
more than one piece, with different types of task in each piece.  Sufficient info 
about this must be carried by the snapshot meta-data.

In general, a "component" that is part of the simulation setup ("scene") may need
to have its own save/restore (output/input).  If so, it also means that patches
and tasks need to be identified as belonging to a component, either by being part
of a partial task list, or by having an identifier string (or integer).  The former
is not convenient, since on the one hand we want to have all tasks in a rank-global
task list, and on the other hand we need to be able to add and remove tasks in only
one place, not in the global and partial lists separately.

One could possibly rely on that tasks needing special I/O treatment probably also
need extra, non-generic parameters, and hence need to belong to a certain type of
task, which then would naturally have its own input/output procedure.


.. toctree::
   :maxdepth: 4

 
