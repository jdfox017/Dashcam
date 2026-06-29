#!/bin/bash

# Force the Pi to write data to the SD card every 1 second.
sudo sysctl -w vm.dirty_writeback_centisecs=100
sudo sysctl -w vm.dirty_expire_centisecs=100

sleep 2

# Defines where videos are saved and caps video storage at 75% usage.
DASHCAM_DIR="/mnt/dashcam_share"
VIDEO_DEVICE="/dev/mmcblk0p3"
MAX_USAGE=75

sudo mkdir -p "$DASHCAM_DIR"

echo "Dashcam starting"

while true;
do
    # Mount the video partition before recording or deleting anything.
    if ! mountpoint -q "$DASHCAM_DIR"; then
        sudo fsck.exfat -a "$VIDEO_DEVICE"
        sudo mount "$VIDEO_DEVICE" "$DASHCAM_DIR"
    fi

    if ! mountpoint -q "$DASHCAM_DIR"; then
        echo "Video storage is not mounted at $DASHCAM_DIR"
        sleep 10
        continue
    fi

    # Delete oldest .ts files until space is below 75%.
    while [ "$(df "$DASHCAM_DIR" | awk 'NR==2 {print $5}' | tr -d '%')" -gt "$MAX_USAGE" ];
    do
        OLDEST=$(find "$DASHCAM_DIR" -name "*.ts" -type f -printf '%T+ %p\n' | sort | head -n 1 | cut -d' ' -f2-)
        if [ -n "$OLDEST" ];
        then
            rm "$OLDEST"
        else
            break
        fi
    done

    # Create a folder for today's date.
    DATE_DIR="$DASHCAM_DIR/$(date +%m-%d-%y)"
    mkdir -p "$DATE_DIR"

    # Using .ts for power-loss safety.
    FILE_BASE="$DATE_DIR/$(date +%H-%M-%S)"
    TS_FILE="$FILE_BASE.ts"
    COUNT=1

    while [ -e "$TS_FILE" ];
    do
        TS_FILE=$(printf '%s-%03d.ts' "$FILE_BASE" "$COUNT")
        COUNT=$((COUNT + 1))
    done

    # Record using rpicam-vid directly to .ts.
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
