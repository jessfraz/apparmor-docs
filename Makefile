.SUFFIXES: .odt .pdf

IN := odt
OUT := pdf

DOCKER_IMAGE := r.j3ss.co/apparmor-docs

.PHONY: all
all: make_directories .odt.pdf

.PHONY: build
build:
	@docker build --rm --force-rm -t $(DOCKER_IMAGE) .

%.odt: build
	-$(shell docker run --rm $(DOCKER_IMAGE) bash -c 'tar -c *.odt' | tar -xvC $(IN) > /dev/null)

.odt.pdf: build %.odt
	-$(shell docker run --rm $(DOCKER_IMAGE) bash -c 'tar -c *.pdf' | tar -xvC $(OUT) > /dev/null)

.PHONY: make_directories
make_directories: $(IN)/ $(OUT)/

$(IN)/:
	@mkdir -p $@

$(OUT)/:
	@mkdir -p $@
