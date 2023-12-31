#!/bin/bash

export CPU_CORES=1

docker compose up -d
sleep 5
curl http://localhost:8888 -i
make bench-upstream d=10s
docker compose down


cases=("single-static" "static" "openai" "okta" "github")

for case in "${cases[@]}"; do
    echo "########## benchmarking $case suite ##########"
    export BENCHMARK_DATA="$case"
    make start
    sleep 10
    # warm up
    make bench-$case d=1s
    sleep 10
    make bench-$case
    sleep 10
    make bench-$case
    make stop
done
