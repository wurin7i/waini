#!/bin/bash

: "${STACK_NAME:?STACK_NAME is not set}"
: "${MANIFEST_DIR:?MANIFEST_DIR is not set}"

ACTION="$1"
NUMBER="$2"
SERVICE_NAME="${STACK_NAME}_wa${NUMBER}"
TARGET_FILE="${MANIFEST_DIR}/wa${NUMBER}.yaml"

usage() {
  echo "Usage: make manage [start|stop|remove] <WA number>"
  echo "Example: make manage start 628xxxxxx"
  exit 1
}

service_exists() {
  docker service ls --format '{{.Name}}' | grep -q "^${SERVICE_NAME}$"
}

if [[ -z "$ACTION" || -z "$NUMBER" ]]; then
  usage
fi

if [ ! -f "$TARGET_FILE" ]; then
    echo "⚠️ Manifest not found for service $NUMBER"
    exit 1
fi

if ! service_exists && [[ "$ACTION" != "start" ]]; then
  echo "❌ Service for ${NUMBER} not found in stack. Ensure the service is deployed."
  exit 1
fi

case "$ACTION" in
  start)
    if service_exists; then
      echo "🔄 Starting service for $NUMBER..."
      docker service scale "$SERVICE_NAME"=1
    else
      echo "🚀 Deploying service for $NUMBER..."
      docker stack deploy --detach=false -c "$TARGET_FILE" -c "network.yaml" "$STACK_NAME"
    fi
    ;;

  stop)
    echo "🛑 Stoping service for $NUMBER..."
    docker service scale "$SERVICE_NAME"=0
    ;;

  remove)
    echo "❌ Removing service $SERVICE_NAME..."
    docker service rm "$SERVICE_NAME"
    ;;

  *)
    echo "❌ Invalid action: $ACTION"
    usage
    ;;
esac
