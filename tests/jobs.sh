#!/usr/bin/env bash
# tests/jobs.sh — basic job manager test

set -e

source lib/jobs.sh

jobs::init

sleep 1 &
pid=$!
jobs::add "$pid" "TEST" "/tmp/a" "/tmp/b"
jobs::list
wait "$pid"
