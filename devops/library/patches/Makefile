ANSIBLE=$(shell ansible --version | awk '/ansible python module location/ { print $$6 }')

LXD_ORG=$(ANSIBLE)/../ansible_collections/community/general/plugins/modules/cloud/lxd/lxd_container.py

.PHONY: update

update:
	cp $(LXD_ORG) ../lxd_container.py

patch:
	patch ../lxd_container.py lxd_container.diff

diff:
	diff -u $(LXD_ORG) ../lxd_container.py > lxd_container.diff || :

# lxd_container.diff: $(ANSIBLE)/../ansible_collections/community/general/plugins/modules/cloud/lxd/lxd_container.py ../lxd_container.py
#	diff -u $+ > $@ || :
