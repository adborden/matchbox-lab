.PHONY: build deploy

CONTAINER_LINUX_CONFIGS := $(wildcard ignition/*.yaml)
IGNITION_CONFIGS := $(patsubst ignition/%.yaml, ignition/%.ign, $(CONTAINER_LINUX_CONFIGS))

build: $(IGNITION_CONFIGS)

ignition/%.ign: ignition/%.yaml 
	docker run -i --rm quay.io/coreos/fcct:release --pretty --strict < $< > $@

deploy: build
	rsync -av --progress --delete --exclude '.*.swp' assets cloud generic groups ignition profiles ubuntu@matchbox.lab:/var/lib/matchbox/
