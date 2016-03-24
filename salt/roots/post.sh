#!/usr/bin/env sh
MARATHON=http://master-1:8080

for file in *.json
do
  echo "Installing $file..."
  curl -X POST "$MARATHON/v2/apps" -d @"$file" -H "Content-type: application/json"
  echo ""
done

