## Création de Nouvelles Branches Vides ##

Parfois, vous voudrez peut-être garder certaines branches dans votre dépôt
qui ne partagent pas d'ancêtre en commun avec votre code normal. Des exemples
de ce genre d'utilisation peut être de la documentation automatiquement
générée ou des choses dans ce style. Si vous voulez créer une nouvelle
branche qui n'utilise pas la base du code actuelle comme parent,
vous pouvez créer une branche vide comme ceci:

    git symbolic-ref HEAD refs/heads/nouvellebranche 
    rm .git/index 
    git clean -fdx 
    <travailler> 
    git add vos fichiers 
    git commit -m 'Premier commit'
    
[gitcast:c9-empty-branch]("GitCast #7: Creating Empty Branches")
