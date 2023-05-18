# https://hub.docker.com/_/ubuntu?tab=tags&page=1&ordering=last_updated
FROM ubuntu

#-------------------------
### prereqs

# in order to force apt update
ENV THROW_AWAY=0000

# avoid interactive prompting
ENV TZ=Europe/Berlin
ENV DEBIAN_FRONTEND=noninteractive

# update apt repos
RUN set -ex && apt-get update

# apt install prereqs
RUN set -ex && \
	apt-get install -y \
	wget \
	ca-certificates \
	build-essential \
	mpv \
	lame \
	xdg-utils \
	libnss3 \
	mplayer locales materia-gtk-theme papirus-icon-theme dmz-cursor-theme \
	anki \
	zstd


# set locale
RUN sed -i -e "s/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /etc/locale.gen && \
  dpkg-reconfigure --frontend=noninteractive locales && \
  update-locale
#-------------------------



#-------------------------
### anki

# read input args
ARG ANKI_VERSION

# set env vars for this docker build
ENV ANKI_VERSION ${ANKI_VERSION}

# download anki
RUN mkdir -p /build/src/
WORKDIR /build/src

#RUN wget https://apps.ankiweb.net/downloads/current/anki-$ANKI_VERSION-linux-amd64.tar.bz2
#RUN wget https://github.com/ankitects/anki/releases/download/$ANKI_VERSION/anki-$ANKI_VERSION-linux.tar.bz2 ## 2.1.19?
#RUN wget https://github.com/ankitects/anki/releases/download/$ANKI_VERSION/anki-$ANKI_VERSION-linux-amd64.tar.bz2
# RUN wget https://github.com/ankitects/anki/releases/download/$ANKI_VERSION/anki-$ANKI_VERSION-linux.tar.bz2 # as of 2021 Oct 23 removed -amd64
RUN wget https://github.com/ankitects/anki/releases/download/$ANKI_VERSION/anki-$ANKI_VERSION-linux-qt6.tar.zst

# install anki
#RUN tar xjf anki-$ANKI_VERSION-linux.tar.bz2 ## 2.1.19?
#RUN tar xjf anki-$ANKI_VERSION-linux-amd64.tar.bz2
# RUN tar xjf anki-$ANKI_VERSION-linux.tar.bz2
RUN unzstd anki-$ANKI_VERSION-linux-qt6.tar.zst
RUN tar xf anki-$ANKI_VERSION-linux-qt6.tar

#WORKDIR /build/src/anki-$ANKI_VERSION-linux-amd64
WORKDIR /build/src/anki-$ANKI_VERSION-linux-qt6

RUN mkdir -p /root/.config/

#RUN make install
RUN bash ./install.sh
#-------------------------



#-------------------------
### clean up

#- remove apt cache
RUN set -ex \
    && rm -rf /var/lib/apt/lists/*


### Change user
RUN useradd -ms /bin/bash ankiuser
USER ankiuser
WORKDIR /home/ankiuser

### Set runtime env variables
ENV DISABLE_QT5_COMPAT=1
ENV LANG=en_US.UTF-8

ENTRYPOINT [ "anki" ]
#-------------------------
