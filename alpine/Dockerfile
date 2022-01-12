
# FROM alpine:3.7

# https://github.com/mhart/alpine-node
FROM mhart/alpine-node:12


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

RUN apk add --update --no-cache \
# X Server
  xvfb \
# Openbox
  openbox \
  git

# RUN apt-get install -y \
#     chromium-browser chromium-browser-l10n chromium-codecs-ffmpeg-extra \
#     # chromium-codecs-ffmpeg chromium-codecs-ffmpeg-extra
#     pulseaudio socat \
#     pulseaudio-equalizer \
#     libnss-wrapper \
#     wget \
#     ffmpeg

RUN apk add --update --no-cache \
  bash \
  chromium \
  pulseaudio

# inject files
ADD ./src/scripts $STARTUPDIR
ADD ./src/files/home $HOME
ADD ./src/files/etc /etc


# RUN chmod -w /etc/opt/chrome/policies/managed
RUN chmod +x /headless/host/misc/utils/ffmpeg
RUN npm rebuild $HOME/host/

# todo: delete /tmp files

# RUN find $STARTUPDIR $HOME -name '*.sh' -exec chmod a+x {} + && \
#     find $STARTUPDIR $HOME -name '*.desktop' -exec chmod a+x {} + && \
#     chgrp -R 0 $STARTUPDIR $HOME && \
#     chmod -R a+rw $STARTUPDIR $HOME && \
#     find $STARTUPDIR $HOME -type d -exec chmod a+x {} + && \
#     echo LANG=en_US.UTF-8 > /etc/default/locale && \
#     locale-gen en_US.UTF-8

RUN find $STARTUPDIR $HOME -name '*.sh' -exec chmod a+x {} + && \
    find $STARTUPDIR $HOME -name '*.desktop' -exec chmod a+x {} + && \
    chgrp -R 0 $STARTUPDIR $HOME && \
    chmod -R a+rw $STARTUPDIR $HOME && \
    find $STARTUPDIR $HOME -type d -exec chmod a+x {} +

# RUN chmod +x $STARTUPDIR/entrypoint.sh
# RUN chgrp -R 0 $STARTUPDIR $HOME
# RUN chmod -R a+rw $STARTUPDIR $HOME


# Option1: Using unencrypted password/ specifying password
# RUN useradd -m $USERNAME --uid=${UID} && echo "${USERNAME}:${PW}" | chpasswd
# RUN useradd -ms /bin/bash -d $HOME hostbot
RUN adduser -S hostbot -h $HOME

USER hostbot

ENTRYPOINT ["/dockerstartup/entrypoint.sh"]
# CMD ["--wait"]


# ENTRYPOINT "/dockerstartup/entrypoint.sh"

# CMD bash -C "/dockerstartup/entrypoint.sh;bash"
