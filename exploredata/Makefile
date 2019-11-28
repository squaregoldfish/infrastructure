-include .env

JUPYTER?=../../jupyter
DEVOPS=../devops
EXPLOREDATA=ansible-playbook $(DEVOPS)/exploredata.yml -i$(DEVOPS)/production.inventory -lexploredata

.PHONY: build up notebook hub pushtest pushprod notebook-shell clean force

build: notebook hub

up: build
	docker-compose up

notebook: build.notebook
	docker build -t $(NOTEBOOK_IMAGE) build.notebook

build.notebook: force
	mkdir -p build.notebook
	rsync -a --delete $(JUPYTER)/education $(JUPYTER)/icos_jupyter_notebooks $(JUPYTER)/project_jupyter_notebooks $@

hub:
	docker-compose build

pushtest: build.notebook
	$(EXPLOREDATA) -eexploredata_src=$(PWD) -tpushtest

pushprod: build.notebook
	$(EXPLOREDATA) -eexploredata_src=$(PWD) -tpushprod

notebook-shell: notebook
	docker run --rm -it --entrypoint=bash notebook

clean:
	rm -rf build.notebook/icos_jupyter_notebooks
	rm -rf build.notebook/education

force: ;
