# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jsaintho <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/04/07 10:53:53 by jsaintho          #+#    #+#              #
#    Updated: 2025/04/17 14:04:32 by jsaintho         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

all : up

up : 
	@docker-compose -f ./srcs/docker-compose.yml up -d

# Start the containers in the correct order
work:
	@echo "Starting MariaDB container..."
	@docker-compose up -d mariadb
	@echo "Waiting for MariaDB to be ready..."
	@sleep 10 # wait for MariaDB to initialize
	@echo "Starting WordPress container..."
	@docker-compose up -d wordpress
	@echo "Waiting for WordPress to be ready..."
	@sleep 10 # wait for WordPress to initialize
	@echo "Starting Nginx container..."
	@docker-compose up -d nginx

down : 
	@docker-compose -f ./srcs/docker-compose.yml down

stop : 
	@docker-compose -f ./srcs/docker-compose.yml stop

start : 
	@docker-compose -f ./srcs/docker-compose.yml start

status : 
	@docker ps
