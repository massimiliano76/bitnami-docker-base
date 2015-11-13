all: build

build:
	@docker build --tag=bitnami/base-ubuntu:14.04 .
	@$(MAKE) -C onbuild $@
	@$(MAKE) -C buildpack $@
	@$(MAKE) -C base-apps $@
