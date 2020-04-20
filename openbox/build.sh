

CURRENT_DIR=$PWD
VMHOME=$PWD/src/files/home/
HOSTFILES=$PWD/src/files/home/host/

if test -d "$HOSTFILES"; then
    cd $HOSTFILES
    git pull --recurse-submodules
else 
    cd $VMHOME
    git clone --recurse-submodules https://github.com/fossephate/rgio-host host
    cd $HOSTFILES
fi

git pull --recurse-submodules origin master
cd $HOSTFILES

# todo: check if necessary
# npm i --production
# npm run build:native


cd $CURRENT_DIR
sudo docker build -t box .