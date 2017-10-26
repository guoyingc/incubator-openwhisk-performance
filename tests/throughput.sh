#!/bin/sh
set -e
currentDir="$(cd "$(dirname "$0")"; pwd)"

# Host to use. Needs to include the protocol.
host=${1:-"https://10.0.0.50:443"}
# Credentials to use for the test. USER:PASS format.
credentials=${2:-"789c46b1-71f6-4ed5-8c54-816aa4f8c502:abczO3xZCLrMN6v2BKK1dXYFpXlPkccOFqm12CdAsMgRU4VrNZ9lyGVCGuMDGIwP"}
# concurrency level of the throughput test: How many requests should
# open in parallel.
concurrency=${3:-2}
# How many threads to utilize, directly correlates to the number
# of CPU cores
threads=${4:-1}
# How long to run the test
duration=${5:-10s}

action="noop"
#"$currentDir/create.sh" "$host" "$credentials" "$action"

# run throughput tests
encodedAuth=$(echo "$credentials" | base64 | tr -d '\n')
#sudo docker run --pid=host --userns=host --rm -v "$currentDir":/data williamyeh/wrk \
wrk --threads "$threads" \
  --connections "$concurrency" \
  --duration "$duration" \
  --header "Authorization: basic $encodedAuth" \
  --latency \
  --timeout 10s \
  --script post.lua \
  "$host/api/v1/namespaces/_/actions/$action?blocking=true"

#  "http://10.63.89.88:31623/api/789c46b1-71f6-4ed5-8c54-816aa4f8c502/v1/pcloud"
#   "$host/api/v1/namespaces/_/actions/$action?blocking=true" \
