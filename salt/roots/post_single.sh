#!/bin/bash
MARATHON=http://master-3:8080

  echo "Installing $file..."
  curl -X POST "$MARATHON/v2/apps" -d @"$1" -H "Content-type: application/json"
  echo ""

