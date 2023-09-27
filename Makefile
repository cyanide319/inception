# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: tbeaudoi <tbeaudoi@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/09/19 10:27:26 by tbeaudoi          #+#    #+#              #
#    Updated: 2023/09/27 16:28:12 by tbeaudoi         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

PATH_NGINX = ./srcs/requirements/nginx
PATH_WORDPRESS = ./srcs/requirements/wordpress
PATH_MARIADB = ./srcs/requirements/mariadb


all:
	# docker build -t nginx_inception $(PATH_NGINX)
	# docker build -t wordpress $(PATH_WORDPRESS)
	# docker build -t mariadb_inception $(PATH_MARIADB)
	cd srcs && docker-compose up 

