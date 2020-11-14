Separate builds
---------------

Especially when developing, it saves time to have separate ``build_*/``
directories; one for each combination of ``SOLVER`` and ``OPTS``.

This may be enabled by setting the make macro ``SEPARATE_BUILDS``,
e.g. in a ``$(TOP)/options.mkf`` file (which might also be used to
set the ``COMPILER`` and other macros).  The file could thus contain,
for example::

  COMPILER=ifort
  SEPARATE_BUILDS=on

.. toctree::
   :maxdepth: 4

