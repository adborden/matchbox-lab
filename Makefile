.DELETE_ON_ERROR:
.PHONY: build clean deploy update

FLATCAR_VERSION := 3374.2.2

CONTAINER_LINUX_CONFIGS := $(wildcard butane/*.yaml)
IGNITION_CONFIGS := $(patsubst butane/%.yaml, ignition/%.ign, $(CONTAINER_LINUX_CONFIGS))
FILES_CONTENT := $(wildcard files/*)

build: $(IGNITION_CONFIGS)

ignition/%.ign: butane/%.yaml $(FILES_CONTENT)
	docker run -i --rm --user $$(id --user):$$(id --group) --volume $(PWD):/app --workdir=/app quay.io/coreos/butane:latest --pretty --strict --files-dir files < $< > $@

deploy: build
	rsync -av --progress --delete --exclude '.*.swp' assets cloud generic groups ignition profiles ubuntu@matchbox.lab:/var/lib/matchbox/

update:
	bin/get-flatcar stable $(FLATCAR_VERSION) $(PWD)/assets

clean:
	rm -rf $(IGNITION_CONFIGS)
