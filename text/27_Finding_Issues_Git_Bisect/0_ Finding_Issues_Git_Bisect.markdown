## Trouver les Problèmes - Git Bisect ##

Supposons que la version 2.6.18 de votre project fonctionne correctement,
mais que la version sur la branche "master" plante. Parfois, la meilleure
façon de trouver la cause d'une telle régression est de faire de la recherche
brutale dans l'historique de votre projet pour trouver un commit en particulier
responsable du problème. La commande linkgit:git-bisect[1] peut vous aider
dans cette démarche:

    $ git bisect start
    $ git bisect good v2.6.18
    $ git bisect bad master
    Bisecting: 3537 revisions left to test after this
    [65934a9a028b88e83e2b0f8b36618fe503349f8e] BLOCK: Make USB storage depend on SCSI rather than selecting it [try #6]

Si vous lancez "git branch" à ce moment, vous verrez que git vous
a temporairement déplacé sur une nouvelle branche nommée "bisect".
Cette branche pointe vers un commit (avec l'identifiant 65934...)
qui est accessible depuis "master" mais pas depuis v2.6.18.
Compilez et testez votre projet pour voir quand il plante.
En assument qu'il plante. Ensuite:

    $ git bisect bad
    Bisecting: 1769 revisions left to test after this
    [7eff82c8b1511017ae605f0c99ac275a7e21b867] i2c-core: Drop useless bitmaskings

récupère une version plus ancienne. Continuez comme ça, en disant
à chaque fois à git sit la version qu'il vous donne est bonne ou mauvaise,
et divisant par deux le nombre de révisions à tester à chaque étape.

Après environ 13 test (dans ce cas), il vous montrera l'identifiant du commit
qui pose problème. Vous pouvez examiner ce commit avec linkgit:git-show[1],
trouver qui a publié ce commit, et lui envoyer votre rapport de bug
par mail avec l'identifiant du commit concerné. Pour terminer, lancez:

    $ git bisect reset

pour revenir à la branche sur laquelle vous vous trouviez et
effacer la branche temporaire "bisect".

La version que git-bisect vous récupère à chaque étape n'est qu'une suggestion,
et vous pouvez choisir une version différente si vous pensez que c'est une
meilleure idée. Par exemple, vous tomberez parfois sur un commit qui pose
un problème qui ne concerne pas notre débuggage; lancez:

    $ git bisect visualize

qui affichera gitk et marquera les commits qu'il choisira avec une étiquette
"bisect". Choisissez un commit qui vous parait sûr, notez l'identifiant du
commit, et récupérez le avec:

    $ git reset --hard fb47ddb2db...

puis testez, lancez "bisect good" ou "bisect bad" comme il convient,
et continuez.