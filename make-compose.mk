compose:
	docker-compose up

compose-build:
	docker-compose build

compose-install:
	docker-compose run app bundle install

compose-bash:
	docker-compose run app bash

compose-console:
	docker-compose run app bin/rails c

compose-db-init:
	docker-compose run app bin/rails db:create
	docker-compose run app bin/rails db:migrate

compose-setup: ansible-development-setup-env \
	compose-build \
	compose-install \
	compose-db-init

compose-restart:
	docker-compose restart

compose-stop:
	docker-compose stop

compose-kill:
	docker-compose kill
