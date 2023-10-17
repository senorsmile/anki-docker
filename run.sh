#!/usr/bin/env bash

#set -euo pipefail

source variables.sh
container="senorsmile-anki"

ankihome="${HOME}/anki-docker-${anki_version}/"
ankidata="${ankihome}/.local/share/Anki2/"

mkdir -p ${ankidata}
# chown ankiuser ${ankidata}

opts=(
  # -d
	
  # -it

  -v "${HOME}/Downloads:/root/Downloads"
  # do NOT share with a host installed folder... create a new custom path
  -v "${ankihome}:/home/ankiuser/" 
  -v /etc/localtime:/etc/localtime:ro
  -v /tmp/.X11-unix:/tmp/.X11-unix # mount the X11 socket
  -e "DISPLAY=${DISPLAY}" # pass display
  --device /dev/snd # sound
  --device /dev/dri # dri
  --network host

  "${container}:${anki_version}-${build_num}"
)

docker run ${opts[@]}
