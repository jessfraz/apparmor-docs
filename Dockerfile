FROM debian:jessie

RUN apt-get update && apt-get install -y \
	git \
	ca-certificates \
	libreoffice \
	unoconv \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

# clone the repo
RUN git clone https://gitlab.com/apparmor/apparmor.git /usr/src/apparmor

WORKDIR /usr/src/apparmor/documentation

# convert the .odt files to .pdf
RUN bash -c '( \
	find /usr/src/apparmor/documentation -name "*.odt" -print0 | while IFS= read -r -d "" file; do \
		clean_file=${file// /_}; \
		clean_file=${clean_file//_-_/-}; \
		clean_file=$(echo $clean_file | tr "[:upper:]" "[:lower:]"); \
		clean_file=${clean_file//odt/pdf}; \
		echo "Generating pdf --> $clean_file"; \
		unoconv -v -f pdf --output "$clean_file" "$file"; \
	done \
	)'
