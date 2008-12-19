## Git et les Mails ##

### Envoyer des patches pour un projet ###

Si vous avez juste effectué quelques modifications, le mail est la manière
la plus simple d'envoyer ces changements comme patches:

D'abord, utilisez linkgit:git-format-patch[1]; par exemple:

    $ git format-patch origin

produira un liste numérotée de fichiers présent dans le répertoire actuel,
avec un élément de la liste pour chaque patch de la branche courante qui
n'est pas présent dans la branche d'origine distante (origin/HEAD).

Vous pouvez ensuite importer ce texte dans votre client mail, et
l'envoyer manuellement. Cependant, si vous avez beaucoup de patches
à envoyer en même temps, il est préférable d'utiliser le script
linkgit:git-send-email[1] pour automatiser le processus. Consultez
la mailing-list du projet concerné pour savoir comment ces patches
sont habituellement gérés.

### Importer les patches dans un project ###

Git fournit aussi un outil nommée linkgit:git-am[1]; (am signifiant
"apply mailbox"), pour important un série de mails contenant des
patches. Sauvegardez tous les messages des mails contenant les
patches, dans l'ordre, dans une seule boite mail, disons "patches-mbox",
et lancez:

    $ git am -3 patches.mbox

Git appliquera chaque patch dans l'ordre; quand un conflit est trouvé,
il s'arrêtera et vous pourrez réparer les conflits comme décrit dans
"<<resolving-a-merge,Résoudre un merge>>". (L'option "-3" dit à git
d'effectuer un merge; si vous préférer juste laisser votre branche et
index inchangés, vous pouvez omettre cette option).

Une fois que l'index est mis à jour avec la résolution du conflit,
au lieu de créer un nouveau commit, lancez juste:

    $ git am --resolved

et git créera un commit pour vous, et continuera d'appliquer les
patches restant dans la boite mail.

Le résultat final sera une série de commits, un par patch présent
dans la boite mail originale, avec l'auteur et le message du commit
venant du mail correspondant à chaque patch.
