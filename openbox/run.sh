sudo docker run -i -p 5901:5901 --memory 1524m --rm --name test --security-opt seccomp=$(pwd)/src/files/chrome.json -v /run/user/1000/pulse:/run/user/1000/pulse -e PULSE_SERVER=unix:/run/user/1000/pulse/native -t box:01 /bin/bash
