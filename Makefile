WP_DATA = /home/data/wordpress #define the path to the wordpress data
DB_DATA = /home/data/mariadb #define the path to the mariadb data

# default target
all: up

# start the building process
# create the wordpress and mariadb data directories
# start the containers in the background and leaves them running
up: build
	@mkdir -p $(WP_DATA)
	@mkdir -p $(DB_DATA)
	docker-compose -f ./docker-compose.yml up -d

# stop the containers
down:
	docker-compose -f ./docker-compose.yml down

stop:
	docker-compose -f ./docker-compose.yml stop

start:
	docker-compose -f ./docker-compose.yml start

# build the containers
build:
	docker-compose -f ./docker-compose.yml build

# clean the containers
clean:
	@docker stop $$(docker ps -qa) || true
	@docker rm $$(docker ps -qa) || true
	@docker rmi $$(docker images -qa) || true
	@docker volume rm $$(docker volume ls -q) || true
	@docker network rm $$(docker network ls -q) || true
	@rm -rf $(WP_DATA) || true
	@rm -rf $(DB_DATA) || true

# clean and start the containers
re: clean up

# prune the containers: execute the clean target and remove all containers, images, volumes from the system
prune: clean
	@docker system prune -a --volumes -f