#!/bin/bash

: "${MANIFEST_DIR:?MANIFEST_DIR is not set}"
: "${TEMPLATE_FILE:?TEMPLATE_FILE is not set}"

SCRIPT_NAME=$(basename "$0")
NUMBER="$1"

if [ -z "$NUMBER" ]; then
  echo "❌ Please run with: make generate 628xxxxxx"
  exit 1
fi

TARGET_FILE="$MANIFEST_DIR/wa$NUMBER.yaml"

if [ -f "$TARGET_FILE" ]; then
  echo "⚠️  File already exists: $TARGET_FILE"
  read -p "❓ Overwrite? (y/N): " confirm
  if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    exit 0
  fi
fi

echo "Generating manifest for account number $NUMBER..."
sed "s/{{account_number}}/$NUMBER/g" "$TEMPLATE_FILE" > "$TARGET_FILE"

echo "✅ Manifest generated for $NUMBER"
