ANSIBLE=$(shell ansible --version | awk '/ansible python module location/ { print $$6 }')

lxd_container.diff: $(ANSIBLE)/modules/cloud/lxd/lxd_container.py ../lxd_container.py
	diff -u $+ > $@ || :
