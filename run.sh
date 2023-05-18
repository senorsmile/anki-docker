#!/usr/bin/env bash

#set -euo pipefail

source variables.sh
container="senorsmile-anki"

ankidata="${HOME}/anki-docker-${anki_version}/"

mkdir -p ${ankidata}
# chown ankiuser ${ankidata}

opts=(
  # -d
	
  # -it

  -v "${HOME}/Downloads:/root/Downloads"
  # do NOT share with a host installed folder... create a new custom path
  -v "${ankidata}:/home/ankiuser/.local/share/Anki2" 
  -v /etc/localtime:/etc/localtime:ro
  -v /tmp/.X11-unix:/tmp/.X11-unix # mount the X11 socket
  -e "DISPLAY=${DISPLAY}" # pass display
  --device /dev/snd # sound
  --device /dev/dri # dri

  "${container}:${anki_version}-${build_num}"
)

docker run ${opts[@]}
