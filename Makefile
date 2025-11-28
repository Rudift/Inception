DOMAIN_NAME = vdeliere.42.fr
HOSTS_LINE = 127.0.0.1 $(DOMAIN_NAME)
DATA_DIR = /home/vdeliere/data

WP_DATA = $(DATA_DIR)/wordpress
DB_DATA = $(DATA_DIR)/mariadb

# default target
all: setup up

# setup the environment
setup:
	@if ! grep -q "$(DOMAIN_NAME)" /etc/hosts; then \
		echo "$(HOSTS_LINE)" | sudo tee -a /etc/hosts > /dev/null; \
		echo "✅ Added $(DOMAIN_NAME) to /etc/hosts"; \
	else \
		echo "✅ $(DOMAIN_NAME) already in /etc/hosts"; \
	fi
	@mkdir -p $(DB_DATA) $(WP_DATA)
	@echo "✅ Data directories created"

# start the building process
up: setup
	docker compose -f srcs/docker-compose.yml up -d --build

# stop the containers
down:
	docker compose -f srcs/docker-compose.yml down

stop:
	docker compose -f srcs/docker-compose.yml stop

start:
	docker compose -f srcs/docker-compose.yml start

# clean the containers
clean: down
	docker system prune -af
	@if [ -d "$(DB_DATA)" ] && [ -n "$$(ls -A $(DB_DATA))" ]; then \
    	docker run --rm -v $(DB_DATA):/data alpine rm -rf /data/*; \
    fi
	@if [ -d "$(WP_DATA)" ] && [ -n "$$(ls -A $(WP_DATA))" ]; then \
    	docker run --rm -v $(WP_DATA):/data alpine rm -rf /data/*; \
    fi

fclean: clean
	docker volume rm -f mariadb wordpress 2>/dev/null || true
	docker network rm -f inception 2>/dev/null || true
	@if grep -q "$(DOMAIN_NAME)" /etc/hosts; then \
		sudo sed -i "/$(DOMAIN_NAME)/d" /etc/hosts; \
		echo "✅ Removed $(DOMAIN_NAME) from /etc/hosts"; \
	fi

# clean and start the containers
re: fclean all

logs:
	docker compose -f srcs/docker-compose.yml logs -f

.PHONY: all setup up down clean fclean re logs stop start