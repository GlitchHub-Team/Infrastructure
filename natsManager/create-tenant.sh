#!/bin/sh
set -eu

APPLICATION_CORE_ACCOUNT_ID="AAF42CN65REM6SAJYPK6JEJDYG37VLLLVS4VBHB4DSLOSXMIDVCN7FEX"

usage() {
	echo "Usage: $0 --tenant-name <tenant-name> --tenant-id <tenant-id>" >&2
	exit 1
}

TENANT_NAME=""
TENANT_ID=""

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

nsc add account "$TENANT_NAME"

nsc add import \
	--account "$TENANT_NAME" \
	--src-account "$APPLICATION_CORE_ACCOUNT_ID" \
	--remote-subject "sensor.${TENANT_ID}.>" \
	--name "sensor_service_import" \
	--service

nsc add import \
	--account "$TENANT_NAME" \
	--src-account "$APPLICATION_CORE_ACCOUNT_ID" \
	--remote-subject "gateway.hello.>" \
	--name "hello_service_import" \
	--service

nsc env -a "$TENANT_NAME"

nsc push -u nats://nats:4222 --ca-cert ca.pem

echo "Tenant ${TENANT_NAME} created and pushed successfully"
