#!/bin/bash

: "${STACK_NAME:?STACK_NAME is not set}"

# ANSI color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

services=$(docker service ls --format '{{.ID}} {{.Name}} {{.Replicas}}' | grep -E '^.* '${STACK_NAME}'_wa[0-9]+' || true)

if [[ -z "$services" ]]; then
    echo "No services found with prefix '${STACK_NAME}_wa'"
    exit 0
fi

# Header
printf "\n%-15b %-15s %-10s %-10s\n" "NUMBER" " ID" " STATUS" " AGE"

now=$(date -u +%s)

while read -r line; do
    id=$(echo "$line" | awk '{print $1}')
    name=$(echo "$line" | awk '{print $2}')
    replicas=$(echo "$line" | awk '{print $3}')

    number=$(echo "$name" | sed -E 's/^'${STACK_NAME}'_wa//')

    # Check status (if active replicas > 0 then Running)
    running_count=$(echo "$replicas" | cut -d'/' -f1)
    status="Stopped"
    if [[ "$running_count" -gt 0 ]]; then
        status="Running"
        number="${GREEN}${number}${NC}\t"
    else
        number="${RED}${number}${NC}\t"
    fi

    # Retrieve the service creation time
    created=$(docker service inspect "$id" --format '{{.CreatedAt}}')

    # Clean up the time format: remove nanoseconds and ' UTC'
    clean_created=$(echo "$created" | sed -E 's/\.[0-9]+ +\+([0-9]+) UTC$/ +\1/')
    created_ts=$(date -u -d "$clean_created" +"%s" 2>/dev/null)

    if [[ -z "$created_ts" ]]; then
        age="?"
    else
        age_sec=$((now - created_ts))

        if [[ "$age_sec" -lt 60 ]]; then
            age="${age_sec}s"
        elif [[ "$age_sec" -lt 3600 ]]; then
            age="$((age_sec / 60))m"
        elif [[ "$age_sec" -lt 86400 ]]; then
            age="$((age_sec / 3600))h"
        else
            age="$((age_sec / 86400))d"
        fi
    fi

    printf "%-15b %-15s %-10s %-10s\n" "$number" "$id" "$status" "$age"
done <<<"$services"

echo -e "\nRegistered services: $(echo "$services" | wc -l)\n"
