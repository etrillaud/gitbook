## Les Protocoles de Transfert ##

Nous allons voir ici les communications qui ont lieu entre les client
et les serveur pour permettre à Git de transférer des données.

### Récupération des Données avec HTTP ###

Git utilise un protocole un peu plus fragile quand il récupère des données
sur une adresse http/https. Dans ce cas, toute la logique se déroule du côté
client. Le serveur ne requiert pas de configuration spéciale - n'importe
quel serveur web statique fonctionnera si le dossier git que vous récupérez
est dans un chemin accessible depuis le serveur web.

Afin de faire fonctionner tout ça, vous devez lancer une simple commande sur
le dépôt du serveur chaque fois que quelque chose est mis à jour.
linkgit:git-update-server-info[0] met à jour les objects/info/packs et les
fichiers d'info/refs pour afficher quelles références et packfiles sont
disponibles, puisque vous ne pouvez pas faire une liste avec http.
Quand cette commande est lancée, le fichier objects/info/packs ressemblera
à quelque chose comme ça:

	P pack-ce2bd34abc3d8ebc5922dc81b2e1f30bf17c10cc.pack
	P pack-7ad5f5d05f5e20025898c95296fe4b9c861246d8.pack

Donc si la récupération (fetch) ne peut pas trouver un fichier seul, il peut
essayer de le chercher dans ces packfiles. Le fichier info/refs ressemblera
à quelque chose comme ça:

	184063c9b594f8968d61a686b2f6052779551613	refs/heads/development
	32aae7aef7a412d62192f710f2130302997ec883	refs/heads/master

Quand vous faite une récupération (fetch) sur ce dépôt, elle commencera par
ces références et parcourera les objets commits jusqu'à que le client
ait tous les objets qu'il a besoin.

Par exemple, si vous demandez de récupérer la branche "master", il verra que
"master" pointe sur <code>32aae7ae</code> et que votre master pointe sur
<code>ab04d88</code>, donc vous aurez besoin de <code>32aae7ae</code>.
Vous récupérez cet objet:

	CONNECT http://myserver.com
	GET /git/myproject.git/objects/32/aae7aef7a412d62192f710f2130302997ec883 - 200
	
et il ressemble à ça:

	tree aa176fb83a47d00386be237b450fb9dfb5be251a
	parent bd71cad2d597d0f1827d4a3f67bb96a646f02889
	author Scott Chacon <schacon@gmail.com> 1220463037 -0700
	committer Scott Chacon <schacon@gmail.com> 1220463037 -0700

	added chapters on private repo setup, scm migration, raw git

donc maintenant il récupère le "tree" <code>aa176fb8</code>:

	GET /git/myproject.git/objects/aa/176fb83a47d00386be237b450fb9dfb5be251a - 200

qui ressemble à ça:

	100644 blob 6ff87c4664981e4397625791c8ea3bbb5f2279a3	COPYING
	100644 blob 97b51a6d3685b093cfb345c9e79516e5099a13fb	README
	100644 blob 9d1b23b8660817e4a74006f15fae86e2a508c573	Rakefile

donc il récupère ces objets:

	GET /git/myproject.git/objects/6f/f87c4664981e4397625791c8ea3bbb5f2279a3 - 200
	GET /git/myproject.git/objects/97/b51a6d3685b093cfb345c9e79516e5099a13fb - 200
	GET /git/myproject.git/objects/9d/1b23b8660817e4a74006f15fae86e2a508c573 - 200

Curl est utilisé pour cette opération, et plusieurs thread parallèles sont
ouverts pour accélerer ce processus. Quand il a terminé d'examiner le tree
pointé par le commit, il récupère le prochain parent:
	
	GET /git/myproject.git/objects/bd/71cad2d597d0f1827d4a3f67bb96a646f02889 - 200

Maintenant dans ce cas, le commit qui revient ressemble à ça:

	tree b4cc00cf8546edd4fcf29defc3aec14de53e6cf8
	parent ab04d884140f7b0cf8bbf86d6883869f16a46f65
	author Scott Chacon <schacon@gmail.com> 1220421161 -0700
	committer Scott Chacon <schacon@gmail.com> 1220421161 -0700

	added chapters on the packfile and how git stores objects

et vous pouvez voir que le parent, <code>ab04d88</code>, est là où pointe la
branche courante. Donc, nous avec récupérer récursivement ce tree puis arrêter
puis que nous avons récupérer tout ce qui nous manquait jusqu'à ce point. Vous
pouvez forcer Git à verifier par deux fois que nous avons tout ce qu'il nous
avec l'option '--recover'. Voir linkgit:git-http-fetch[1] pour plus
d'informations.

