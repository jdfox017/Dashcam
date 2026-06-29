# Raspberry Pi Zero 2 W Dashcam

This project is a custom 3D printed heat resistant Raspberry Pi Zero dashcam system designed to start recording when the car turns on and end the video when the car turns off. This is my first embedded systems project I have done on my own, so I am sure there is room for improvement.

I wanted the dashcam to work without needing a screen, keyboard, or manual startup. The Raspberry Pi powers on with the car, the script starts from cron, and the camera records clips to a separate storage partition on the microSD card.

---

**Code Setup**

Storage: Make a second exFAT partition to save the videos there (`dashcam_share`). The current script expects that partition to be `/dev/mmcblk0p3` and mounts it at `/mnt/dashcam_share`.

Placement: Copy `dashcam.sh` into the Pi user's home directory.

Permissions: Run this in the terminal to make the script executable:

```bash
chmod +x ~/dashcam.sh
```

Automation: Add the line provided in the `crontab` file to your user crontab (`crontab -e`) so the camera starts recording automatically on boot.

---

**Recording & Storage**

The script records with `rpicam-vid` and saves the videos as `.ts` files. I used `.ts` because it is more tolerant of sudden power cuts than a normal `.mp4` file. Since the car can turn off while the Pi is still recording, this makes it more likely that the last clip will still be usable.

Each recording is 10 minutes long. The script creates a folder for the current date and names each clip with the current time. If the Pi clock is wrong and a filename already exists, the script adds a number to the filename instead of overwriting an older video.

The script checks that `/mnt/dashcam_share` is actually mounted before recording or deleting anything. This matters because if the video partition fails to mount, the Pi could otherwise write videos to the main filesystem by mistake.

Storage cleanup is based on disk usage. The script does not delete videos just because they are old. When the video partition goes above the storage limit, currently 75%, it deletes the oldest `.ts` clips until the partition is back under the limit.

---

**Hardware & 3D Printing**

Filament: ASA was used to prevent melting in the hot car interior.

Mounting: A 1/4"-20 bolt was manually drilled into the top of the case. Make sure to drill a hole in the top that is slightly smaller than the screw you intend to use to mount, and then hand screw in the intended screw. A dashcam rearview mirror mounting kit was bought on Amazon.

Designing: I first looked online to get a base STL file for the Raspberry Pi Zero 2 W case. I found a case from another user online and downloaded a case file with nothing extra on it. Using an open source CAD software, I removed some prior engravings from the original file and added the area for drilling/mounting and engraved names into the sides. I also made the opening for the camera larger, but the inside case area for the camera to rest was a little too small for the camera I used. I had to cut out more room for the camera to rest; that is the reason there is tape on the bottom of the case.

---

**Scripting & Troubleshooting**

Most of the scripting work is mine, and I used AI when I was stuck and things were not working at times. I first added a second exFAT partition in the microSD card where the videos would record. In the shell script is where the recording, storage checks, and cleanup logic reside, and the crontab is where the script starts.

One of my first issues was the fact that when the dashcam was in my car it did not always have a network connection, so the timestamps could be incorrect. The current script is written to handle that better by avoiding filename overwrites and by not deleting footage based only on age.

Another issue I found later was that when I went back to check footage, some of it was not there. The older version of the script deleted folders and clips after a certain number of days, which was risky if the Pi clock was wrong. The current version only deletes the oldest clips when the storage partition is above the usage limit.

---

This repository contains a school project shared for educational and portfolio purposes. Please do not copy, redistribute, or reuse this work without permission.
