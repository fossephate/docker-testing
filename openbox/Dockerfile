# This Dockerfile is used to build an headles vnc image based on Ubuntu

FROM phusion/baseimage:0.11

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
    VNC_RESOLUTION=1280x1024 \
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
    libpng++-dev

# RUN apt-get install -y \
#     openssh-client \
#     openssl \
#     dnsutils \
#     curl \
#     screen \
#     wget \
#     rsync \
#     whois \
#     netcat \
#     nmap \
#     vim \
#     wget \
#     net-tools \
#     locales \
#     bzip2 \
#     python-numpy \
#     supervisor \
#     nodejs \
#     npm \
#     git

RUN apt-get purge -y pm-utils xscreensaver* && \
    apt-get -y clean


### Install xvnc-server & noVNC - HTML5 based VNC viewer
RUN mkdir -p $NO_VNC_HOME/utils/websockify && \
    wget -qO- https://dl.bintray.com/tigervnc/stable/tigervnc-1.9.0.x86_64.tar.gz | tar xz --strip 1 -C / && \
    wget -qO- https://github.com/novnc/noVNC/archive/v1.1.0.tar.gz | tar xz --strip 1 -C $NO_VNC_HOME && \
    wget -qO- https://github.com/novnc/websockify/archive/v0.9.0.tar.gz | tar xz --strip 1 -C $NO_VNC_HOME/utils/websockify && \
    chmod +x -v $NO_VNC_HOME/utils/*.sh && \
    cp -f /headless/noVNC/vnc.html /headless/noVNC/index.html

# inject files
ADD ./src/scripts $STARTUPDIR
ADD ./src/files/ $HOME

# install materia and paper icons
# RUN apt-get install -y gnome-themes-standard gtk2-engines-murrine libglib2.0-dev libxml2-utils
# RUN /tmp/materia-theme/install.sh
# RUN dpkg -i /tmp/paper*.deb
# RUN apt-get install -f -y

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
  Xvfb :1 -screen 0 1920x1080x16 & \
# Openbox
  (export DISPLAY=:1 && openbox-session) &

CMD ["/sbin/my_init"]


USER 1000

ENTRYPOINT ["/dockerstartup/entrypoint.sh"]
CMD ["--wait"]