#!/bin/bash

set -e

echo "What network do you want to setup monitoring for? (0=devnet, 1=testnet, 2=mainnet)"?
read env

if [ $env -eq 0 ]; then
    networkName="devnet"
    export RPC_ENDPOINT="https://api.devnet.solana.com" 
    export NETWORK_RPC="https://api.devnet.solana.com" 
elif [ $env -eq 1 ]; then
    networkName="testnet"
    export RPC_ENDPOINT="https://api.testnet.solana.com" 
    export NETWORK_RPC="https://api.testnet.solana.com" 
elif [ $env -eq 2 ]; then
    networkName="mainnet"
    export RPC_ENDPOINT="https://api.mainnet-beta.solana.com" 
    export NETWORK_RPC="https://api.mainnet-beta.solana.com" 
else 
    echo "Invalid network exiting..."
    exit 1
fi;

echo "What is your validator name?"
read validatorName

echo "What is your validator public key?"
read validatorPubKey

echo "What is your validator vote key?"
read validatorVoteKey

cd $HOME
export VALIDATOR_NAME="${validatorName}" # Your validator name
export PUB_KEY="${validatorPubKey}"  # Ex - export PUB_KEY="valmmK7i1AxXeiTtQgQZhQNiXYU84ULeaYF1EH1pa"
export VOTE_KEY="${validatorVoteKey}" # Ex - export VOTE_KEY="2oxQJ1qpgUZU9JU84BHaoM1GzHkYfRDgDQY9dpH5mghh"
solanamc_path=$HOME/solana-mission-control


cd $HOME

echo "--------- Cloning solana-monitoring-tool -----------"

if [ -d "$solanamc_path" ]; then
    cd $solanamc_path
    git pull origin main
else
    git clone https://github.com/yemiadej/solana-mission-control.git
    cd solana-mission-control
fi

mkdir -p  ~/.solana-mc/config/

cp example.config.toml ~/.solana-mc/config/config.toml

cd $HOME

echo "------ Updating config fields with exported values -------"

sed -i '/rpc_endpoint =/c\rpc_endpoint = "'"$RPC_ENDPOINT"'"' ~/.solana-mc/config/config.toml

sed -i '/network_rpc =/c\network_rpc = "'"$NETWORK_RPC"'"' ~/.solana-mc/config/config.toml

sed -i '/validator_name =/c\validator_name = "'"$VALIDATOR_NAME"'"'  ~/.solana-mc/config/config.toml

sed -i '/pub_key =/c\pub_key = "'"$PUB_KEY"'"'  ~/.solana-mc/config/config.toml

sed -i '/vote_key =/c\vote_key = "'"$VOTE_KEY"'"'  ~/.solana-mc/config/config.toml


echo "------ Building and running the code --------"

cd $HOME
cd solana-mission-control

go build -o solana-mc
mv solana-mc $HOME/go/bin

echo "--------checking for solana binary path and updates it in env--------"

if [ ! -z "${SOLANA_BINARY_PATH}" ];
then 
    SOLANA_BINARY="$SOLANA_BINARY_PATH"
else 
    SOLANA_BINARY="$(which solana)"
fi

echo "----------- Setup solana-mc service------------"

echo "[Unit]
Description=Solana-mc
After=network-online.target

[Service]
User=$USER
Environment="SOLANA_BINARY_PATH=$SOLANA_BINARY"
ExecStart=$HOME/go/bin/solana-mc
Restart=always
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target" | sudo tee "/lib/systemd/system/solana_mc.service"

echo "--------------- Start Solana-Mession-Control service ----------------"


sudo systemctl daemon-reload

sudo systemctl enable solana_mc.service

sudo systemctl start solana_mc.service

if systemctl is-active --quiet solana_mc.service ; then
    echo "solana-mc service is running"
else
    echo "solana-mc service is not running"
fi
    
echo "** Done **"