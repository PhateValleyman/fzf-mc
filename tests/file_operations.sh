#!/usr/bin/env bash
# Basic smoke test for file operations

set -e

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

mkdir "$TMP_DIR/source"
echo test > "$TMP_DIR/source/file.txt"

cp -a "$TMP_DIR/source/file.txt" "$TMP_DIR/copy.txt"
test -f "$TMP_DIR/copy.txt"

mv "$TMP_DIR/copy.txt" "$TMP_DIR/moved.txt"
test -f "$TMP_DIR/moved.txt"

rm "$TMP_DIR/moved.txt"
test ! -e "$TMP_DIR/moved.txt"

echo "file operations OK"
