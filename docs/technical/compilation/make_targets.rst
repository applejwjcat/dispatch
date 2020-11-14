make targets
------------

The ``config/Makefile`` specifies a few special target, which may be useful
while developing code.

To see the values of various options (make macros= chosen, do ``make OPTS=xxxx info``.  
Individual make macros listed may be overruled on the command line, using for 
example ``make OPT=-O0`` for a quick compilation; e.g. for checking syntax.

To get a list of source files compiled for a specific experiment, do
``make source`` (this requires that the code is compiled first).  This may be
particularly useful when looking for particular strings in the code; e.g. with::

   make source | xargs egrep -n '(pattern1|pattern2)'

Some make macros are chosen based on for example the host name, or based on
other macro values.  To reveal where a particular option gets its values, do
for example::

   make showinclude PATTERN=COMPILER
   make showinclude PATTERN=OPTS
   make showinclude PATTERN=OPT
   make showinclude PATTERN=FC

.. toctree::
   :maxdepth: 4
