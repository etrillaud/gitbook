### L'Objet Commit ###

L'objet "commit" lie l'état physique d'un "tree" avec une description
de la manière et de la raison de l'arrivée à cet état.

[fig:object-commit]

Vous pouvez utiliser linkgit:git-show[1] ou linkgit:git-log[1] avec
l'option  --pretty=raw pour examiner vos commits favoris:

    $ git show -s --pretty=raw 2be7fcb476
    commit 2be7fcb4764f2dbcee52635b91fedb1b3dcf7ab4
    tree fb3a8bdd0ceddd019615af4d57a53f43d8cee2bf
    parent 257a84d9d02e90447b149af58b271c19405edb6a
    author Dave Watson <dwatson@mimvista.com> 1187576872 -0400
    committer Junio C Hamano <gitster@pobox.com> 1187591163 -0700

        Fix misspelling of 'suppress' in docs

        Signed-off-by: Junio C Hamano <gitster@pobox.com>

Comme vous pouvez le voir, un commit est défini par:

- Un **tree**: Le nom SHA1 de l'objet "tree" (comme défini précédemment),
  représentant le contenu d'un répertoire à un certain moment.
- **parent(s)**: Le nom SHA1 de (ou des) numéro de commits qui représente
  l'étape antérieure dans l'historique du projet. L'exemple ci-dessus a un
  parent; les commits mergés peuvent en avoir plus d'un. Un commit sans parent
  est nommé le commit "racine", et représente la révision initiale d'un projet.
  Chaque projet doit contenir au moins une racine. Un projet peut avoir
  plusieurs racine, bien que ça ne soit pas très commun (ou que ça ne soit pas
  une bonne idée).
- Un **author**: Le nom de la personne responsable de ce changement,
  avec sa date
- Un **committer**: Le nom de la personne qui a créé le commit, avec la date
  de création. Cet attribut peut être différent de l'auteur; par exemple, si
  l'auteur écrit un patch est l'envoit à une autre personne par email, cet
  personne peut utilisé le patch pour créer le commit.
- Un **comment** qui décrit ce commit.

Note that a commit does not itself contain any information about what
actually changed; all changes are calculated by comparing the contents
of the tree referred to by this commit with the trees associated with
its parents.  In particular, git does not attempt to record file renames
explicitly, though it can identify cases where the existence of the same
file data at changing paths suggests a rename.  (See, for example, the
-M option to linkgit:git-diff[1]).

A commit is usually created by linkgit:git-commit[1], which creates a
commit whose parent is normally the current HEAD, and whose tree is
taken from the content currently stored in the index.

### The Object Model ###

So, now that we've looked at the 3 main object types (blob, tree and commit), 
let's take a quick look at how they all fit together.

If we had a simple project with the following directory structure:

    $>tree
    .
    |-- README
    `-- lib
        |-- inc
        |   `-- tricks.rb
        `-- mylib.rb

    2 directories, 3 files

And we committed this to a Git repository, it would be represented like this:

[fig:objects-example]

You can see that we have created a **tree** object for each directory (including the root)
and a **blob** object for each file.  Then we have a **commit** object to point
to the root, so we can track what our project looked like when it was committed.