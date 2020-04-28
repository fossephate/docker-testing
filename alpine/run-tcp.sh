HOSTIP="$(ip -4 -o a| grep docker0 | awk '{print $4}' | cut -d/ -f1)"
sudo docker run -i -p 5901:5901 --memory 2048m --rm --name test \
-e PULSE_SERVER=tcp:$DOCKER_IP:$PULSE_PORT \
--security-opt seccomp=$(pwd)/src/files/chrome.json \
-t box:01 /bin/bash
