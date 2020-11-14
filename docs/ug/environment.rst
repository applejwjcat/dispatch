.. _environment:

Execution environment
=====================

To include the ``utilities/python/`` directory in the Python search
path, and (optionally) set default options for compilation, add
these lines to your ``~/.bashrc`` startup file:
::

   export DISPATCH=${HOME}/codes/dispatch
   export PYTHONPATH=${DISPATCH}/utilities/python:${PYTHONPATH}
   # optionally:
   export HOST=NameForYourLaptop

To set compile options, add a ``config/host/NameForYourLaptop/Makefile``
containing for example
::

   COMPILER=ifort
   SEPARATE_BUILDS=on
