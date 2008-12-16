## Workflow Normal ##

Modifiez quelques fichiers, puis ajoutez leur contenu mis à jour dans
l'index:

    $ git add file1 file2 file3

Vous être maintenant prêts pour le commit. Vous pouvez vérifier ce qui
va être committé en utilisant la commande linkgit:git-diff[1] avec
l'option --cached:

    $ git diff --cached

(Sans l'option --cached, linkgit:git-diff[1] vous montrera les
changements qui vous avez fait mais que vous n'avait pas encore
ajouté à l'index.) Vous pouvez aussi trouver un résumé rapide
de la situation en utilisant la commande linkgit:git-status[1]:

    $ git status
    # On branch master
    # Changes to be committed:
    #   (use "git reset HEAD <file>..." to unstage)
    #
    #	modified:   file1
    #	modified:   file2
    #	modified:   file3
    #

Si vous devez faire d'autres changements, faites le maintenant, puis
ajoutez le contenu modifié à l'index. Enfin, committez vos
changements comme ceci:

    $ git commit

Il vous demandera de laisser un message pour décrire les changements
qui ont eu lieu, puis enregistrera une nouvelle version du projet.

Au lieu de lancer `git add` avant vos commit, vous pouvez aussi
utiliser directement cette commande:

    $ git commit -a
    
Le commit trouvera automatiquement les fichiers modifiés (mais pas
les nouveaux), les ajoutera à l'index et les committera, tout ça
dans foulée.

Une note sur le message du commit: Bien que ça ne soit pas
obligatoire, c'est une bonne idée de commencer le message du commit
avec une courte ligne (moins de 50 caractères) qui résume le
changement, suivi d'une ligne blanche puis d'une description plus
complète. Les outils qui transforment les commits en mail, par
exemple, utilisent la première ligne du commit pour le Sujet du
mail, et le reste pour le contenu.

#### Git surveille le contenu et pas les fichiers ####

Beaucoup de système de contrôle de version fournisse une commande
"add" qui demande au système de surveiller les changements dans
un nouveau fichier. La commande "add" de Git fait quelque chose
de plus simple et de plus puissant: `git add` est utilisé à la
fois pour les nouveaux fichiers et les fichiers nouvellement
modifiés. Dans les 2 cas, il prend une capture des fichiers
fournis et assemble leur contenu dans l'index, prêt à être
inclus dans le prochain commit.

[gitcast:c2_normal_workflow]("GitCast #2: Normal Workflow")