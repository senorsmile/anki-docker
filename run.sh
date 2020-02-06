#!/usr/bin/env bash

set -euo pipefail

source version.sh
container="senorsmile-anki"

mkdir -p "${HOME}/anki-docker/"

opts=(
  -d

  -v "${HOME}/Downloads:/root/Downloads"
  # do NOT share with a host installed folder... create a new custom path
  -v "${HOME}/anki2-docker:/root/.local/share/Anki2" 
  -v /etc/localtime:/etc/localtime:ro
  -v /tmp/.X11-unix:/tmp/.X11-unix # mount the X11 socket
  #-e DISPLAY=unix$DISPLAY # pass the display
  -e "DISPLAY=${DISPLAY}"  # better way to pass display?
  --device /dev/snd # sound
  --device /dev/dri # necessary?

  --name anki
  --restart always
  "${container}:${version}"
)

docker stop anki || echo
docker rm anki || echo 
docker run ${opts[@]}
