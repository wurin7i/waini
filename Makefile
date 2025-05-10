STACK_NAME=waini
MANIFEST_DIR=wa-services
TEMPLATE_FILE=$(MANIFEST_DIR)/_template

prepare:
	scripts/prepare_system.sh

init:
	@${MAKE} generate $(word 2, $(MAKECMDGOALS))
	@if [ ! -f ./env/kong.env ]; then cp ./env/kong.env.example ./env/kong.env; fi
	@if [ ! -f ./env/wa.env ]; then cp ./env/wa.env.example ./env/wa.env; fi
	@${MAKE} up

tunnel:
	docker stack deploy --detach=true \
		-c network.yaml -c cloudflared.yaml \
		${STACK_NAME}
	@echo "✅ Tunnel started"

up:
	docker stack deploy --detach=true \
		-c network.yaml -c kong.yaml \
		$(shell find $(MANIFEST_DIR) -type f -name '*.yaml' -exec printf "-c {}" \;) \
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
	@$(MAKE) service start $(word 2, $(MAKECMDGOALS))

drop:
	@${MAKE} remove $(word 2, $(MAKECMDGOALS))
	@${MAKE} service remove $(word 2, $(MAKECMDGOALS))

clean:
	docker volume prune -f

%:
	@:
