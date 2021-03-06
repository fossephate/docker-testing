# This Dockerfile is used to build an headles vnc image based on Ubuntu

FROM phusion/baseimage:0.11
CMD ["/sbin/my_init"]


MAINTAINER Matthew Fosse "fossephate@gmail.com"
ENV REFRESHED_AT 2020-03-10-21:38
ENV VERSION 1.2.11

USER root
### Envrionment config
ENV DISPLAY=:1 \
    HOME=/headless \
    TERM=xterm \
    STARTUPDIR=/dockerstartup \
    SCREEN_RESOLUTION=1920x1080 \
    LANG='en_US.UTF-8' \
    LANGUAGE='en_US:en' \
    LC_ALL='en_US.UTF-8'

WORKDIR $HOME

RUN apt-get update && \
    apt-get -y dist-upgrade

RUN \
  apt-get install -y \
# X Server
  xvfb \
# Openbox
  openbox menu \
# git
  git

RUN apt-get install -y \
    chromium-browser chromium-browser-l10n chromium-codecs-ffmpeg \
    # alsa-utils \
    pulseaudio socat \
    pulseaudio-equalizer \
    libnss-wrapper \
    wget \
    ffmpeg \
    # dev
    nano

# dev
# RUN apt-get install -y \
#     npm \
#     libx11-dev \
#     libxtst-dev \
#     libpng++-dev \
#     ffmpeg \
#     # alsa:
#     libasound2-dev

RUN apt-get purge -y pm-utils xscreensaver* && \
    apt-get -y clean



# install the right version of nodejs
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
ENV NVM_DIR $HOME/.nvm
ENV NODE_VERSION v12.16.2
RUN /bin/bash -c "source $NVM_DIR/nvm.sh && nvm install $NODE_VERSION && nvm use --delete-prefix $NODE_VERSION"
ENV NODE_PATH $NVM_DIR/versions/node/$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/$NODE_VERSION/bin:$PATH

# inject files
ADD ./src/scripts $STARTUPDIR
ADD ./src/files/home $HOME
ADD ./src/files/etc /etc

RUN chmod +x /headless/host/misc/utils/ffmpeg
RUN npm rebuild $HOME/host/

# todo: delete /tmp files

RUN find $STARTUPDIR $HOME -name '*.sh' -exec chmod a+x {} + && \
    find $STARTUPDIR $HOME -name '*.desktop' -exec chmod a+x {} + && \
    chgrp -R 0 $STARTUPDIR $HOME && \
    chmod -R a+rw $STARTUPDIR $HOME && \
    find $STARTUPDIR $HOME -type d -exec chmod a+x {} + && \
    echo LANG=en_US.UTF-8 > /etc/default/locale && \
    locale-gen en_US.UTF-8

# CMD \
# # X Server
#   Xvfb :1 -screen 0 $SCREEN_RESOLUTIONx16 &
# Openbox
  # (export DISPLAY=:1 && openbox-session) &

# CMD \
# # X Server
#   Xvfb :1 -screen 0 1920x1080x16 &



USER 1000

ENTRYPOINT ["/dockerstartup/entrypoint.sh"]
CMD ["--wait"]
