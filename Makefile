name = INECPTION

.DEFAULT_GOAL := start

start: env_certs all
 
env_certs:
	@echo "🌱 Creating environment files and certificates..."
	./create_project.sh

all:
	@printf "Launching ${name}...\n"
	@bash srcs/requirements/wordpress/tools/make_db_dirs.sh
	@docker compose -f ./srcs/docker-compose.yml up -d --build
	echo 'define('WP_HOME', 'https://yourdomain.com');' >> /home/jsaintho/data/wordpress/wp-config.php
	echo 'define('WP_SITEURL', 'https://yourdomain.com');' >> /home/jsaintho/data/wordpress/wp-config.php

build:
	@printf "Building  ${name}...\n"
	@bash srcs/requirements/wordpress/tools/make_db_dirs.sh
	@docker compose -f ./srcs/docker-compose.yml build

down:
	@printf "Stopping ${name}...\n"
	@docker compose -f ./srcs/docker-compose.yml down

clean:
	@printf "Cleaning  ${name}...\n"
	@docker compose -f ./srcs/docker-compose.yml down --volumes --rmi local
	@docker container prune --force
	@docker image prune --force
	@sudo rm -rf ~/data

fclean: down
	@printf "Clean of all docker configs\n"
	@docker compose -f ./srcs/docker-compose.yml down --volumes --rmi all --remove-orphans
	@sudo rm -rf ~/data
 
.PHONY : all build down clean fclean env_certs
