#!/bin/sh
set -e

FLAG_FILE="/configured"
TARGET_DIR="/app/browser"
SERVER_FILE="/app/server/main.js"
CONFIGURABLE_FILES_PATTERN="main*.js"

replace_vars () {
  ENV_VARS=\'$(awk 'BEGIN{for(v in ENVIRON) print "$"v}')\'
  for f in "$TARGET_DIR"/$CONFIGURABLE_FILES_PATTERN; do
    # trick to make envsubst change file inplace
    echo "$(envsubst "$ENV_VARS" < "$f")" > "$f"
  done
  echo "$(envsubst "$ENV_VARS" < "$SERVER_FILE")" > "$SERVER_FILE"
}

if [ "$1" = 'node' ]; then
  if [ ! -e "$FLAG_FILE" ]; then
    echo "Running init script"

    echo "Replacing env vars"
    replace_vars

    touch $FLAG_FILE
    echo "Done"
  fi
fi

exec "$@"
