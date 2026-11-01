#!/usr/bin/env bash
set -euo pipefail

IMAGE="${FDB_IMAGE:-foundationdb/foundationdb@sha256:3d47a2e9ee389199f1d320c985bc95a3d4eb701d9b2b5c2add8a2285588fd4fe}"
CONTAINER="${FDB_CONTAINER:-nis-fdb-checkpoint1-$$}"
created=0

cleanup() {
  if [[ "$created" -eq 1 ]]; then
    docker rm -f "$CONTAINER" >/dev/null 2>&1 || true
  fi
}

trap cleanup EXIT

if docker inspect "$CONTAINER" >/dev/null 2>&1; then
  echo "Container already exists: $CONTAINER" >&2
  exit 2
fi

docker run --detach --name "$CONTAINER" \
  --entrypoint /var/fdb/scripts/fdb_single.bash \
  "$IMAGE" >/dev/null
created=1

ready=0
for _ in $(seq 1 30); do
  status="$(docker exec "$CONTAINER" fdbcli --exec 'status minimal' 2>/dev/null || true)"
  if [[ "$status" == *"The database is available."* ]]; then
    ready=1
    break
  fi
  sleep 1
done

if [[ "$ready" -ne 1 ]]; then
  docker logs "$CONTAINER"
  exit 1
fi

docker exec "$CONTAINER" fdbcli --exec 'status minimal'
transaction_output="$(docker exec "$CONTAINER" fdbcli --exec \
  'writemode on; begin; set nis/checkpoint1/probe ok; get nis/checkpoint1/probe; commit')"
post_commit_output="$(docker exec "$CONTAINER" fdbcli --exec 'get nis/checkpoint1/probe')"
printf '%s\n%s\n' "$transaction_output" "$post_commit_output"

if [[ "$transaction_output" != *"Committed ("* ]] || \
   [[ "$transaction_output" != *"is \`ok'"* ]] || \
   [[ "$post_commit_output" != *"is \`ok'"* ]]; then
  echo "Transaction verification failed" >&2
  exit 1
fi

docker image inspect "$IMAGE" --format 'image={{index .RepoDigests 0}}'
