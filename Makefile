# Docker commands for Rails app with MySQL

.PHONY: help build up down logs shell db-shell test clean

help: ## Show this help message
	@echo 'Available commands:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# Docker commands
build: ## Build the Docker images
	docker compose build

up: ## Start the application
	docker compose up -d

down: ## Stop the application
	docker compose down

logs: ## Show logs from all containers
	docker compose logs -f

# Utility commands
shell: ## Open a shell in the web container
	docker compose exec web bash

db-shell: ## Open a MySQL shell
	docker compose exec db mysql -u rails -ppassword myapp_development

# Database commands
db-create: ## Create databases
	docker compose exec web ./bin/rails db:create

db-migrate: ## Run database migrations
	docker compose exec web ./bin/rails db:migrate

db-seed: ## Seed the database
	docker compose exec web ./bin/rails db:seed

db-setup: ## Setup database (create, migrate, seed)
	docker compose exec web ./bin/rails db:setup

# Testing
test: ## Run tests
	docker compose exec web ./bin/rails test

# Cleanup
clean: ## Clean up Docker resources
	docker compose down -v
	docker system prune -f