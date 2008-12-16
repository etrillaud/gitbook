## Le Répertoire Git et le Répertoire de Travail ##

### Le Répertoire Git ###

Le 'répertoire git' est un répertoire qui contient tout l'historique de Git
et les méta information du projet - avec tous les objets (commits, tree,
blobs, tags), tous les pointeurs vers les différentes branches et plus
encore.

Il y a un seul répertoire Git par projet (au contraire de sytèeme comme SVN
ou CVS qui contient ce répertoire dans chaque sous-répertoire du projet),
ce dossier se nomme '.git' (par défaut, il peut être nommé differement), et
ce dossier se situe à la racine de votre projet. Si vous regardez le contenu
de ce répertoire, vous pouvez y trouver tous vos fichiers important:

    $>tree -L 1
    .
    |-- HEAD         # pointer to your current branch
    |-- config       # your configuration preferences
    |-- description  # description of your project 
    |-- hooks/       # pre/post action hooks
    |-- index        # index file (see next section)
    |-- logs/        # a history of where your branches have been
    |-- objects/     # your objects (commits, trees, blobs, tags)
    `-- refs/        # pointers to your branches

(Vous pourrez trouver d'autres fichiers/dossiers ici aussi, mais ils ne sont pas important pour
l'instant)

### Le Répertoire de Travail ###

Le 'répertoire de travail' de Git est le répertoire qui contient la version
courante des fichiers sur lesquels vous travaillez. Les fichiers de ce répertoire
sont souvent effacés ou remplacés par Git quand vous chagez de branche - c'est
tout à fait normal. Tout votre historiaue est stocké dans votre répertoire Git;
le répertoire de travail est simplement une version temporaire de votre projet où
vous modifier les fichiers jusqu'à votre prochain commit.