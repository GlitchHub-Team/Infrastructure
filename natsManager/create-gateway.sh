#!/bin/sh
set -eu

usage() {
	echo "Usage: $0 --tenant-name <tenant-name> --tenant-id <tenant-id> --gateway-name <gateway-name> --gateway-id <gateway-id> --gateway-public-key <gateway-public-key>" >&2
	exit 1
}

TENANT_NAME=""
TENANT_ID=""
GATEWAY_NAME=""
GATEWAY_ID=""
GATEWAY_PUBLIC_KEY=""

while [ "$#" -gt 0 ]; do
	case "$1" in
		--tenant-name)
			[ "$#" -ge 2 ] || usage
			TENANT_NAME="$2"
			shift 2
			;;
		--tenant-id)
			[ "$#" -ge 2 ] || usage
			TENANT_ID="$2"
			shift 2
			;;
		--gateway-name)
			[ "$#" -ge 2 ] || usage
			GATEWAY_NAME="$2"
			shift 2
			;;
		--gateway-id)
			[ "$#" -ge 2 ] || usage
			GATEWAY_ID="$2"
			shift 2
			;;
		--gateway-public-key)
			[ "$#" -ge 2 ] || usage
			GATEWAY_PUBLIC_KEY="$2"
			shift 2
			;;
		-h|--help)
			usage
			;;
		*)
			echo "Unknown parameter: $1" >&2
			usage
			;;
	esac
done

[ -n "$TENANT_NAME" ] || usage
[ -n "$TENANT_ID" ] || usage
[ -n "$GATEWAY_NAME" ] || usage
[ -n "$GATEWAY_ID" ] || usage
[ -n "$GATEWAY_PUBLIC_KEY" ] || usage

nsc add user -a "$TENANT_NAME" -n "$GATEWAY_NAME" \
	--allow-pub "sensor.${TENANT_ID}.${GATEWAY_ID}.>,gateway.hello.${GATEWAY_ID}" \
	--allow-sub '$JS.API.>,_INBOX.>' \
	--public-key "$GATEWAY_PUBLIC_KEY"

nsc describe user -a "$TENANT_NAME" -n "$GATEWAY_NAME" -R
