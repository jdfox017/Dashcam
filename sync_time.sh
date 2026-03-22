#!/bin/bash

sudo nmcli radio wifi on

while [ -z "$(hostname -I)" ]; do
  sleep 1
done

sudo systemctl restart systemd-timesyncd

sleep 2