%% initialize
clear;clc;
%column 3 of grainDatabase has Fs, N, and overlap for database analysis

%% load grainDatabase cell array
load("grainDatabase3.mat");


%% do synthesis
targetName= "In My Room Mix4.wav";
analysisInfo=grainDatabase{1,3};
[x,Fs]=audioread(targetName);
x=x(:,1);
N=analysisInfo(2);
overlap=analysisInfo(3);
% this feature matrix must be un-normalized
targetFeatureMatrix=extractFeatures(x,Fs,N,overlap);


[~,numFrames]=size(targetFeatureMatrix);
finalConcatFrames=zeros(N,numFrames);
hw=hann(N);
 %make an array to store the distances 
numGrains=length(grainDatabase);
distanceArray=zeros(numGrains,1);

for frame=1:numFrames
   
    %for every frame get distance between target grain and database grain
    %features
    targetFeature=targetFeatureMatrix(:,frame);

    % normalize the target feature according to the min/max values of each
    % feature in the normalized database feature matrix
    targetFeature = (targetFeature - minVals) ./ (maxVals - minVals);

    % need to clip the data within the 0-1 range in case that normalize
    % went negative or > 1
    targetFeature= min(max(targetFeature,0),1);

    for grain=1:numGrains
        grainFeature=grainDatabase{grain,1};
        distanceArray(grain)=norm(targetFeature-grainFeature);

    end
    %find database grain with minimum distance
    [~,matchIndex]=min(distanceArray);
    %get the waveform data for best match grain
    matchGrain=grainDatabase{matchIndex,2};
    %hann window best match grain for crossfade
    matchGrain=matchGrain.*hw;
    %mix grain into output signal array
    finalConcatFrames(:,frame)=matchGrain;
end

finalConcatSignal=frameAssembler(finalConcatFrames,overlap);
sound (finalConcatSignal, Fs);
%still need to normalize grainDatabase audio features
%still need to store max and min of each feature
%still need to add more features to extractFeatures