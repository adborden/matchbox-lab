.DELETE_ON_ERROR:
.PHONY: deploy test update

FLATCAR_VERSION := 3374.2.2

CONTAINER_LINUX_CONFIGS := $(wildcard ignition/*.yaml)

test: $(CONTAINER_LINUX_CONFIGS)
	@for config in $(CONTAINER_LINUX_CONFIGS); do \
	echo -n "$$config ... "; \
	docker run -i --rm --workdir=/app quay.io/coreos/butane:latest --pretty --strict < $$config > /dev/null; \
	echo ok; \
	done

deploy: test
	rsync -av --progress --delete --exclude '.*.swp' assets cloud generic groups ignition profiles ubuntu@matchbox.lab:/var/lib/matchbox/

update:
	bin/get-flatcar stable $(FLATCAR_VERSION) $(PWD)/assets
