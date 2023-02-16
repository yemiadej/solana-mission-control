#!/bin/bash

set -e

INSTALL_PATH=$HOME/solana-mission-control
INSTALL_BINARY=$HOME/go/bin/solana-mc

cd $HOME
echo "------ Building and running the code --------"

#Stop the solana agent if not already stopped
if systemctl list-units --full -all | grep -i solana_mc.service ; then
  echo "Found solana-mc service...stopping it."
  sudo systemctl stop solana_mc.service
  echo "Disabling solana_mc service."
  sudo systemctl disable solana_mc.service
  #Remove solana-mc service file
  if ! sudo rm /lib/systemd/system/solana_mc.service; then
    echo "Unable to remove solana-mc service file"
  else
    echo "Successfully removed systemctl service file for solana-mc"
  fi
fi

if [ -f "{$INSTALL_PATH}" ]; then
  echo "Found solana-mc folder...removing it."
  sudo rm -rf "$INSTALL_PATH"
fi

if [ -f "${INSTALL_BINARY}" ]; then
  echo "Found solana-mc binary...removing it."
  sudo rm -rf "${INSTALL_BINARY}"
fi

solanamc_dir=~/.solana-mc
if [ -d "$solanamc_dir" ]; then
  sudo rm -rf $solanamc_dir
fi

echo "** Done with uninstalltion **"
