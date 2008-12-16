## L'Index Git ##

L'index Git est une zone d'assemblage entre votre répertoire de travail
et votre dépôt. Vous pouvez utiliser l'index pour contruire un groupe de
changements qui seront committé ensemble. Quand vous créez un commit, ce
qui se trouve dans l'index est ce qui est committé, et pas ce qui se trouve
dans le répertoire de travail.

### Looking at the Index ###

The easiest way to see what is in the index is with the linkgit:git-status[1]
command.  When you run git status, you can see which files are staged
(currently in your index), which are modified but not yet staged, and which
are completely untracked.

    $>git status
    # On branch master
    # Your branch is behind 'origin/master' by 11 commits, and can be fast-forwarded.
    #
    # Changes to be committed:
    #   (use "git reset HEAD <file>..." to unstage)
    #
    #	modified:   daemon.c
    #
    # Changed but not updated:
    #   (use "git add <file>..." to update what will be committed)
    #
    #	modified:   grep.c
    #	modified:   grep.h
    #
    # Untracked files:
    #   (use "git add <file>..." to include in what will be committed)
    #
    #	blametree
    #	blametree-init
    #	git-gui/git-citool

If you blow the index away entirely, you generally haven't lost any
information as long as you have the name of the tree that it described.

And with that, you should have a pretty good understanding of the basics of 
what Git is doing behind the scenes, and why it is a bit different than most
other SCM systems.  Don't worry if you don't totally understand it all right 
now; we'll revisit all of these topics in the next sections. Now we're ready 
to move on to installing, configuring and using Git.  