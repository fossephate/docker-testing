


pulseaudio -Dv
pactl load-module module-native-protocol-unix socket=/tmp/pulseaudio-$SOCKET_NUM.socket sink_name=sink-$SOCKET_NUM
sudo docker run -i --memory 2048m --rm --name host-$SOCKET_NUM \
-e PULSE_SERVER=unix:/tmp/pulseaudio-$SOCKET_NUM.socket \
-e PULSE_COOKIE=/tmp/pulseaudio-$SOCKET_NUM.cookie \
--volume /tmp/pulseaudio-$SOCKET_NUM.socket:/tmp/pulseaudio-$SOCKET_NUM.socket \
--volume $(pwd)/src/configs/pulseaudio.client.conf:/etc/pulse/client.conf \
--user $(id -u):$(id -g) \
--security-opt seccomp=$(pwd)/src/files/chrome.json \
-t alpinebox:01 /bin/bash


# sudo docker run -i --memory 2048m --rm --name host$SOCKET_NUM \
# sudo docker run -i -p 5901:5901 --memory 2048m --rm --name test \
# -e PULSE_SERVER=unix:/tmp/pulseaudio.socket \
# -e PULSE_COOKIE=/tmp/pulseaudio.cookie \
# --volume /tmp/pulseaudio.socket:/tmp/pulseaudio.socket \
# --volume $(pwd)/src/configs/pulseaudio.client.conf:/etc/pulse/client.conf \
# --user $(id -u):$(id -g) \
# --security-opt seccomp=$(pwd)/src/files/chrome.json \
# -t box:01 /bin/bash



