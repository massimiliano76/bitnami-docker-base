all:
%::
	@$(MAKE) -C ubuntu $@
	@$(MAKE) -C alpine $@

test:
	echo "No tests available on base images"
