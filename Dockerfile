FROM ubuntu:bionic-20200112

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV ANKI_VERSION=2.1.19

RUN set -ex && apt-get update

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

RUN sed -i -e "s/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /etc/locale.gen && \
  dpkg-reconfigure --frontend=noninteractive locales && \
  update-locale


RUN mkdir -p /build/src/
WORKDIR /build/src

RUN wget https://apps.ankiweb.net/downloads/current/anki-$ANKI_VERSION-linux-amd64.tar.bz2


RUN tar xjf anki-$ANKI_VERSION-linux-amd64.tar.bz2

WORKDIR /build/src/anki-$ANKI_VERSION-linux-amd64

RUN make install



#RUN set -ex && apt-get install -y \
        # libxkbcommon-x11-0

#- remove apt cache
RUN set -ex \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "anki", "--no-sandbox" ]
