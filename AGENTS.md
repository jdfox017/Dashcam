# Project Instructions

## Context

- If available, also follow `../../AGENTS.md` for workspace-wide rules.
- `dashcam.sh` controls mounting, recording, and storage cleanup on a Raspberry Pi.
- `crontab` starts the script at boot.
- Images and STL files document the physical build and are not normal text context.

## Rules

- Before changing files, provide a short plan.
- Treat the device path, mount point, storage threshold, recording settings, and power-loss behavior as hardware-dependent.
- Call out hardware assumptions before changing those values.
- Preserve the mounted-storage check before recording or deleting footage.
- Keep `README.md` synchronized with setup or behavior changes.

## Verification

- Run `bash -n dashcam.sh` when Bash is available.
- Inspect images or STL files only when the task concerns the enclosure or physical installation.
