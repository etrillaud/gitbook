## Git Hooks ##

[Git Hooks](http://www.kernel.org/pub/software/scm/git/docs/githooks.html)

### Hooks Côté Serveur ###

#### Reception de Post ####


	GIT_DIR/hooks/post-receive

Si vous écrivez ceci en Ruby, vous pourrez obtenir les arguments de cette
manière:

	ruby
	rev_old, rev_new, ref = STDIN.read.split(" ")

Ou en script bash, quelque chose comme ça peut fonctionner:
	
	#!/bin/sh
	# <oldrev> <newrev> <refname>
	# update a blame tree
	while read oldrev newrev ref
	do
		echo "STARTING [$oldrev $newrev $ref]"
		for path in `git diff-tree -r $oldrev..$newrev | awk '{print $6}'`
		do
		  echo "git update-ref refs/blametree/$ref/$path $newrev"
		  `git update-ref refs/blametree/$ref/$path $newrev`
		done
	done
	

### Hooks Côté Client ###


#### Pre Commit ####

Lancer vos tests automatiquement avant de committer

 	GIT_DIR/hooks/pre-commit

Voici un exemple d'un script Ruby qui exécute des tests RSpec avant de vous
permettre de faire un commit.

	ruby  
	html_path = "spec_results.html"  
	`spec -f h:#{html_path} -f p spec` # lancer rspec, affichier la prograssion, sauvegarde le resultat html dans html_path

	# affiche combien d'erreurs ont été trouvées
	html = open(html_path).read  
	examples = html.match(/(\d+) examples/)[0].to_i rescue 0  
	failures = html.match(/(\d+) failures/)[0].to_i rescue 0  
	pending = html.match(/(\d+) pending/)[0].to_i rescue 0  

	if failures.zero?  
	  puts "0 failures! #{examples} run, #{pending} pending"  
	else  
	  puts "\aDID NOT COMMIT YOUR FILES!"  
	  puts "View spec results at #{File.expand_path(html_path)}"  
	  puts  
	  puts "#{failures} failures! #{examples} run, #{pending} pending"  
	  exit 1  
	end

* http://probablycorey.wordpress.com/2008/03/07/git-hooks-make-me-giddy/