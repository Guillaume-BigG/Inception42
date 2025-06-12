NAME = inception

DOCKER_COMPOSE = docker-compose -f srcs/docker-compose.yml
VOLUMES_PATH = /home/gbeaudoi/data

all: hosts volumes up

hosts:
	@echo "Adding domain to /etc/hosts..."
	@sudo sh -c "cat srcs/requirements/tools/host >> /etc/hosts || true"

volumes:
	@mkdir -p $(VOLUMES_PATH)/wordpress
	@mkdir -p $(VOLUMES_PATH)/mariadb
	@chmod 755 $(VOLUMES_PATH)/wordpress
	@chmod 755 $(VOLUMES_PATH)/mariadb

up:
	@$(DOCKER_COMPOSE) up --build

down:
	@$(DOCKER_COMPOSE) down

logs:
	@$(DOCKER_COMPOSE) logs -f

clean: down
	@$(DOCKER_COMPOSE) down --volumes
	@docker system prune -af

fclean: clean
	@sudo rm -rf $(VOLUMES_PATH)/wordpress
	@sudo rm -rf $(VOLUMES_PATH)/mariadb
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true

clean-hosts:
	@echo "Removing domain from /etc/hosts..."
	@sudo sed -i '/gbeaudoi.42.fr/d' /etc/hosts

re: fclean all

.PHONY: all hosts volumes up down logs clean fclean re