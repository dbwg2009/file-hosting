#!/bin/bash

WATCH_DIR="/data/compose/14/data/nginx/proxy_host"
WEBHOOK_URL="https://n8n.dbwg2009.uk/webhook/aec74424-6179-4ee2-8f39-1daaa3fb4835"

inotifywait -m -e create "$WATCH_DIR" --format '%f' | while read NEW_FILE
do
  echo "New proxy config detected: $NEW_FILE"

  # Extract domain from config file
  DOMAIN=$(grep -m1 'server_name' "$WATCH_DIR/$NEW_FILE" | awk '{print $2}' | sed 's/;//')

  # Send webhook
  curl -X POST "$WEBHOOK_URL" \
    -H "Content-Type: application/json" \
    -d "{\"event\":\"proxy_created\",\"domain\":\"$DOMAIN\",\"file\":\"$NEW_FILE\"}"

  echo "Webhook sent for $DOMAIN"
done
