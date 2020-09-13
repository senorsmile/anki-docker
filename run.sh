#!/usr/bin/env bash

#set -euo pipefail

source variables.sh
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
  "${container}:${anki_version}-${build_num}"
)

# https://unix.stackexchange.com/questions/209746/how-to-resolve-no-protocol-specified-for-su-user
#xauth + local:
xhost + local:

docker stop anki || echo
docker rm anki || echo 
docker run ${opts[@]}
