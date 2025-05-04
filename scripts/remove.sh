#!/bin/bash

: "${MANIFEST_DIR:?MANIFEST_DIR is not set}"

NUMBER="$1"

if [ -z "$NUMBER" ]; then
  echo "❌ Please run with: make remove 628xxxxxx"
  exit 1
fi

TARGET_FILE="$MANIFEST_DIR/wa$NUMBER.yaml"

if [ ! -f "$TARGET_FILE" ]; then
  echo "⚠️  Manifest not found: $TARGET_FILE"
  exit 0
fi

read -p "❓ Are you sure you want to delete $TARGET_FILE? (y/N): " confirm
if [[ "$confirm" =~ ^[Yy]$ ]]; then
  rm "$TARGET_FILE"
  echo "🗑️  Manifest deleted ${NUMBER}"
else
  exit 1
fi