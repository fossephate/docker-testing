#!/bin/bash
### every exit != 0 fails the script
# set -e

# ## correct forwarding of shutdown signal
# cleanup () {
#     kill -s SIGTERM $!
#     exit 0
# }
# trap cleanup SIGINT SIGTERM

## prepare env
# cp /etc/skel/.bashrc $HOME/.bashrc
# cp /etc/skel/.profile $HOME/.profile


# if [ x"$USER_ID" != x"0" ]; then
#     export NSS_WRAPPER_PASSWD=/tmp/passwd
#     export NSS_WRAPPER_GROUP=/tmp/group
#     cat /etc/passwd > $NSS_WRAPPER_PASSWD
#     cat /etc/group > $NSS_WRAPPER_GROUP
#     export USER_ID=$(id -u)
#     export GROUP_ID=$(id -u)
#     echo "default:x:${USER_ID}:${GROUP_ID}:User:${HOME}:/bin/bash" >> $NSS_WRAPPER_PASSWD
#     echo "default:x:${GROUP_ID}:" >> $NSS_WRAPPER_GROUP
#     echo 'export NSS_WRAPPER_PASSWD=/tmp/passwd' >> $HOME/.bashrc
#     echo 'export NSS_WRAPPER_GROUP=/tmp/group' >> $HOME/.bashrc
#     if [ -r /usr/lib/libnss_wrapper.so ]; then
#         export LD_PRELOAD=/usr/lib/libnss_wrapper.so
#         echo "export LD_PRELOAD=/usr/lib/libnss_wrapper.so" >> $HOME/.bashrc
#     elif [ -r /usr/lib64/libnss_wrapper.so ]; then
#         export LD_PRELOAD=/usr/lib64/libnss_wrapper.so
#         echo "export LD_PRELOAD=/usr/lib64/libnss_wrapper.so" >> $HOME/.bashrc
#     else
#         echo "no libnss_wrapper.so installed!"
#         exit 1
#     fi
#     source /etc/bash.bashrc
# fi
# source /etc/bash.bashrc

# echo $(id -u)

# todo: use env variable for this:
cd /headless/host/
# dev
git pull origin master

# can't be 16 bit bc ffmpeg's x11grab doesn't support it:
Xvfb :1 -screen 0 1920x1080x24 &
openbox-session &
# https://stackoverflow.com/questions/56218242/headless-chromium-on-docker-fails
chromium-browser --start-maximized --disable-dev-shm-usage &

# echo "sleeping for 10 seconds"
# sleep 10
# echo "done sleeping"

node --experimental-modules ./src/libs/lagless/HostStream.mjs $STREAM_ARGS &


# node --experimental-modules ./src/libs/lagless/HostStream.mjs \
# --streamKey=$STREAM_KEY \
# --drawMouse="true" --usePulse="true" \
# --audioDevice="sink-$NUM.monitor" --useLocalFfmpegInstall="true" \
# --debug="false" \
# --videoBitrate=6000 --combineAV="false" \
# --groupOfPictures=120 --muxDelay="0.0001" \
# --resolution=540

# node --experimental-modules ./src/libs/lagless/HostStream.mjs \
# --user="$USERNAME" \
# --password="$PASSWORD" \
# --drawMouse="true" --usePulse="true" \
# --useLocalFfmpegInstall="true" \
# --videoBitrate=6000 --combineAV="false" \
# --muxDelay="0.0001" \
# --resolution=540 --debug="true" &





# node --experimental-modules ./src/libs/lagless/HostStream.mjs \
# --USER=$USERNAME \
# --PASSWORD=$PASSWORD \
# --drawMouse="true" --usePulse="true" \
# --audioDevice="sink-$NUM.monitor" --useLocalFfmpegInstall="true" \
# --debug="false" \
# --videoBitrate=6000 --combineAV="false" \
# --muxDelay="0.0001" \
# --resolution=540

# xset -dpms &
# xset s noblank &
# xset s off &


echo "$@"

exec "$@"