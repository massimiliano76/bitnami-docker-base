all: build

build:
	@docker build --tag=bitnami/base-alpine:3.2 .
	@$(MAKE) -C onbuild $@
