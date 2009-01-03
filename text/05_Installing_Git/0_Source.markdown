### Installer depuis le Code Source ###

Rapidement, sur un système Unix, vous pouvez télécharger le code source de Git
depuis la [Page de Téléchargement de Git][], puis
dérouler l'installation de cette façon:

    $ make prefix=/usr all ;# avec votre utilisateur
    $ make prefix=/usr install ;# avec l'utilisateur root

Vous aurez besoin des librairies [expat][], [curl][], [zlib][], et [openssl][]
déjà installées; normalement, à part *expat*, ces librairies devraient déjà
se trouver sur votre système.

[Page de Téléchargement de Git]:  http://git-scm.com/download
[expat]:                          http://expat.sourceforge.net/
[curl]:                           http://curl.linux-mirror.org
[zlib]:                           http://www.zlib.net
[openssl]:                        http://www.openssl.org