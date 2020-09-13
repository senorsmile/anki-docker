#!/usr/bin/env bash

set -euo pipefail

source ./variables.sh


opts=(
  build 
  -t "senorsmile-anki:${anki_version}-${build_num}" 
  --build-arg ANKI_VERSION=${anki_version}
  .
)

time docker ${opts[@]}
