.PHONY: all build run

all: run

build:
	@docker build --rm --force-rm -t jess/apparmor-docs .

run: build
	$(shell docker run --rm jess/apparmor-docs sh -c 'tar -c *.md' | tar -xvC $(CURDIR))