Si la récupération de l'un des objet seul échoue, Git téléchargement
automatiquement les index des packfiles pour retrouver le sha nécessaire,
puis téléchargera ce packfile.

Si vous avec un serveur git qui fournit des dépôt de cette façon, il est
important d'implémenter un hook de post-receive qui exécute la commande
'git update-server-info' à chaque mise à jour pour éviter les confusions.

### Fetching Data with Upload Pack ###

For the smarter protocols, fetching objects is much more efficient.  A socket
is opened, either over ssh or over port 9418 (in the case of the git:// protocol),
and the linkgit:git-fetch-pack[1] command on the client begins communicating with
a forked linkgit:git-upload-pack[1] process on the server.

Then the server will tell the client which SHAs it has for each ref,
and the client figures out what it needs and responds with a list of SHAs it
wants and already has.

At this point, the server will generate a packfile with all the objects that 
the client needs and begin streaming it down to the client.

Let's look at an example.

The client connects and sends the request header. The clone command

	$ git clone git://myserver.com/project.git

produces the following request:

	0032git-upload-pack /project.git\\000host=myserver.com\\000

The first four bytes contain the hex length of the line (including 4 byte line
length and trailing newline if present). Following are the command and
arguments. This is followed by a null byte and then the host information. The
request is terminated by a null byte.

The request is processed and turned into a call to git-upload-pack:

 	$ git-upload-pack /path/to/repos/project.git

This immediately returns information of the repo:

	007c74730d410fcb6603ace96f1dc55ea6196122532d HEAD\\000multi_ack thin-pack side-band side-band-64k ofs-delta shallow no-progress
	003e7d1665144a3a975c05f1f43902ddaf084e784dbe refs/heads/debug
	003d5a3f6be755bbb7deae50065988cbfa1ffa9ab68a refs/heads/dist
	003e7e47fe2bd8d01d481f44d7af0531bd93d3b21c01 refs/heads/local
	003f74730d410fcb6603ace96f1dc55ea6196122532d refs/heads/master
	0000

Each line starts with a four byte line length declaration in hex. The section
is terminated by a line length declaration of 0000.

This is sent back to the client verbatim. The client responds with another
request:

	0054want 74730d410fcb6603ace96f1dc55ea6196122532d multi_ack side-band-64k ofs-delta
	0032want 7d1665144a3a975c05f1f43902ddaf084e784dbe
	0032want 5a3f6be755bbb7deae50065988cbfa1ffa9ab68a
	0032want 7e47fe2bd8d01d481f44d7af0531bd93d3b21c01
	0032want 74730d410fcb6603ace96f1dc55ea6196122532d
	00000009done

The is sent to the open git-upload-pack process which then streams out the 
final response:

	"0008NAK\n"
	"0023\\002Counting objects: 2797, done.\n"
	"002b\\002Compressing objects:   0% (1/1177)   \r"
	"002c\\002Compressing objects:   1% (12/1177)   \r"
	"002c\\002Compressing objects:   2% (24/1177)   \r"
	"002c\\002Compressing objects:   3% (36/1177)   \r"
	"002c\\002Compressing objects:   4% (48/1177)   \r"
	"002c\\002Compressing objects:   5% (59/1177)   \r"
	"002c\\002Compressing objects:   6% (71/1177)   \r"
	"0053\\002Compressing objects:   7% (83/1177)   \rCompressing objects:   8% (95/1177)   \r"
	...
	"005b\\002Compressing objects: 100% (1177/1177)   \rCompressing objects: 100% (1177/1177), done.\n"
	"2004\\001PACK\\000\\000\\000\\002\\000\\000\n\\355\\225\\017x\\234\\235\\216K\n\\302"...
	"2005\\001\\360\\204{\\225\\376\\330\\345]z\226\273"...
	...
	"0037\\002Total 2797 (delta 1799), reused 2360 (delta 1529)\n"
	...
	"<\\276\\255L\\273s\\005\\001w0006\\001[0000"
	
See the Packfile chapter previously for the actual format of the packfile data
in the response.
	
### Pushing Data ###

Pushing data over the git and ssh protocols is similar, but simpler.  Basically
what happens is the client requests a receive-pack instance, which is started
up if the client has access, then the server returns all the ref head shas it
has again and the client generates a packfile of everything the server needs
(generally only if what is on the server is a direct ancestor of what it is
pushing) and sends that packfile upstream, where the server either stores it
on disk and builds an index for it, or unpacks it (if there aren't many objects
in it)

This entire process is accomplished through the linkgit:git-send-pack[1] command
on the client, which is invoked by linkgit:git-push[1] and the 
linkgit:git-receive-pack[1] command on the server side, which is invoked by 
the ssh connect process or git daemon (if it's an open push server).


