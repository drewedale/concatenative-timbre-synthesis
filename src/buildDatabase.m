function buildDatabase(outputFile, audioFolder, N, overlap)
%BUILDDATABASE Save source grains and global feature scaling for matching.
% Source files in audioFolder must have the same sample rate.
    if ~isfolder(audioFolder)
        error('Source audio folder does not exist: %s', audioFolder);
    end
    names = {'*.wav', '*.mp3', '*.flac', '*.aif', '*.aiff', '*.m4a'};
    files = [];
    for extension = 1:numel(names)
        files = [files; dir(fullfile(audioFolder, names{extension}))]; %#ok<AGROW>
    end
    if isempty(files)
        error('No supported audio files found in %s.', audioFolder);
    end

    grainDatabase = cell(0, 3); % normalized features, waveform, source filename
    rawFeatures = cell(0, 1);
    databaseFs = [];
    for fileIndex = 1:numel(files)
        filename = fullfile(files(fileIndex).folder, files(fileIndex).name);
        [audio, Fs] = audioread(filename);
        if isempty(databaseFs)
            databaseFs = Fs;
        elseif Fs ~= databaseFs
            error('All source files must have the same sample rate (%s differs).', filename);
        end
        audio = mean(audio, 2); % mono mixdown
        [featureMatrix, ~, ~, numFrames, frames] = ...
            extractFeatures(audio, Fs, N, overlap);
        fprintf('Processing %s: %d grains\n', files(fileIndex).name, numFrames);
        for frame = 1:numFrames
            rawFeatures{end+1, 1} = featureMatrix(:, frame); %#ok<AGROW>
            grainDatabase(end+1, :) = {[], frames(:, frame), files(fileIndex).name}; %#ok<AGROW>
        end
    end

    allFeatures = [rawFeatures{:}];
    minVals = min(allFeatures, [], 2);
    maxVals = max(allFeatures, [], 2);
    scale = maxVals - minVals;
    scale(scale == 0) = 1;
    for grain = 1:size(grainDatabase, 1)
        grainDatabase{grain, 1} = (rawFeatures{grain} - minVals) ./ scale;
    end
    save(outputFile, 'grainDatabase', 'minVals', 'maxVals', ...
        'databaseFs', 'N', 'overlap', '-v7.3');
end
