.PHONY: all build run

all: run

build:
	@docker build --rm --force-rm -t jess/apparmor-docs .

run: build
	$(shell docker run --rm jess/apparmor-docs bash -c 'tar -c *.pdf' | tar -xvC $(CURDIR) > /dev/null)
