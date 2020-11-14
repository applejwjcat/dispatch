Using rebase
---------------------

::

   # -- at start of the day --
   git checkout master                          # get master branch
   git pull                                     # pull in changes from elsewhere
   
   # -- during the day --
   ... edit ...                                 # a small number of edits
   git commit -a -m comment                     # GIT snapshot, with only terse comment
   ... edit ...                                 # a small number of edits
   git commit -a -m comment                     # GIT snapshot, with only terse comment
   ...

   # -- merge in edits from elsewhere --
   git fetch                                    # get updates from elsewhere
   git rebase origin/master                     # your edits become relative to that
   ... may require some edits + commits ...     # in case of collisions
   
   # -- consolidate --
   git branch yy-mm-dd                          # create a backup, temporary branch
   git reset origin/master                      # reset, to get all edits merged together
   git add -p                                   # add _selected_, related edits
   git commit -m "DBG comrehensive comment"     # possibly use 'commit -m' and an editor
   git add -p                                   # add _selected_, related edits
   git commit -m "ORG comrehensive comment"     # possibly use 'commit -m' and an editor
   git add -p                                   # add _selected_, related edits
   git commit -m "DIA comrehensive comment"     # possibly use 'commit -m' and an editor
   git push                                     # push your consolidated commits
   git branch -D yy-mm-dd                       # optionally, delete the temporary branch

.. toctree::
   :maxdepth: 4

