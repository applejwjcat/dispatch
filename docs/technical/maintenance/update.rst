Common files
---------------

Occasionally, we may want to update all (or most) of the common files
shared with the master branch in the development reposiory.  This should
not be done lightly, since it may brake existing codes, and (therefore)
requires extensive testing.

To check differences and possibly pull in updates of common files, do:::

   # in the development working copy
   cd dispatch/development
   git checkout 4public
   git pull
   git diff --stat master -- `git ls-tree -r 4public --name-only`
   ... check carefully which files should really be included ...
   git checkout master -- `git ls-tree -r 4public --name-only`
   git checkout -- file1 file2      # cancel individual updates
   ... test carefully ... 
   git commit -m "... comrehensive comment ..."

   # in the public working copy
   cd ../public                     # upstream = private
   git checkout 4public             # branch connected to upstream/4public
   git pull                         # pull in updates
   git checkout beta                # beta branch on public
   git rebase master                # sync with master on public
   ... test carefully ...           # test also that other experiments work
   git commit --amend               # amend the commit message (cf. below!)
   git push                         # push to private repository

In the amended commit message you should alert people about this new update of
the ```beta``` branch, and invite them to try it out.   Only after confirmation that
there is no problem should the commit be carried over to the ```master``` branch
of the public repository.

.. toctree::
   :maxdepth: 4
   :caption:

