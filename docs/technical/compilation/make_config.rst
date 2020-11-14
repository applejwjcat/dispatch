Makefile configuration
----------------------

Several of the make options are chosen based on the value of the environment
parameter ``$HOST``.  To influence those settings,  create a file 
``config/hosts/$HOST``, and put the options you prefer there.  A typical
content on a cluster host would be::

   COMPILER=ifort

You may choose to commit the file to the repository, but make sure to avoid 
collisions with existing files.  Having the ``$HOST`` file in the repository
makes sense on a cluster, to configure common settings used by several people,
while committing a laptop ``config/hosts/$HOST`` to the repository is usually
pointless.

To implement particular host-dependent options or option bundles for a compiler,
create for example these files::

   config/compiler/gfortran/$HOST/Makefile
   config/compiler/gfortran/$HOST/optimized.mkf
   config/compiler/gfortran/$HOST/debug.mkf
   config/compiler/gfortran/$HOST/full_debug.mkf
   config/compiler/gfortran/$HOST/personal.mkf

Note that these files only need to contain the lines that differ from the 
corresponding lines in the ``config/compiler/gfortran/`` files.

See also the note about ``makes showinclude ...`` on the page about `make targets`_

.. toctree::
   :maxdepth: 4
