#!/usr/bin/env bash

set -euo pipefail

source version.sh

docker build -t "senorsmile-anki:${version}" .
