

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

# git pull --recurse-submodules origin master
cd $HOSTFILES

# todo: check if necessary
npm i --production

sudo apt install -y libx11-dev libxtst-dev libpng++-dev ffmpeg libasound2-dev

# ensure same node version
#curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
#nvm install 12.16.2
#npm rebuild

cd $CURRENT_DIR
sudo docker build -t alpinebox:01 .
