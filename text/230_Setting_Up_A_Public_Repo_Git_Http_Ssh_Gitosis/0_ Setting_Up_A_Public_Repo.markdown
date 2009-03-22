## Configurer un Dépôt Publique ##

En supposant que vous avez votre dépôt personnel dans le dossier ~/proj,
nous allons créer un nouveau clone de ce dépôt et prévenir git-daemon qu'il
est destiné à être publique:

    $ git clone --bare ~/proj proj.git
    $ touch proj.git/git-daemon-export-ok

Le dossier proj.git obtenu contient un dépôt git "nu" (bare)--il contient
juste le contenu du répertoire ".git", sans aucun autres fichiers récupérés
autour de ce dossier.

Ensuite, copiez proj.git sur le serveur où vous allez héberger votre
dépôt publique. Vous pouvez utiliser scp, rsync, ou ce qui vous convient
le plus.

### Exporter un dépôt git avec le protocole git ###

C'est la méthode la plus utilisée.

Si quelqu'un d'autre s'occupe de l'administration de votre serveur, il devrait
vous indiquer dans quel répertoire mettre votre dépôt, et sur quelle adresse
git:// vous pourrez le récupérer.

Sinon, vous devez démarrer linkgit:git-daemon[1]; il ecoutera le port 9418.
Par défaut, il autorise les accès à tout ce qui ressemble à un répertoire
git, et qui contient le fichier magique git-daemon-export-ok. Si vous
ajoutez le chemin de quelques dossiers en options de git-daemon,
il restreindra les exportation en ne tenant compte que de ces dossiers.

Vous pouvez aussi lancer git-daemon comme service inetd;
regardez le manuel de linkgit:git-daemon[1]; (man git-daemon),
particulièrement les exemples, pour plus d'informations.

### Exporter un dépôt git par http ###

Le protocole git est plus performant et plus fiable, mais sur un hébergeur
qui a déjà configuré son serveur web, l'exportation http peut être une
solution plus simple à mettre en place.

Tout ce que vous devez faire est de placer le dépôt git (bare) que
vous venez de créer dans un dossier qui est accessible depuis le serveur
web, et faire quelques ajustements pour donner au client web les
quelques informations additionnelles qu'il a besoin:

    $ mv proj.git /home/you/public_html/proj.git
    $ cd proj.git
    $ git --bare update-server-info
    $ chmod a+x hooks/post-update

Pour plus d'explications sur ces 2 dernières lignes, regardez la
documentation de linkgit:git-update-server-info[1] et linkgit:githooks[5].

Il vous suffit ensuite de diffuser l'adresse de proj.git aux autres
développeurs. Tout le monde aura la possibilité de cloner ou de 
récupérer (pull) les changements du projet depuis cette adresse,
avec la commande suivante par exemple:

    $ git clone http://yourserver.com/~you/proj.git
