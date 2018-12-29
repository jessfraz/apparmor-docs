.SUFFIXES: .odt .pdf

IN := odt
OUT := pdf

DOCKER_IMAGE := r.j3ss.co/apparmor-docs

.PHONY: all
all: make_directories .odt.pdf ## Generate the PDFs.

.PHONY: build
build: ## Build the docker image.
	@docker build --rm --force-rm --no-cache -t $(DOCKER_IMAGE) .

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

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | sed 's/^[^:]*://g' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
