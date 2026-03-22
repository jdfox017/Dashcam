#!/bin/bash

# Force the Pi to write data to the SD card every 1 second
sudo sysctl -w vm.dirty_writeback_centisecs=100
sudo sysctl -w vm.dirty_expire_centisecs=100

sleep 2

# Connects to either wifi or hotspot.
/home/fox282/sync_time.sh &

# Makes sure the pi is connected to a network so it is able to record with the right timestamp.
while [ -z "$(hostname -I)" ]; do
  sleep 1
done

# Scans and repairs filesystem errors caused by sudden power cuts from the car turning off.
sudo fsck.exfat -a /dev/mmcblk0p3
sleep 5

# Defines the directory for saving videos / tells the pi to only use 75% of the partitions storage for videos.
DASHCAM_DIR="/mnt/dashcam_share"
MAX_USAGE=75

echo "Dashcam starting"


while true;
do

    find "$DASHCAM_DIR" -name "*.ts" -type f -mtime +7 -delete
    # Delete oldest files until space is below 75%
    while [ "$(df "$DASHCAM_DIR" | awk 'NR==2 {print $5}' | tr -d '%')" -gt "$MAX_USAGE" ];
    do
        # Look for the oldest .ts files to delete
        OLDEST=$(find "$DASHCAM_DIR" -name "*.ts" -type f -printf '%T+ %p\n' | sort | head -n 1 | cut -d' ' -f2-)
        if [ -n "$OLDEST" ];
        then
            rm "$OLDEST"
 else
            break
        fi
    done

    # Create a folder for today's date
    CURRENT_DATE=$(date +%m-%d-%y)
    DATE_DIR="$DASHCAM_DIR/$(date +%m-%d-%y)"
    mkdir -p "$DATE_DIR"

    # Using .ts for power-loss safety
    FILE_BASE="$DATE_DIR/$(date +%H-%M-%S)"
    TS_FILE="$FILE_BASE.ts"

    # Record Using rpicam-vid directly to .ts
    rpicam-vid -o "$TS_FILE" \
        --width 1920 --height 1080 \
        --framerate 30 \
        --bitrate 5000000 \
        --awbgains 1.0,1.5 \
        -t 600000 \
        --codec libav \
        --libav-format mpegts \
        --inline \
        --flush \
        --nopreview
done