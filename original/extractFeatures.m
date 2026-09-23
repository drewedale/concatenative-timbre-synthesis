function [featureMatrix, minVals, maxVals, numFrames, xFrames] = extractFeatures(x, Fs, N, overlap)

    % [magSpecFrames, numFrames, xFrames]=mySpectrogram(x,N,overlap);
    [xFrames, numFrames] = audioFrames(x, N, overlap);
%add everything past spectral centroid (especially harmonic ratio, short
%time energy, zerocrossrate) 
    thisAudioFE = audioFeatureExtractor(...
        "SampleRate", Fs, ...
        "Window", hann(N), ...
        "OverlapLength", 0, ...
        "barkSpectrum", true, ...
        "harmonicRatio", true ...
        );
        %"zerocrossrate", true, ...
        %"shortTimeEnergy", true ...
    

    % we'll turn off normalization so that signal amplitude is encoded into
    % the feature
    setExtractorParameters(thisAudioFE, "barkSpectrum", WindowNormalization=false);

    % since the audio toolbox Bark Spectrum feature has 32 bands by
    % default, we need a 32-row column vector for each frame of audio

    %add more rows to the vector when adding additional features

    featureMatrix=zeros(33, numFrames);

    for frame=1:numFrames

        featureData = extract(thisAudioFE, xFrames(:, frame));
        featureMatrix(:, frame) = featureData';

        % centroid=specCentroid(magSpecFrames(:,frame),Fs);
        % spread=specSpread(magSpecFrames(:,frame),centroid,Fs);
        % 
        % featureMatrix(:,frame)=[centroid;spread];
    end

    % get the min and max values across all frames/columns for each feature
    minVals = min (featureMatrix, [], 2);
    maxVals = max (featureMatrix, [], 2);

end