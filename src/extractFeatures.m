function [features, minVals, maxVals, numFrames, frames] = extractFeatures(x, Fs, N, overlap)
%EXTRACTFEATURES Bark spectrum and harmonic ratio for each audio grain.
    [frames, numFrames] = audioFrames(x, N, overlap);
    extractor = audioFeatureExtractor( ...
        'SampleRate', Fs, 'Window', hann(N, 'periodic'), ...
        'OverlapLength', 0, 'barkSpectrum', true, ...
        'harmonicRatio', true);
    features = zeros(extractor.FeatureVectorLength, numFrames);
    for k = 1:numFrames
        values = extract(extractor, frames(:, k));
        if size(values, 1) ~= 1 || size(values, 2) ~= size(features, 1)
            error('Unexpected audioFeatureExtractor output shape.');
        end
        features(:, k) = values.';
    end
    features(~isfinite(features)) = 0;
    minVals = min(features, [], 2);
    maxVals = max(features, [], 2);
end
