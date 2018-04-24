# For each docker dependency with a missing tag, this will show a line such as:
#   roles/icos.restheart/meta/main.yml-  - {role: icos.docker}
#
# The fix is to turn:
#   {role: icos.docker}
# Into:
#   {role: icos.docker, tags: docker}
#
# Otherwise these roles might up running more than once as ansible
# de-duplication of role dependencies fails.
show-missing-dependency-tags:
	rgrep 'dependencies:' roles -A1 | grep 'role:' | grep -v tags || :
