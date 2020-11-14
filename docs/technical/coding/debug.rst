Debug printout
--------------

For largely historic reasons the code still contains a lot of debugging and 
diagnostic print messages, typically controlled by a local ``verbose`` parameter,
similar to::

      if (verbose > 0) then
        write (io_unit%log,'(....)') &
          wallclock(), ...
        if (verbose > 1) then
          ...
        end if
      end if

Because many such code blocks can be very detrimental to code readability this
is discouraged (meaning most of those constructs will be gradually removed), in 
favor of adding ad hoc statements of the type (fully left-adjusted, to stand out):::

  write (stderr,*) wallclock(), mpi%rank, omp%thread, 'message', task%id

specifically tracing some action through various pieces of the code, to be removed
after filling their function.  The lines should be removed in a dedicated commit,
so they are recoverable via a simple ``git revert``, w/o introducing other changes.


.. toctree::
   :maxdepth: 4

