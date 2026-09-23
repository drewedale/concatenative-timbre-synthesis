function buildDatabase (outputFile, audioFolder, N, overlap)


folderInfo=dir(audioFolder);
numFiles=length(folderInfo);
grainDatabase={};
grainIndex=1;
for fileIndex=1:numFiles

    fileName=strcat(folderInfo(fileIndex).folder, '/',folderInfo(fileIndex).name);
    [x, Fs]=audioread(fileName);
    x=x(:,1);
    fprintf('processing %s\n', folderInfo(fileIndex).name);
    [featureMatrix, minVals, maxVals, numFrames, xFrames]...
    =extractFeatures(x,Fs,N,overlap);

    % normalize the feature database across frames so that each row
    % contains normalized feature data
    featureMatrix = normalize (featureMatrix, 2, 'range');

    for frame=1:numFrames
   
        %add amplitude and zero crossing rate
        %column 1 of grainDatabase is feature data
        grainDatabase{grainIndex,1}=featureMatrix(:,frame);
        %column 2 is waveform
        grainDatabase{grainIndex,2}=xFrames(:,frame);
        %column 3 is Fs
        grainDatabase{grainIndex,3}=[Fs;N;overlap];
        %column 4 is folder
        grainDatabase{grainIndex,4}=folderInfo(fileIndex).folder;
        %column 5 is name
        grainDatabase{grainIndex,5}=folderInfo(fileIndex).name;
        grainIndex=grainIndex+1;
    end

end
save(outputFile,'grainDatabase','minVals', 'maxVals', "-v7.3");
%normalize database
%similarity metrics
end