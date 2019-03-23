compose:
	docker-compose up

compose-build:
	docker-compose build

compose-bash:
	docker-compose run app bash

compose-console:
	docker-compose run app rails c

compose-db-init:
	docker-compose run app rails db:create
	docker-compose run app rails db:migrate

compose-setup: compose-build compose-install compose-db-init

compose-restart:
	docker-compose restart

compose-stop:
	docker-compose stop

compose-kill:
	docker-compose kill
