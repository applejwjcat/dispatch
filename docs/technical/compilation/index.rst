Compilation
===========

Compilation is controlled by a hierarchy of Makefiles.  For each ``experiments/whatever/``
directory there should be a ``Makefile`` similar to those in parallel directories, so
itechnical/f / when making a new experiment, use a ``Makefile`` from another experiment as a template.

**Explanation:**

The experiment ``Makefile`` does ``include $(TOP)/config/Makefile``, which in turn includes
the Makefiles in the various subdirectories, including the ones in the ``config/compiler/``
hierarchy, which determine compiler option settings.

Normally, it is not necessary to change the the make configuration, except possibly to
overrule the choice of compiler, with for exampe ``make COMPILER=ifort``.

See below for information on compiler option bundles, special make targets, and tailoring
the make system:

.. toctree::
   :maxdepth: 4

   make_options
   make_targets
   make_config
   separate_build
