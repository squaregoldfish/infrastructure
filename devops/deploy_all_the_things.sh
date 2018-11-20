#!/bin/bash
# Clone all the repositories.
# Build all the jarfiles.
# Deploy all the things.
#
# 1) deploy_all_the_things.sh setup
# 2) nice deploy_all_the_things.sh allthethings
# 3) profit

set -e
set -u


function setup {
	mkdir -p "$WORK"
	cd "$WORK"
	mkdir -p base
	( cd base
	  for project in cpauth data meta doi stiltweb; do
		  if ! [ -d "$project" ]; then
			  git clone "https://github.com/ICOS-Carbon-Portal/$project"
		  fi
	  done )
	echo "Created $WORK and cloned the repos."
}

	
function pull {
	PULL=(cpauth data doi meta stiltweb)
	printf "%s\n" "${PULL[@]}" | xargs -i -P0 -n1 git -C base/{} "pull" -q
}


function sbt {
	local project="$1"
	shift
	echo "$project starting"
	if (cd "base/$project" && nice sbt "$@" >& compile.log); then
		echo "$project suceeded"
	else
		echo "$project failed"
	fi
}


function compile {
	sbt cpauth	 assembly
	sbt data	 assembly
	sbt meta	 assembly
	sbt doi		 'project appJVM' assembly
	sbt stiltweb assembly "project stiltcluster" assembly
}


function yml {
	file=$(find "$WORK/base/$1" -name "$2")
	stat "$file" --printf '# Modified\t%.19y\n# Size\t\t%s\n'
	echo -e "# sha1sum\t$(sha1sum "$file" | awk '{print $1}')"
	echo "$3: $file"
	echo 
}


function vars {
	(	echo -e "# Generated on $(date --rfc-3339='seconds')\n"
		yml cpauth 'cpauth-assembly*.jar' cpauth_jar_file
		yml data 'data-assembly*.jar' cpdata_jar_file
		yml doi 'doi-jvm-assembly*.jar' doi_jar_file
		yml meta 'meta-assembly*.jar' cpmeta_jar_file
		yml stiltweb 'stiltweb-assembly*.jar' stiltweb_jar_file
		yml stiltweb 'stiltcluster-assembly*.jar' stiltcluster_jar_file
	) > vars.yml
}


function deploy {
	cmd=(ansible-playbook
		 -i"$REPO_PARENT/infrastructure/devops/test.inventory"
		 "$REPO_PARENT/infrastructure/devops/icosprod.yml"
		 "-tcpauth,cpdata,doi,meta"
		 -e @vars.yml
		 "--vault-password-file=~/.vault_password"
		 )
	"${cmd[@]}" | tee deploy.log
}


function find_infrastructure_repo_dir {
	me=$(which "$0") || "$PWD/$0"
	me=$(readlink -f "$me")
	REPO_PARENT="${me%/infrastructure/devops/*.sh}"
	[ -d "$REPO_PARENT" ] || {
		echo "Could not find the parent directory of the infrastructure repo"
		exit 1
	}
	# This relies on find_infrastructure_repo_dir() having been run.
	WORK="$REPO_PARENT/deploy_all_the_things/"
}


find_infrastructure_repo_dir "$0"

if [[ "${1:-}" != "setup" ]]; then
	if ! [ -d "$WORK" ]; then
		echo "$WORK does not exist, first run 'setup'"
		exit 1
	fi
	# Many of the helper functions depend on the pwd being $WORK
	cd "$WORK";
fi

for arg in "$@"; do
	case "$arg" in
		"setup"		   ) setup;;
		"pull"		   ) pull;;
		"compile"	   ) compile;;
		"vars"		   ) vars;;
		"deploy"	   ) deploy;;
		"allthethings" )
			pull
			compile
			vars
			deploy
			;;
	esac
done
