#!/bin/bash

set -e

cd $HOME
USEGOVERSION="1.19.1"
echo "------ checking for go, if it's not installed then it will be installed here -----"

command_exists () {
    type "$1" &> /dev/null ;
}

if command_exists go ; then
    echo "Golang is already installed"
else
  echo "------- Install dependencies -------"
  sudo apt update
  sudo apt install build-essential jq wget git -y

  wget https://dl.google.com/go/go${USEGOVERSION}.linux-amd64.tar.gz
  tar -xvf go${USEGOVERSION}.linux-amd64.tar.gz
  sudo mv go /usr/local

  echo "------ Update bashrc ---------------"
  export GOPATH=$HOME/go
  export GOROOT=/usr/local/go
  export GOBIN=$GOPATH/bin
  export PATH=$PATH:/usr/local/go/bin:$GOBIN
  echo "" >> ~/.bashrc
  echo 'export GOPATH=$HOME/go' >> ~/.bashrc
  echo 'export GOROOT=/usr/local/go' >> ~/.bashrc
  echo 'export GOBIN=$GOPATH/bin' >> ~/.bashrc
  echo 'export PATH=$PATH:/usr/local/go/bin:$GOBIN' >> ~/.bashrc

  source ~/.bashrc

  mkdir -p "$GOBIN"
fi


echo "** Done with prerequisite installtion **"
