STACK_NAME=waini
MANIFEST_DIR=wa-service
TEMPLATE_FILE=$(MANIFEST_DIR)/_template

up:
	docker stack deploy --detach=true \
		-c docker-compose.yaml $(shell find $(MANIFEST_DIR) -name '*.yaml' -exec printf " -c {}" \;) \
		${STACK_NAME}
	@echo "✅ Stack started"

destroy:
	docker stack rm waini
	docker network prune -f
	@echo "❌ Stack destroyed"

list:
	STACK_NAME=$(STACK_NAME) ./scripts/list_services.sh

service:
	STACK_NAME=$(STACK_NAME) MANIFEST_DIR=$(MANIFEST_DIR) scripts/manage_service.sh $(word 2,$(MAKECMDGOALS)) $(word 3,$(MAKECMDGOALS))

generate:
	TEMPLATE_FILE=$(TEMPLATE_FILE) MANIFEST_DIR=$(MANIFEST_DIR) scripts/generate.sh $(word 2, $(MAKECMDGOALS))

remove:
	TEMPLATE_FILE=$(TEMPLATE_FILE) MANIFEST_DIR=$(MANIFEST_DIR) scripts/remove.sh $(word 2, $(MAKECMDGOALS))

deploy:
	@${MAKE} generate $(word 2, $(MAKECMDGOALS))
	@echo "Starting stack with additional services..."
	@$(MAKE) up

drop:
	@${MAKE} remove $(word 2, $(MAKECMDGOALS))
	@${MAKE} service remove $(word 2, $(MAKECMDGOALS))

clean:
	docker volume prune -f

%:
	@:
