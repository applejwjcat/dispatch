Pulling updates
---------------

To pull in updates from the development repository do:::

   cd dispatch/development          # working copy of private
   git checkout 4public             # private branch
   git pull                         # make sure it is up-to-date
   git cherry-pick [ hash ]         # get the new feature
   ... test carefully ...           # test also that other experiments work

   cd ../public                     # upstream = private
   git checkout 4public             # branch connected to upstream/4public
   git pull                         # pull in updates
   git checkout beta                # beta branch on public
   git rebase master                # sync with master on public
   git cherry-pick 4public          # import feature
   ... test carefully ...           # test also that other experiments work
   git commit --amend               # amend the commit message (cf. below!)
   git push                         # push to private repository

In the amended commit message you should alert people about this new update on
the ```beta``` branch, and invite them to try it out.   Only after confirmation that
there is no problem should the commit be cherry-picked over to the ```master```
branch on the public repository.

.. toctree::
   :maxdepth: 4
   :caption:

