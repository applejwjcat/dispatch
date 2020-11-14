Option Groups
=============

Supported compilers come with predefined option groups.
To see the actual compiler options they include, do::

  make OPTS=full_debug info
  make OPTS=debug info
  make OPTS= info
  make OPTS=optimized info

The bundled options are chosen so that

   * `full_debug`: generates very slow code that traps many problems
   * `debug`: generates faster code that traps fewer problems
   * `(blank)`: compromise between compile time and code speed
   * `optimized`: maximizes speed, at the cost of increased compile time

Note that local options in ``config/host/$HOST/Makefile`` and in
``config/compiler/$HOST/$OPTS.mkf`` may modify the option bundles.

.. toctree::
   :maxdepth: 3

