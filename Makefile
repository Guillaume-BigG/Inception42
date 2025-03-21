LOGIN = gbeaudoi
COMPOSE = srcs/docker-compose.yml
VOLUMES_PATH = /home/$(LOGIN)/data
DOMAIN = 127.0.0.1 gbeaudoi.42.fr
LOOKDOMAIN = $(shell grep "${DOMAIN}" /etc/hosts)

export VOLUMES_PATH # Make it available for the Dockerfiles

# Default target
all: srcs/.env hosts build up

# Install/update dependencies
update-env:
	sudo apt-get update && sudo apt-get upgrade -y
	sudo apt-get install docker-compose-plugin

# List Docker containers, networks, or volumes
list:
	docker ps -a

list-networks:
	docker network ls

list-volumes:
	docker volume ls

# Start containers in detached mode
up:
	@echo "Starting the containers..."
	docker compose -f $(COMPOSE) up --build --detach
	@echo "Containers are running."

# Build the volumes if they don't exist
build:
	@echo "Building volumes..."
	$(MAKE) create-volumes

# Create required volumes
create-volumes:
	sudo mkdir -p $(VOLUMES_PATH)/mysql $(VOLUMES_PATH)/wordpress
	docker volume create --name mariadb_volume --opt type=none --opt device=$(VOLUMES_PATH)/mysql --opt o=bind
	docker volume create --name wordpress_volume --opt type=none --opt device=$(VOLUMES_PATH)/wordpress --opt o=bind

# Update /etc/hosts if necessary
hosts:
	@if ! grep -q "${DOMAIN}" /etc/hosts; then \
		echo "Updating /etc/hosts..."; \
		sudo cp ./srcs/requirements/tools/hosts /etc/hosts; \
	fi

# Ensure .env file exists
srcs/.env:
	@echo "Missing .env file in srcs folder" && exit 1

# Show logs for containers
logs:
	docker compose -f $(COMPOSE) logs -f

# Show status of containers
status:
	docker compose -f $(COMPOSE) ps

# Stop and remove containers, volumes, and images
down:
	docker compose -f $(COMPOSE) down -v --rmi all --remove-orphans

# Clean up unnecessary Docker resources
clean: down
	docker system prune --all --force --volumes

# Full cleanup (including volume and host backups)
fclean: clean
	sudo rm -rf $(VOLUMES_PATH)/wordpress $(VOLUMES_PATH)/mysql
	docker volume rm mariadb_volume wordpress_volume
	@sudo mv ./hosts_bkp /etc/hosts || echo "hosts_bkp does not exist"

# Rebuild everything
re: fclean all