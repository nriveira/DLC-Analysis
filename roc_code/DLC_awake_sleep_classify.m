function [centroids,deltas,deltapercentiles,sleep_awake_frames,perc_rect,non_sleep_frames] = DLC_awake_sleep_classify(dlcfiles,motionThreshold,timeThreshold,fps)
%{
    INPUTS:
        filename - name of the file to be analyzed
        motionThreshold - motion percentile threshold
        timeThreshold - time threshold for defining sleep and awake states
        fps - video framerate
    OUTPUTS:
        centroids - DLC centroids evaluated
        deltas - changes in DLC centroids
        deltapercentiles - values corresponding to delta percentiles
        sleep_awake_frames - 1 is asleep, 0 is awake
%}
%% Loading data
motionData = [];
for dlcfilect = 1:length(dlcfiles)
    csvname = char(dlcfiles(dlcfilect));
    DVdata = readtable(csvname);
    motionData  = [motionData;DVdata];
end
clearvars DVdata;

%% Running likelihood processing
motionData = table2array(motionData);
[motionData,perc_rect] = adp_filt(motionData); %B-SOiD function
%% Extracting position data
motionDataStruc.xy.nose = motionData(:,1:2);
motionDataStruc.xy.mdbdy = motionData(:,3:4);
motionDataStruc.xy.bot = motionData(:,5:6);
motionDataStruc.xy.flp = motionData(:,7:8);
motionDataStruc.xy.frp = motionData(:,9:10);
motionDataStruc.xy.hlp = motionData(:,11:12);
motionDataStruc.xy.hrp = motionData(:,13:14);

%% Extracting frame number and converting to time
[m,n] = size(motionData);
motionDataStruc.framect = 0:(m-1);
for frameidx = 1:length(motionDataStruc.framect)
    motionDataStruc.time(frameidx) = (motionDataStruc.framect(frameidx))./fps;
end

%% Evaluating centroids
centroids = [];
for frameidx = 1:length(motionDataStruc.framect)
    centroids(frameidx,1) = (motionDataStruc.xy.nose(frameidx,1)+...
        motionDataStruc.xy.flp(frameidx,1)+...
        motionDataStruc.xy.frp(frameidx,1)+...
        motionDataStruc.xy.hlp(frameidx,1)+...
        motionDataStruc.xy.hrp(frameidx,1)+...
        motionDataStruc.xy.bot(frameidx,1)+...
        motionDataStruc.xy.mdbdy(frameidx,1))/7;
    centroids(frameidx,2) = (motionDataStruc.xy.nose(frameidx,2)+...
        motionDataStruc.xy.flp(frameidx,2)+...
        motionDataStruc.xy.frp(frameidx,2)+...
        motionDataStruc.xy.hlp(frameidx,2)+...
        motionDataStruc.xy.hrp(frameidx,2)+...
        motionDataStruc.xy.bot(frameidx,2)+...
        motionDataStruc.xy.mdbdy(frameidx,2))/7;
end
for frameidx = 1:(length(motionDataStruc.framect)-1)
    deltas(frameidx,1) = abs(centroids((frameidx+1),1)-centroids(frameidx,1));
    deltas(frameidx,2) = abs(centroids((frameidx+1),2)-centroids(frameidx,2));
end
deltapercentiles(:,1) = prctile(deltas(:,1),1:100,'all');
deltapercentiles(:,2) = prctile(deltas(:,2),1:100,'all');

%% Generating awake/sleep checker
checkAS = ones(fps*timeThreshold,1).';

%% Classifying awake or asleep
deltaValThreshold(1,1) = deltapercentiles(motionThreshold,1);
deltaValThreshold(1,2) = deltapercentiles(motionThreshold,2);
awake_sleep_score_xy(:,1) = deltas(:,1) <= deltaValThreshold(1,1);
awake_sleep_score_xy(:,2) = deltas(:,2) <= deltaValThreshold(1,2);
awake_sleep_score = awake_sleep_score_xy(:,1) | awake_sleep_score_xy(:,2);
awake_sleep_score = double(awake_sleep_score).';
sleep_awake_frames = zeros(length(awake_sleep_score),1).';
sleep_bouts = strfind(awake_sleep_score,checkAS);
for sleepidx = 1:length(sleep_bouts)
    sleep_awake_frames(sleep_bouts(sleepidx):(sleep_bouts(sleepidx)+length(checkAS)-1)) = ...
        checkAS;
end

%% Classifying non-sleep awake
non_sleep_scores = double(~sleep_awake_frames).';
non_sleep_deltas(:,1) = deltas(:,1).*non_sleep_scores;
non_sleep_deltas(:,2) = deltas(:,2).*non_sleep_scores;
non_sleep_deltas(non_sleep_deltas == 0) = 1000000;
non_sleep_scores(:,1) = non_sleep_deltas(:,1) <= deltaValThreshold(1,1);
non_sleep_scores(:,2) = non_sleep_deltas(:,2) <= deltaValThreshold(1,2);
non_sleep_frames = non_sleep_scores(:,1) | non_sleep_scores(:,2);

end
