#!/usr/bin/env bash

set -euo pipefail

source version.sh

container="senorsmile-anki"

opts=(
  -d

  -v /etc/localtime:/etc/localtime:ro
  -v /tmp/.X11-unix:/tmp/.X11-unix # mount the X11 socket
  #-e DISPLAY=unix$DISPLAY # pass the display
  -e "DISPLAY=${DISPLAY}"
  --device /dev/snd # sound

  --name anki
  --restart always
  "${container}:${version}"
)

docker stop anki || echo
docker rm anki || echo 
docker run ${opts[@]}
