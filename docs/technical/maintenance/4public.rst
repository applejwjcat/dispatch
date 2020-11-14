4public branch
--------------

[ This and related posts are mainly intended for the developers that maintain 
the development repository ]

The `4public` branch in the development repository is used to communicate changes 
between the development repository and the public repository.  To prepare for
using it:

1. Start with a clean working copy of the public repository, connect the
   development repository as the `upstream` remote, and checkout the `4public`
   branch:
::

   cd dispatch/public
   git remote add upstream ../development
   git fetch upstream
   git checkout -b 4public upstream/4public

Make sure to never push the `4public` branch to the public repository, since that 
would create a very confusing situation.  Always think of the `4public` branch as
a branch in the development repository.

.. toctree::
   :maxdepth: 3
   :caption:

   pull
   push

