# https://hub.docker.com/_/ubuntu?tab=tags&page=1&ordering=last_updated
FROM ubuntu:bionic-20201119
#FROM ubuntu:bionic-20200807

#-------------------------
### prereqs

# in order to force apt update
ENV APT_UPDATED=20211023-1611
#ENV THROW_AWAY=20211023-1611

# update apt repos
RUN set -ex && apt-get update

# apt install prereqs
#RUN set -ex && apt-get install -y --no-install-recommends \
RUN set -ex && apt-get install -y \
        wget \
        ca-certificates \
        build-essential \
        mpv \
        lame \
        xdg-utils \
        libnss3 \
        python3-pyqt4 python-qt4 mplayer locales materia-gtk-theme papirus-icon-theme dmz-cursor-theme

        # pyqt5-dev-tools \


#RUN set -ex && apt-get install -y \
        # libxkbcommon-x11-0

# install nicetohaves
RUN set -ex && apt-get install -y \
                vim


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
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV ANKI_VERSION ${ANKI_VERSION}

# download anki
RUN mkdir -p /build/src/
WORKDIR /build/src

#RUN wget https://apps.ankiweb.net/downloads/current/anki-$ANKI_VERSION-linux-amd64.tar.bz2
#RUN wget https://github.com/ankitects/anki/releases/download/$ANKI_VERSION/anki-$ANKI_VERSION-linux.tar.bz2 ## 2.1.19?
#RUN wget https://github.com/ankitects/anki/releases/download/$ANKI_VERSION/anki-$ANKI_VERSION-linux-amd64.tar.bz2
RUN wget https://github.com/ankitects/anki/releases/download/$ANKI_VERSION/anki-$ANKI_VERSION-linux.tar.bz2 # as of 2021 Oct 23 removed -amd64

# install anki
#RUN tar xjf anki-$ANKI_VERSION-linux.tar.bz2 ## 2.1.19?
#RUN tar xjf anki-$ANKI_VERSION-linux-amd64.tar.bz2
RUN tar xjf anki-$ANKI_VERSION-linux.tar.bz2

#WORKDIR /build/src/anki-$ANKI_VERSION-linux-amd64
WORKDIR /build/src/anki-$ANKI_VERSION-linux

RUN mkdir -p /root/.config/

#RUN make install
RUN bash ./install.sh

# install japanese language support
RUN apt-get install -y fonts-takao-mincho fonts-takao
#-------------------------



#-------------------------
### clean up

#- remove apt cache
RUN set -ex \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "anki", "--no-sandbox" ]
#-------------------------
