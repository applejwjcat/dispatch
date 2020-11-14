GIT behind a firewall
----------------------

To use GIT with bitbucket on a cluster with a firewall you can use git over SSH, and
"tunnel" port 2222 on the remote machine to port 22 at bitbucket.org, via your laptop.
You also need to have an account at bitbucket.org (useful in any case); cf. separate
page. When this is arranged, do
::

   ssh -R 2222:bitbucket.org:22 your_login@host_behind_firewall
   

From the remote host point of view, the repository is available on the local port (2222), and
therefore the clone command look like so:
::

   git clone ssh://git@localhost:2222/aanordlund/dispatch.git

Once cloned, ``git pull`` and other GIT commands that need access to the repository will work,
as long as the SSH tunnel is connected.

If you want avoid having to add the extra options to the SSH command, you can instead add
the tunneling setup to your ``$(HOME)/.ssh/config`` file on the host or laptop that you use
to login to the cluster:
::

  Host clusteralias
      HostName cluster.domain
      User username
      RemoteForward 2222 bitbucket.org:22


For more on how to set up bitbucket for SSH, see
`Atlassians instructions <https://confluence.atlassian.com/bitbucket/set-up-ssh-for-git-728138079.html>`_,
including how to add an SSH key to your bitbucket profile.


.. toctree::
   :maxdepth: 4

