#!/bin/sh
set -e

TARGET_DIR="/app/browser"
CONFIGURABLE_FILES_PATTERN="main*.js"

replace_vars () {
  ENV_VARS=\'$(awk 'BEGIN{for(v in ENVIRON) print "$"v}')\'
  for f in "$TARGET_DIR"/$CONFIGURABLE_FILES_PATTERN; do
    # trick to make envsubst change file inplace
    echo "$(envsubst "$ENV_VARS" < "$f")" > "$f"
  done
}

hash () {
  for f in "$TARGET_DIR"/$CONFIGURABLE_FILES_PATTERN; do
    FILENAME=$(basename "$f")
    HASH=$(sha1sum "$f" | awk '{ print $1 }')
    sed -i "s+$FILENAME\"+$FILENAME?h=$HASH\"+g" $TARGET_DIR/index.html
  done
}

compress () {
  for i in $(find "$TARGET_DIR" | grep -E "\.css$|\.html$|\.js$|\.svg$|\.txt$|\.ttf$"); do
    gzip -9kf "$i" && brotli -fZ "$i"
  done
}

echo "Running init script"

echo "Replacing env vars"
replace_vars

echo "Hashing files"
hash

echo "Compressing files"
compress

echo "Done"
