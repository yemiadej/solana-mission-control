#!/bin/bash

set -e

cd $HOME
echo "------ Building and running the code --------"

#Stop the solana agent if not already stopped
if systemctl list-units --full -all | grep -i solana_mc.service ; then
  echo "Found solana-mc service...stopping it."
  sudo systemctl stop solana_mc.service
  echo "Disabling solana_mc service."
  sudo systemctl disable solana_mc.service
  #Remove solana-mc service file
  if ! sudo rm /etc/systemd/system/solana_mc.service; then
    echo "Unable to remove solana-mc service file"
  else
    echo "Successfully removed systemctl service file for solana-mc"
  fi
fi

rm -rf $HOME/solana-mission-control

rm $HOME/go/bin/solana-mc

echo "** Done with uninstalltion **"
