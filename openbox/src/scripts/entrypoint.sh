#!/bin/bash
### every exit != 0 fails the script
set -e

## argument handling
if [[ $1 =~ -d|--debug ]]; then
    echo -e "\n\n------------------ DEBUG VNC STARTUP -----------------"
    export DEBUG=true
fi

## correct forwarding of shutdown signal
cleanup () {
    kill -s SIGTERM $!
    exit 0
}
trap cleanup SIGINT SIGTERM

## prepare env
cp /etc/skel/.bashrc $HOME/.bashrc
cp /etc/skel/.profile $HOME/.profile

mkdir $HOME/.vnc/
echo '#!/bin/bash
. $HOME/.bashrc
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
xset -dpms &
xset s noblank &
xset s off &
' > $HOME/.vnc/xstartup
chmod 755 $HOME/.vnc/xstartup


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

## resolve_vnc_connection
VNC_IP=$(hostname -i)

## change vnc password
echo -e "\n------------------ change VNC password  ------------------"
# first entry is control, second is view (if only one is valid for both)
mkdir -p "$HOME/.vnc"
PASSWD_PATH="$HOME/.vnc/passwd"

if [[ -f $PASSWD_PATH ]]; then
    echo -e "\n---------  purging existing VNC password settings  ---------"
    rm -f $PASSWD_PATH
fi

echo "$VNC_PW" | vncpasswd -f >> $PASSWD_PATH
chmod 600 $PASSWD_PATH


# install materia theme:
# /tmp/

# install rgio-host:
# cd /headless/
# git clone --recurse-submodules https://github.com/fossephate/rgio-host/
cd /headless/host/
rm .git
git init
git remote add origin $GITHUBURL
git pull origin master
# npm i --save https://github.com/fossephate/robotjs/tarball/master
# npm i .
# npm run build:native
# npm run build:dev
# chmod +x ./misc/utils/ffmpeg
# ./node_modules/.bin/electron --no-sandbox .


## start vncserver and noVNC webclient
echo -e "\n------------------ start noVNC  ----------------------------"
if [[ $DEBUG == true ]]; then echo "$NO_VNC_HOME/utils/launch.sh --vnc localhost:$VNC_PORT --listen $NO_VNC_PORT"; fi
$NO_VNC_HOME/utils/launch.sh --vnc localhost:$VNC_PORT --listen $NO_VNC_PORT &> $STARTUPDIR/no_vnc_startup.log &
PID_SUB=$!

echo -e "\n------------------ start VNC server ------------------------"
echo "remove old vnc locks to be a reattachable container"
vncserver -kill $DISPLAY &> $STARTUPDIR/vnc_startup.log \
    || rm -rfv /tmp/.X*-lock /tmp/.X11-unix &> $STARTUPDIR/vnc_startup.log \
    || echo "no locks present"

echo -e "start vncserver with param: VNC_COL_DEPTH=$VNC_COL_DEPTH, VNC_RESOLUTION=$VNC_RESOLUTION\n..."
if [[ $DEBUG == true ]]; then echo "vncserver $DISPLAY -depth $VNC_COL_DEPTH -geometry $VNC_RESOLUTION"; fi
vncserver $DISPLAY -depth $VNC_COL_DEPTH -geometry $VNC_RESOLUTION &> $STARTUPDIR/no_vnc_startup.log

# tail -f $STARTUPDIR/*.log $HOME/.vnc/*$DISPLAY.log

if [ -z "$1" ] || [[ $1 =~ -w|--wait ]]; then
    wait $PID_SUB
else
    # unknown option ==> call command
    echo -e "\n\n------------------ EXECUTE COMMAND ------------------"
    echo "Executing command: '$@'"
    exec "$@"
fi