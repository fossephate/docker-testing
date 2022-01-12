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
    USERNAME=hostbot \
    PW=password
    

WORKDIR $HOME

RUN apt-get update && \
    apt-get -y dist-upgrade

RUN \
  apt-get install -y \
# X Server
  xvfb \
# Openbox
  openbox \
  pulseaudio \
  ffmpeg \
  chromium-browser

# RUN apt-get install -y \
# chromium-browser chromium-browser-l10n chromium-codecs-ffmpeg chromium-codecs-ffmpeg-extra


# dev
RUN apt-get install -y git

# removed: socat libnss-wrapper

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


# RUN chmod -w /etc/opt/chrome/policies/managed
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

# RUN chmod +x $STARTUPDIR/entrypoint.sh
# RUN chgrp -R 0 $STARTUPDIR $HOME
# RUN chmod -R a+rw $STARTUPDIR $HOME


# Option1: Using unencrypted password/ specifying password
# RUN useradd -m $USERNAME --uid=${UID} && echo "${USERNAME}:${PW}" | chpasswd
# https://stackoverflow.com/questions/27701930/add-user-to-docker-container
RUN useradd -ms /bin/bash -d $HOME hostbot

USER hostbot

ENTRYPOINT ["/dockerstartup/entrypoint.sh"]
# CMD ["--wait"]


# ENTRYPOINT "/dockerstartup/entrypoint.sh"

# CMD bash -C "/dockerstartup/entrypoint.sh;bash"
