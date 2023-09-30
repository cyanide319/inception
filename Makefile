# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: tristan <tristan@student.42.fr>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/09/19 10:27:26 by tbeaudoi          #+#    #+#              #
#    Updated: 2023/09/29 20:06:34 by tristan          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

PATH_NGINX = ./srcs/requirements/nginx
PATH_WORDPRESS = ./srcs/requirements/wordpress
PATH_MARIADB = ./srcs/requirements/mariadb


all:
	docker-compose -f srcs/docker-compose.yml up

down: 
	docker-compose -f srcs/docker-compose.yml down

clean:
	docker-compose -f srcs/docker-compose.yml down --rmi all
	docker-compose -f srcs/docker-compose.yml down --volumes --remove-orphans
	docker-compose -f srcs/docker-compose.yml rm -sfv
	
clean-vol:
	sudo chown -R tristan ./srcs/requirements/mariadb/volume
	rm -rf ./srcs/requirements/mariadb/volume/*
