Consolidating updates
---------------------

When developing your project -- either just adding input files and analysis scripts,
or when doing actual development of new code -- it is important to commit snapshots
to your local working copy of DISPATCH often (essentially after each file edit), but
also important to reorganize those commits before pushing to the on-line repository,
which is typiclally a fork you may be sharing with collaborators.

The dilemma is that pushing all the small incremental commits that you make to the local
working copy generates too much "noise" -- both literally, in the form of emails, and
in the sense that those commits are probably too fine-grained to be useful for others.
On the other hand, refraining to make frequent commits obliviates one of the main advantages
of code maintenance:  the ability to "backtrack", to find out when and what went wrong,
after the fact.

The way out of that dilemma is to reset to the start of the series of edits
when done, after saving the detailed edits as a temporary branch (e.g. named yy-mm-dd
for year-month-day), and then reorder and clean up, making a smaller number of
well-commented commits before pushing those to Bitbucket repository.

One of the advantages with this is that debug statements that were first added and then
removed disappear, reducing the "noise" in the commits that are pushed to the net.

Detailed examples:

.. toctree::
   :maxdepth: 4

   daily1
   daily2
   daily3
   daily4

