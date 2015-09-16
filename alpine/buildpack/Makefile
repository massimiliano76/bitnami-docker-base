all: build

build:
	@docker build --tag=bitnami/base-alpine:3.2-buildpack .
	@$(MAKE) -C onbuild $@
