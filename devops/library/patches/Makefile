ANSIBLE=$(HOME)/.local/lib/python2.7/site-packages/ansible

lxd_container.diff: $(ANSIBLE)/modules/cloud/lxd/lxd_container.py ../lxd_container.py
	diff -u $+ > $@ || :
