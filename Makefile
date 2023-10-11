# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: tbeaudoi <tbeaudoi@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/09/19 10:27:26 by tbeaudoi          #+#    #+#              #
#    Updated: 2023/10/05 22:02:53 by tbeaudoi         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

PATH_NGINX = ./srcs/requirements/nginx
PATH_WORDPRESS = ./srcs/requirements/wordpress
PATH_MARIADB = ./srcs/requirements/mariadb


all:
	# cp ./srcs/requirements/wordpress/index.html ./srcs/requirements/wordpress/volume
	docker compose -f srcs/docker-compose.yml up

down: 
	docker compose -f srcs/docker-compose.yml down

clean:
	docker compose -f srcs/docker-compose.yml down --rmi all
	docker compose -f srcs/docker-compose.yml down --volumes --remove-orphans
	docker compose -f srcs/docker-compose.yml rm -sfv
	
clean-vol: clean
	sudo rm -rf /home/tbeaudoi42/data/volume_wordpress/*
	sudo rm -rf /home/tbeaudoi42/data/volume_mariadb/*
