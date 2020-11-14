make options
------------

The default compiler options for gfortran and ifort are chosen as a compromise
between compile time and performance; they generally give close to optimal 
performance, so are suitable for shorter runs and for development.

To get the best performance, compile with ``make clean; make OPTS=optimized``, which typically
gives a gain of a few percent in performance, at the cost of increased compilation time.

If the code crashes, try recompiling with ``make clean; make OPTS=full_debug`` or 
``make clean; make OPTS=debug``. The first provides comprehensive debug settings,
while impacting performance significantly, while the 2nd avoids the particular
options that impact performance the most.

The ``make clean`` part is only needed the 1st time after changing OPTS bundle

.. toctree::
   :maxdepth: 4
