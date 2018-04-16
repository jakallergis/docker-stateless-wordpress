include .env

default: development

development: down clean-development run-development
production: down clean-production build-secrets run-secrets run-production
new-production: down prune-volumes clean-production build-secrets run-secrets run-production

clean-development: clean-wordpres clean-nginx
clean-production: clean-wordpres clean-nginx clean-secrets

reset: down clean-wordpres clean-nginx clean-secrets prune-all empty-secrets

down:
	docker-compose down;

stop:
	docker-compose stop;

build-development:
	docker-compose build --force-rm --no-cache;

build-production:
	docker-compose \
		-f docker-compose.yml \
		-f docker-compose.prod.yml \
		build --force-rm --no-cache;

build-secrets:
	docker build ./secrets-generator -t ${COMPOSE_PROJECT_NAME}_secrets_generator;

run-development:
	docker-compose up \
		--build \
		--force-recreate \
		--always-recreate-deps;

run-production:
	docker-compose \
		-f docker-compose.yml \
		-f docker-compose.prod.yml \
		up

run-secrets:
	if ! [ -d `pwd`/secrets ]; then \
		mkdir `pwd`/secrets; \
		touch `pwd`/secrets/DB_ROOT_PASSWORD; \
		touch `pwd`/secrets/DB_NAME; \
		touch `pwd`/secrets/DB_USER; \
		touch `pwd`/secrets/DB_PASSWORD; \
	fi
	docker run --rm -ti \
		-v `pwd`/secrets:/usr/src/secrets \
		--name ${COMPOSE_PROJECT_NAME}_secrets_generator \
		${COMPOSE_PROJECT_NAME}_secrets_generator

clean-wordpres:
	docker rmi -f ${COMPOSE_PROJECT_NAME}_wordpress;

clean-nginx:
	docker rmi -f ${COMPOSE_PROJECT_NAME}_nginx;

clean-secrets:
	docker rmi -f ${COMPOSE_PROJECT_NAME}_secrets_generator;

prune-all: prune-containers prune-networks prune-volumes

prune-containers:
	docker container prune -f

prune-networks:
	docker network prune -f;

prune-volumes:
	docker volume prune -f;

empty-secrets:
	rm -rf `pwd`/secrets

.PHONY: development production new-production \
	clean-development clean-production \
	reset down stop \
	build-development build-production build-secrets \
	run-development run-production run-secrets \
	clean-wordpress clean-nginx clean-secrets \
	prune-all prune-containers prune-networks prune-volumes \
	empty-secrets