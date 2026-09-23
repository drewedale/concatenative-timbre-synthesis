# Concatenative timbre synthesis

A MATLAB experiment in **concatenative synthesis**: break one or more source recordings into short grains, compare their Bark spectrum and harmonic ratio with each frame of a target recording, choose the nearest source grain, then overlap-add the chosen grains. The result follows the target's sequence of audio features while using sounds from the source recordings. It is an experimental effect, not a guaranteed voice or instrument conversion.

## Requirements

- MATLAB with Audio Toolbox (for `audioFeatureExtractor`)
- Your own source recording(s) and target recording, with the **same sample rate**
- Source audio in WAV, MP3, FLAC, AIFF, or M4A format; a WAV target and output are easiest to work with

The project was prepared by static review; MATLAB and Audio Toolbox were unavailable here, so the revised code has not been run in MATLAB.

## Run

From the repository root in MATLAB:

```matlab
addpath('src');
buildDatabase('grainDatabase.mat', 'source_audio', 2048, 4);
concatenateAudio('target.wav', 'grainDatabase.mat', 'result.wav');
```

Put source recordings into a `source_audio` directory and the target at `target.wav`, or change the paths. `concatScript.m` contains the same example. `N` is the grain length in samples and `overlap` is a **divisor**: `4` gives a hop of `N/4` samples (75% overlap). The output is mono. Larger source collections provide more candidate grains but increase processing time and database size. The database is a MATLAB `.mat` file and is rebuilt when the source set or settings change.

## Project layout

| Path | Purpose |
| --- | --- |
| `src/buildDatabase.m` | Extract grains and apply global min/max scaling across the source collection. |
| `src/extractFeatures.m` | Extract Bark spectrum and harmonic ratio per grain. |
| `src/concatenateAudio.m` | Find the closest grain to each target frame and write output audio. |
| `src/audioFrames.m`, `src/frameAssembler.m` | Frame, window, and overlap-add audio. |
| `original/` | The three files from the supplied December 2023 archive, preserved as-is. They reference private audio and helper functions that were not in that archive. |

The revised implementation filters folder entries to supported audio files, stores one feature scale for the full source collection, handles constant feature values, and rejects sample-rate mismatches. It uses nearest-neighbor matching independently for each frame, so rapid grain changes and audible seams are possible. Audio recordings and generated databases are omitted; use recordings you have permission to share if you add examples later.

## License

No license has been selected for this project. Contact the author for permission to reuse the code; add a `LICENSE` file if you decide to offer an open-source license.
