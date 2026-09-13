#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 || $# -gt 3 ]]; then
  echo "Usage: $0 <signing_secret> <raw_body_file> [timestamp]"
  echo "Example: $0 \"\$SLACK_SIGNING_SECRET\" /tmp/slack_event.json"
  exit 1
fi

SIGNING_SECRET="$1"
BODY_FILE="$2"
TIMESTAMP="${3:-$(date +%s)}"

if [[ ! -f "$BODY_FILE" ]]; then
  echo "Body file not found: $BODY_FILE"
  exit 1
fi

RAW_BODY="$(cat "$BODY_FILE")"
BASE_STRING="v0:${TIMESTAMP}:${RAW_BODY}"
SIGNATURE="v0=$(printf "%s" "$BASE_STRING" | openssl dgst -sha256 -hmac "$SIGNING_SECRET" | sed 's/^.* //')"

echo "X-Slack-Request-Timestamp: ${TIMESTAMP}"
echo "X-Slack-Signature: ${SIGNATURE}"
