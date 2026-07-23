#!/usr/bin/env bash
set -e
URL='https://siddarth1513.github.io/Agridirect/'
if curl -fsSL $URL > /dev/null; then
  echo "Deployment reachable: $URL"
else
  echo "ERROR: Deployment not reachable" >&2
  exit 1
fi
