## Recombinaison interactive ##

Vous pouvez aussi recombiner (rebase) les commits interactivement.
Ceci s'utilise souvent pour ré-écrire vos objets commits avant de les publier.
C'est une manière simple de découper, regrouper et ré-ordonner les commits
avant de les partager avec les autres. Vous pouvez aussi utiliser ça pour
nettoyer les commits que vous récupérerez chez quelqu'un avant de les appliquer
localement.

Si vous voulez modifier interactivement vos commit durant la recombinaison,
vous pouvez activer le mode interactif en utilisant l'option '-i' ou
'--interactive' avec la commande 'git rebase'.

	$ git rebase -i origin/master

Cela lancera le mode interactif de recombinaison, avec tous les commits
que vous avez créé depuis votre dernière publication (ou le dernier
merge depuis le dépôt d'origine).

Pour voir quels commits seront concernés, vous pouvez utiliser la
commande 'log' de cette façon:
	
	$ git log github/master..

Quand vous lancerez la commande 'rebase -i', vous vous trouverez dans
un éditeur qui ressemblera à ça:

	pick fc62e55 added file_size
	pick 9824bf4 fixed little thing
	pick 21d80a5 added number to log
	pick 76b9da6 added the apply command
	pick c264051 Revert "added file_size" - not implemented correctly

	# Rebase f408319..b04dc3d onto f408319
	#
	# Commands:
	#  p, pick = use commit
	#  e, edit = use commit, but stop for amending
	#  s, squash = use commit, but meld into previous commit
	#
	# If you remove a line here THAT COMMIT WILL BE LOST.
	# However, if you remove everything, the rebase will be aborted.
	#

Cela signifie qu'il y a 5 commits depuis votre dernière publication et
chaque commit est décrit par un ligne avec le format suivant:

	(action) (sha partiel) (court message du commit)
	
Maintenant, vous pouvez changer l'action (qui est 'pick' par défaut) soit
par 'edit', ou 'squash', ou juste la laisser comme elle est ('pick').
Vous pouvez aussi ré-ordonner les commits en déplaçant les lignes comme
vous le voulez. Ensuite, quand vous sortez de l'éditeur, git essayera
d'appliquer les commits en suivant leur ordre d'arrangement et l'action
sélectionnée.

Si 'pick' est sélectionné, il essayera simplement d'appliquer le patch et
de sauvegarder le commit avec le même message qu'avant.

Si 'squash' est sélectionné, il combinera ce commit avec le précédent pour
former un nouveau commit. Vous trouverez alors un autre éditeur pour merger
les messages des 2 commit qui ont étés assemblés ensemble. Donc, si vous
sortez du premier éditeur de la manière suivante:

	pick   fc62e55 added file_size
	squash 9824bf4 fixed little thing
	squash 21d80a5 added number to log
	squash 76b9da6 added the apply command
	squash c264051 Revert "added file_size" - not implemented correctly

vous devrez créer un nouveau message de commit `partir de ça:

	# This is a combination of 5 commits.
	# The first commit's message is:
	added file_size

	# This is the 2nd commit message:

	fixed little thing

	# This is the 3rd commit message:

	added number to log

	# This is the 4th commit message:

	added the apply command

	# This is the 5th commit message:

	Revert "added file_size" - not implemented correctly

	This reverts commit fc62e5543b195f18391886b9f663d5a7eca38e84.

Une fois que vous aurez édité cette partie en un seul message et quitté
l'éditeur, le commit sera sauvegardé avec votre nouveau message.

If 'edit' is specified, it will do the same thing, but then pause before 
moving on to the next one and drop you into the command line so you can 
amend the commit, or change the commit contents somehow.

If you wanted to split a commit, for instance, you would specify 'edit' for
that commit:

	pick   fc62e55 added file_size
	pick   9824bf4 fixed little thing
	edit   21d80a5 added number to log
	pick   76b9da6 added the apply command
	pick   c264051 Revert "added file_size" - not implemented correctly

And then when you get to the command line, you revert that commit and create
two (or more) new ones.  Lets say 21d80a5 modified two files, file1 and file2,
and you wanted to split them into seperate commits.  You could do this after
the rebase dropped you to the command line :

	$ git reset HEAD^
	$ git add file1
	$ git commit 'first part of split commit'
	$ git add file2
	$ git commit 'second part of split commit'
	$ git rebase --continue
	
And now instead of 5 commits, you would have 6.

The last useful thing that interactive rebase can do is drop commits for you.
If instead of choosing 'pick', 'squash' or 'edit' for the commit line, you 
simply remove the line, it will remove the commit from the history.