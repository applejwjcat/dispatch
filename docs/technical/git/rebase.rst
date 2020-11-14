Rebase
------

To avoid a possibly confusuing git log that contains two
parallel lines of developing, followed by a merge, it may
be better to use ``git rebase``.

To move your committed changes past new commits from a pull:::

   git rebase origin/master

Some merging of changes may be required after that

.. toctree::
   :maxdepth: 4

