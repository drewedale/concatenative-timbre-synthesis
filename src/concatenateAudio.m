function output = concatenateAudio(targetFile, databaseFile, outputFile)
%CONCATENATEAUDIO Match target frames to source grains and write a WAV file.
    db = load(databaseFile);
    [target, Fs] = audioread(targetFile);
    if Fs ~= db.databaseFs
        error('Target and source sample rates differ (%d vs %d Hz).', Fs, db.databaseFs);
    end
    target = mean(target, 2);
    [features, ~, ~, numFrames] = extractFeatures(target, Fs, db.N, db.overlap);
    if size(features, 1) ~= numel(db.minVals)
        error('Target and database feature dimensions differ. Rebuild the database.');
    end
    scale = db.maxVals - db.minVals;
    scale(scale == 0) = 1;
    features = (features - db.minVals) ./ scale;
    features = min(max(features, 0), 1);

    candidates = [db.grainDatabase{:, 1}];
    selected = zeros(db.N, numFrames);
    for frame = 1:numFrames
        distances = sum((candidates - features(:, frame)).^2, 1);
        [~, best] = min(distances);
        selected(:, frame) = db.grainDatabase{best, 2};
    end
    output = frameAssembler(selected, db.overlap);
    output = output(1:numel(target));
    peak = max(abs(output));
    if peak > 1
        output = output / peak;
    end
    audiowrite(outputFile, output, Fs);
end
