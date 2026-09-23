% Edit these paths to point to your own audio. Run from the repository root.
addpath('src');
buildDatabase('grainDatabase.mat', 'source_audio', 2048, 4);
concatenateAudio('target.wav', 'grainDatabase.mat', 'result.wav');
