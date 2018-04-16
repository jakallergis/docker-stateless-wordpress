FROM ubuntu:latest
MAINTAINER John A. Kallergis <j.a.kallergis@gmail.com>

# install the packages we need
RUN set -ex; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		pwgen \
	; \
	\
	rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/secrets

COPY secrets.sh /usr/local/bin
RUN chmod +x /usr/local/bin/secrets.sh

ENTRYPOINT ["secrets.sh"]