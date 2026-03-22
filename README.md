Raspberry Pi Zero 2 W Dashcam

This project is a custom 3D printed heat resistant Raspberry Pi Zero dashcam system
designed to start recording when the car turns on and end the video when the car turns off.
This is my first embedded systems project I have done on my own, so I am sure there is room for improvement.

--------------------------------------------------------------------------------------------------

**Code Setup**

Storage: Make a second exFAT partition to save the videos there (dashcam_share).

Placement: Copy dashcam.sh and sync_time.sh into the /home/user directory.

Permissions: Run chmod +x ∼/*.sh in the terminal to make the scripts executable.

Automation: Add the line provided in the crontab file to your system crontab (crontab -e) 
            so the camera starts recording automatically on boot.

--------------------------------------------------------------------------------------------------

**Hardware & 3D Printing**


Filament: ASA was used to prevent melting in the hot car interior.

Mounting: 1/4"-20 bolt was manually drilled into the top of the case.
Make sure to drill a hole in the top that is slightly smaller than the screw
you intend to use to mount, and then hand screw in the intended screw.
A dashcam rearview mirror mounting kit was bought on amazon.

--------------------------------------------------------------------------------------------------

**Troubleshooting**

Designing:
I first looked online to get a base STL file for the Raspberry Pi zero 2 W case.
I found a case from another user online and downloaded a case file with nothing extra on it.
Using an open source CAD software, I removed some prior engravings from the original file
and added the area for drilling/mounting and engraved names into the sides.
I also made the opening for the camera larger, but the inside the case area for the camera to rest
was a little too small for the camera I used. I had to cut out more room for the camera to rest,
that is the reason there is tape on the bottom of the case. 

Scripting:
Most of the scripting work is mine, I used AI when I was stuck and things weren't working at times.
I first added a second exFAT partition in the microSD card where the videos would record.
In the shell scripts is where all of the logic resides, and the crontab is where the scripts start.
One of my first issues was the fact that when the dashcam was in my car it did not have a network connection
so the timestamps were incorrect. This was solved by making the pi connect to known networks
like my hotspot or home wifi before starting the recording.
