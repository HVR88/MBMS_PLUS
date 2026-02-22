#!/usr/bin/env bash

set -euo pipefail

# Shared docker compose wrapper for deploy admin scripts.

dc_cmd=(docker compose)
if [ -n "${DOCKER_COMPOSE_CMD:-}" ]; then
  # Allow users to override compose command (e.g., "docker-compose").
  IFS=' ' read -r -a dc_cmd <<<"$DOCKER_COMPOSE_CMD"
fi

dc() {
  "${dc_cmd[@]}" "$@"
}
