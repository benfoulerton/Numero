# Sound assets

The audio service (`lib/core/services/audio_service.dart`) plays one of five
short clips after every interaction (Spec §8):

| Effect              | Filename                  | When                            |
| ------------------- | ------------------------- | ------------------------------- |
| Correct answer      | `correct.mp3`             | Right answer, lesson advance    |
| Incorrect answer    | `incorrect.mp3`           | Wrong answer                    |
| Tap                 | `tap.mp3`                 | Button or tile selection        |
| Streak increment    | `streak_increment.mp3`    | Streak counter bumps up         |
| Chest open          | `chest_open.mp3`          | Reward chest opens (every 5th)  |

**This folder is intentionally empty in the shell build.** The audio service
silently swallows asset-missing exceptions, so the app runs without these
files — you just don't hear anything.

To add sound, drop the five MP3s above into this directory and rebuild.
The audio service does not need any code changes.

## Recommended characteristics

- Short (200-500 ms)
- Soft, not jarring
- Correct: ascending two-tone (Spec §8 bullet 2)
- Incorrect: softer, lower tone
- Mono is fine; phone speakers don't benefit from stereo

## Licensing reminder

Use sounds you have the right to ship. Royalty-free libraries
(e.g. freesound.org with appropriate licences, or commissioned originals)
are the safest path.
