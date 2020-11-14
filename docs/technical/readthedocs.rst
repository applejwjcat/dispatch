dispatch.readthedocs.io
-----------------------

The dispatch.readthedocs.io documentation is generated automatically when
pushing new commits to bitbucket.org/aanordlund/dispatch.git, but in order
to proofread before pushing major updates it is very useful to generate a
local cache.  This is currently acthieved by doing, on a laptop::

   cd docs
   csh laptop.csh

This currently rsyncs the docs directory to astro08, and runs ``make.csh``
there, which uses the local Python installation to generate the HTML,
and then rsyncs it to ``ursa.astro.ku.dk/~aake/dispatch/``, so it may be
accessed at ``www.astro.ku.dk/~aake/dispatch/``.

NOTE: With a sufficiently complete local Python installation, the generation
can be done locally, on any laptop, so the resulting HTML may be proofread
there, by just doing (in the ``docs`` directory)::

  make html

.. toctree::
   :maxdepth: 3

