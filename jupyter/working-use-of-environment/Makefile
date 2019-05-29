final: packages
	docker build . --tag jh-final -f Dockerfile.final

packages: shell
	docker build . --tag jh-packages -f Dockerfile.packages

shell:
	docker build . --tag jh-shell -f Dockerfile.shell
