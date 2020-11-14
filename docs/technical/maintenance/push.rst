
Pushing updates
---------------

To push updates from the private to the development repository do:::

   cd dispatch/development          # working copy of private
   git checkout master              # must NOT be in 4public
   
   cd ../public                     # upstream = private
   git checkout 4public             # private branch
   git pull                         # make sure it is up-to-date
   git cherry-pick [ hash ]         # get the new feature
   ... test carefully ...           # test also that other experiments work
   git push                         # push to private repository
   
   cd dispatch/development          # working copy of private
   git checkout 4public             # branch connected to upstream/4public
   git rebase master                # sync with master on public
   ... test carefully ...           # test also that other experiments work
   git checkout master              # private master branch
   git cherry-pick 4public          # import feature
   git commit --amend               # amend the commit message (cf. below!)
   git push                         # push to private repos

Make clear in the amended commit message that this is imported from the public
repos.

.. toctree::
   :maxdepth: 4
   :caption:

