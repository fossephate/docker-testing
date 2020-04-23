#!/bin/bash
### every exit != 0 fails the script
set -e

## correct forwarding of shutdown signal
cleanup () {
    kill -s SIGTERM $!
    exit 0
}
trap cleanup SIGINT SIGTERM

## prepare env
cp /etc/skel/.bashrc $HOME/.bashrc
cp /etc/skel/.profile $HOME/.profile


if [ x"$USER_ID" != x"0" ]; then
    export NSS_WRAPPER_PASSWD=/tmp/passwd
    export NSS_WRAPPER_GROUP=/tmp/group
    cat /etc/passwd > $NSS_WRAPPER_PASSWD
    cat /etc/group > $NSS_WRAPPER_GROUP
    export USER_ID=$(id -u)
    export GROUP_ID=$(id -u)
    echo "default:x:${USER_ID}:${GROUP_ID}:User:${HOME}:/bin/bash" >> $NSS_WRAPPER_PASSWD
    echo "default:x:${GROUP_ID}:" >> $NSS_WRAPPER_GROUP
    echo 'export NSS_WRAPPER_PASSWD=/tmp/passwd' >> $HOME/.bashrc
    echo 'export NSS_WRAPPER_GROUP=/tmp/group' >> $HOME/.bashrc
    if [ -r /usr/lib/libnss_wrapper.so ]; then
        export LD_PRELOAD=/usr/lib/libnss_wrapper.so
        echo "export LD_PRELOAD=/usr/lib/libnss_wrapper.so" >> $HOME/.bashrc
    elif [ -r /usr/lib64/libnss_wrapper.so ]; then
        export LD_PRELOAD=/usr/lib64/libnss_wrapper.so
        echo "export LD_PRELOAD=/usr/lib64/libnss_wrapper.so" >> $HOME/.bashrc
    else
        echo "no libnss_wrapper.so installed!"
        exit 1
    fi
    source /etc/bash.bashrc
fi
source /etc/bash.bashrc


# install rgio-host:
# cd /headless/
# git clone --recurse-submodules https://github.com/fossephate/rgio-host/
cd /headless/host/
git pull origin master
# npm i --save https://github.com/fossephate/robotjs/tarball/master
# npm i .
# npm run build:native
# npm run build:dev
# chmod +x ./misc/utils/ffmpeg
# ./node_modules/.bin/electron --no-sandbox .

# export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# unset SESSION_MANAGER
# unset DBUS_SESSION_BUS_ADDRESS
# xset -dpms &
# xset s noblank &
# xset s off &


# rm -rfv /tmp/.X*-lock /tmp/.X11-unix

# Xvfb :1 -screen 0 $SCREEN_RESOLUTIONx16 &
# Xvfb :1 -screen 0 1920x1080x16 &
# openbox-session &
# chromium-browser &

# xset -dpms &
# xset s noblank &
# xset s off &


# tail -f $STARTUPDIR/*.log $HOME/.vnc/*$DISPLAY.log


# pulseaudio -D --exit-idle-time=-1
# # Load the virtual sink and set it as default
# pacmd load-module module-virtual-sink sink_name=v1
# pacmd set-default-sink v1
# # set the monitor of v1 sink to be the default source
# pacmd set-default-source v1.monitor


if [ -z "$1" ] || [[ $1 =~ -w|--wait ]]; then
    wait $PID_SUB
else
    # unknown option ==> call command
    echo -e "\n\n------------------ EXECUTE COMMAND ------------------"
    echo "Executing command: '$@'"
    exec "$@"
fi