# This Dockerfile is used to build an headles vnc image based on Ubuntu

FROM phusion/baseimage:0.11
# FROM debian:buster

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

RUN apt-get install -y \
    chromium-browser chromium-browser-l10n chromium-codecs-ffmpeg \
    geany geany-plugins-common \
    firefox \
    libreoffice \
    libnss-wrapper \
    ttf-wqy-zenhei \
    gettext \
    pinta \
    xterm \
    evince 

RUN apt-get install -y \
    openssh-client \
    openssl \
    dnsutils \
    curl \
    screen \
    wget \
    rsync \
    whois \
    netcat \
    nmap \
    vim \
    wget \
    net-tools \
    locales \
    bzip2 \
    python-numpy \
    supervisor

RUN apt-get update && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y \
      dbus-x11 \
      procps \
      psmisc && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y \
      mesa-utils \
      mesa-utils-extra \
      libxv1 && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      xdg-utils \
      xdg-user-dirs \
      menu-xdg \
      mime-support \
      desktop-file-utils

# cinnamon and some utils
RUN apt-get update && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      cinnamon \
      cinnamon-l10n && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      dconf-cli \
      gedit \
      gnome-system-monitor \
      gnome-terminal \
      libpulse0 \
      sudo \
      synaptic

# Install xvfb as X-Server and x11vnc as VNC-Server
RUN apt-get update && apt-get install -y --no-install-recommends \
				xvfb \
				xauth \
				x11vnc \
				x11-utils \
				x11-xserver-utils
		# && rm -rf /var/lib/apt/lists/*

RUN apt-get install --no-install-recommends -y xserver-xorg xserver-xorg-video-fbdev xinit pciutils xinput xfonts-100dpi xfonts-75dpi xfonts-scalable

# RUN apt-get purge -y pm-utils xscreensaver* && \
    # apt-get -y clean


### Install xvnc-server & noVNC - HTML5 based VNC viewer
RUN mkdir -p $NO_VNC_HOME/utils/websockify && \
    wget -qO- https://dl.bintray.com/tigervnc/stable/tigervnc-1.9.0.x86_64.tar.gz | tar xz --strip 1 -C / && \
    wget -qO- https://github.com/novnc/noVNC/archive/v1.1.0.tar.gz | tar xz --strip 1 -C $NO_VNC_HOME && \
    wget -qO- https://github.com/novnc/websockify/archive/v0.9.0.tar.gz | tar xz --strip 1 -C $NO_VNC_HOME/utils/websockify && \
    chmod +x -v $NO_VNC_HOME/utils/*.sh && \
    cp -f /headless/noVNC/vnc.html /headless/noVNC/index.html

# RUN Xvfb :1 -screen 0 800x600x16 &
# ENV DISPLAY=:1.0


### inject files
ADD ./src/scripts $STARTUPDIR
# ADD ./src/theming/ /tmp

# install materia and paper icons
# RUN apt-get install -y gnome-themes-standard gtk2-engines-murrine libglib2.0-dev libxml2-utils
# RUN /tmp/materia-theme/install.sh
# RUN dpkg -i /tmp/paper*.deb
# RUN apt-get install -f -y

# todo: delete /tmp files

# dockbarx
# add-apt-repository ppa:xuzhen666/dockbarx
# apt-get update
# apt-get install -y dockbarx xfce4-dockbarx-plugin dockbarx-themes-extra

### configure startup and set perms
# RUN echo "CHROMIUM_FLAGS='--no-sandbox --start-maximized --user-data-dir'" > $HOME/.chromium-browser.init && \
#     # /bin/sed -i '1 a. /headless/.bashrc' /etc/xdg/xfce4/xinitrc && \



RUN find $STARTUPDIR $HOME -name '*.sh' -exec chmod a+x {} + && \
    find $STARTUPDIR $HOME -name '*.desktop' -exec chmod a+x {} + && \
    chgrp -R 0 $STARTUPDIR $HOME && \
    chmod -R a+rw $STARTUPDIR $HOME && \
    find $STARTUPDIR $HOME -type d -exec chmod a+x {} + && \
    echo LANG=en_US.UTF-8 > /etc/default/locale && \
    locale-gen en_US.UTF-8


CMD ["/sbin/my_init"]

USER 1000

ENTRYPOINT ["/dockerstartup/entrypoint.sh"]
# CMD ["--wait"]


# CMD ["cinnamon-session"]