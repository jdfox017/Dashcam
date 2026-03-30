#!/bin/bash

sudo nmcli radio wifi on

sudo nmcli --wait 10 device wifi connect "Your_SSID" password "Your_Password"

if [ -n "$(hostname -I)" ]; then
  sudo systemctl restart systemd-timesyncd
  sleep 2
fi
