mouse3 = load("C:\Users\nrive\Research\AnkG\kinematicInformation\Mouse-3combined.mat");
%mouse4 = load("C:\Users\nrive\Research\AnkG\kinematicInformation\Mouse-4-4Cage.mat");
secondsMoving = 5;
fps = 30;
wtK = mouse3.combinedK;

eeg_start = (wtK.eeg_startTimestamp);
avg = fps*secondsMoving;
avgFilter = (1/avg)*ones(1,avg);

secondAvg = (conv(avgFilter, wtK.nose_vel));
secondAvg = secondAvg(ceil(avg/2):end-floor(avg/2));

threshold = 2.5;
runTimes = [];
index = 0;
lastTrue = 0;

for i = 1:length(secondAvg)
    if(secondAvg(i) > threshold)
        if(lastTrue ~= i-1)
            index = index+1;
            runTimes(index).start = i;
        else
            runTimes(index).stop = i;
        end
        lastTrue = i; 
    end
end

for i = 1:length(runTimes)
    runTimes(i).total = runTimes(i).stop-runTimes(i).start;
    runTimes(i).startTime = wtK.vid_timestamp(runTimes(i).start);
    runTimes(i).stopTime = wtK.vid_timestamp(runTimes(i).stop);
    runTimes(i).time_diff = eeg_start - runTimes(i).startTime;
end