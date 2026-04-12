#!/bin/sh
set -eu

NATS_URL="${NATS_URL:-nats://nats:4222}"
STREAM_NAME="SENSOR_DATA_STREAM"
SUBJECT="sensor.*.*.*"
HELLO_STREAM_NAME="HELLO_STREAM"
HELLO_SUBJECT="gateway.hello.*"
CREDS_PATH="/stream_setupper.creds"
CA_PATH="/ca.pem"

nats_cli() {
  nats --server "$NATS_URL" --creds "$CREDS_PATH" --tlsca "$CA_PATH" "$@"
}

ensure_stream() {
  name="$1"
  subject="$2"
  retention="$3"

  if nats_cli stream info "$name" >/dev/null 2>&1; then
    echo "Stream $name already exists, updating..."
    if nats_cli stream update "$name" --subjects "$subject" --retention "$retention" >/dev/null 2>&1; then
      echo "Stream $name updated"
    else
      echo "Failed to update stream $name" >&2
      exit 1
    fi
  else
    if nats_cli stream add "$name" \
      --subjects "$subject" \
      --retention "$retention" \
      --storage file \
      --defaults >/dev/null 2>&1; then
      echo "Stream $name created"
    else
      echo "Failed to create stream $name" >&2
      exit 1
    fi
  fi
}

echo "Waiting for NATS to be ready..."
for _ in $(seq 1 30); do
  if nats_cli stream ls >/dev/null 2>&1; then
    break
  fi
  sleep 1
done

nsc env --data-dir /nsc/stores --keystore-dir /nsc/keys

if ! nats_cli stream ls >/dev/null 2>&1; then
  echo "NATS is not ready after waiting" >&2
  exit 1
fi

ensure_stream "$STREAM_NAME" "$SUBJECT" "work"
ensure_stream "$HELLO_STREAM_NAME" "$HELLO_SUBJECT" "work"

echo "Setup completed!"