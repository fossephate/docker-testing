# This Dockerfile is used to build an headles vnc image based on Ubuntu

FROM phusion/baseimage:0.11

CMD ["/sbin/my_init"]

MAINTAINER Matthew Fosse "fossephate@gmail.com"
ENV REFRESHED_AT 2020-03-10-21:38
ENV VERSION 1.2.11

LABEL io.k8s.description="Headless VNC Container with Xfce window manager" \
    io.k8s.display-name="Headless VNC Container based on Ubuntu" \
    io.openshift.expose-services="6901:http,5901:xvnc" \
    io.openshift.tags="vnc, ubuntu, xfce" \
    io.openshift.non-scalable=true

## Connection ports for controlling the UI:
# VNC port:5901
# noVNC webport, connect via http://IP:6901/?password=vncpassword
ENV DISPLAY=:1 \
    VNC_PORT=5901 \
    NO_VNC_PORT=6901
EXPOSE $VNC_PORT $NO_VNC_PORT

USER root
### Envrionment config
ENV HOME=/headless \
    TERM=xterm \
    STARTUPDIR=/dockerstartup \
    INST_SCRIPTS=/headless/install \
    NO_VNC_HOME=/headless/noVNC \
    DEBIAN_FRONTEND=noninteractive \
    VNC_COL_DEPTH=24 \
    VNC_RESOLUTION=1920x1080 \
    VNC_PW=password \
    VNC_VIEW_ONLY=false \
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
# VNC Server
  x11vnc \
# Openbox
  openbox menu \
# NoVNC with dependencies
  git \
  net-tools

RUN apt-get install -y \
    chromium-browser chromium-browser-l10n chromium-codecs-ffmpeg \
    libnss-wrapper \
    wget \
    nodejs

# dev
RUN apt-get install -y \
    npm \
    libx11-dev \
    libxtst-dev \
    libpng++-dev \
    ffmpeg

RUN apt-get purge -y pm-utils xscreensaver* && \
    apt-get -y clean


### Install xvnc-server & noVNC - HTML5 based VNC viewer
RUN mkdir -p $NO_VNC_HOME/utils/websockify && \
    wget -qO- https://dl.bintray.com/tigervnc/stable/tigervnc-1.9.0.x86_64.tar.gz | tar xz --strip 1 -C / && \
    wget -qO- https://github.com/novnc/noVNC/archive/v1.1.0.tar.gz | tar xz --strip 1 -C $NO_VNC_HOME && \
    wget -qO- https://github.com/novnc/websockify/archive/v0.9.0.tar.gz | tar xz --strip 1 -C $NO_VNC_HOME/utils/websockify && \
    chmod +x -v $NO_VNC_HOME/utils/*.sh && \
    cp -f /headless/noVNC/vnc.html /headless/noVNC/index.html

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
ENV NVM_DIR $HOME/.nvm
ENV NODE_VERSION v12.16.2
RUN /bin/bash -c "source $NVM_DIR/nvm.sh && nvm install $NODE_VERSION && nvm use --delete-prefix $NODE_VERSION"
ENV NODE_PATH $NVM_DIR/versions/node/$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/$NODE_VERSION/bin:$PATH

# RUN export NVM_DIR="$HOME/.nvm" \
#   [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" \
#   [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
# RUN nvm install 12.16.1

# inject files
ADD ./src/scripts $STARTUPDIR
ADD ./src/files/home $HOME
ADD ./src/files/etc /etc

RUN chmod +x /headless/host/misc/utils/ffmpeg

# todo: delete /tmp files

RUN find $STARTUPDIR $HOME -name '*.sh' -exec chmod a+x {} + && \
    find $STARTUPDIR $HOME -name '*.desktop' -exec chmod a+x {} + && \
    chgrp -R 0 $STARTUPDIR $HOME && \
    chmod -R a+rw $STARTUPDIR $HOME && \
    find $STARTUPDIR $HOME -type d -exec chmod a+x {} + && \
    echo LANG=en_US.UTF-8 > /etc/default/locale && \
    locale-gen en_US.UTF-8

CMD \
# X Server
  Xvfb :1 -screen 0 $VNC_RESOLUTIONx16 &
# Openbox
  # (export DISPLAY=:1 && openbox-session) &




USER 1000

ENTRYPOINT ["/dockerstartup/entrypoint.sh"]
CMD ["--wait"]