Timings of relevance
--------------------

In order to estimate the contention on nbor list locks it is useful to have estimates
of the time spent in relevant routines.

Some of the central routines require approximately the times below, on a T430s
laptop::

  copy_nbor_list()   uses about 100 mus/call for 26 nbors, or about 4 mus/nbor
  remove_nbor_list() uses about half the time, or about 2 mus/nbor

  check_ready()      uses about 25 mus with 26 nbors, so about 1 mus/nbor
  check_nbors(2)     uses about half that time, or about 0.5 mus/nbor
  init_nbors()       uses about 1000 mus for 500 tasks, or about 2 mus/task


.. toctree::
   :maxdepth: 4


