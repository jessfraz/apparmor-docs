.SUFFIXES: .odt .pdf

IN := odt
pdf := pdf

.PHONY: all
all: make_directories .odt.pdf

.PHONY: build
build:
	@docker build --rm --force-rm -t jess/apparmor-docs .

%.odt: build
	-$(shell docker run --rm jess/apparmor-docs bash -c 'tar -c *.odt' | tar -xvC $(IN) > /dev/null)

.odt.pdf: build
	-$(shell docker run --rm jess/apparmor-docs bash -c 'tar -c *.pdf' | tar -xvC $(OUT) > /dev/null)

.PHONY: make_directories
make_directories: $(IN)/ $(OUT)/

$(IN)/:
    mkdir -p $@

$(OUT)/:
    mkdir -p $@
