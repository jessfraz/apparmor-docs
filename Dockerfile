FROM debian:sid

RUN apt-get update && apt-get install -y \
	bzr \
	ca-certificates \
	libreoffice \
	unoconv \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

# clone the repo
RUN mkdir -p /usr/src/apparmor \
	&& bzr export /usr/src/apparmor lp:~apparmor-dev/apparmor/master

WORKDIR /usr/src/apparmor/documentation

# convert the .odt files to .pdf
RUN bash -c '( \
	find /usr/src/apparmor/documentation -name "*.odt" -print0 | while IFS= read -r -d "" file; do \
		clean_file=${file// /_}; \
		clean_file=${clean_file//_-_/-}; \
		clean_file=$(echo $clean_file | tr "[:upper:]" "[:lower:]"); \
		unoconv -v -f pdf --output "$clean_file" "$file"; \
	done \
	)'
