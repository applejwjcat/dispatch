Maintenance
===========

[ This and related posts are mainly intended for the developers that maintain 
the development repository ]

The maintenance instructions assume that the public and private repositories
are checkout side-by-side, and are called `dispatch/{private,public}`.  Other
arrangements are handled correspondingly.

It is a good idea to add a local working copy of the private bitbucket repository
as `upstream`, rather than the bitbucket repository itself -- this reduces noise
from the commits that would otherwise be needed.

.. toctree::
   :maxdepth: 3

   4public
   update
   pull
   push
