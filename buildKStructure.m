for currentFile = "Mouse-17" %["Mouse-3","Mouse-4","Mouse-5","Mouse-8","Mouse-9","Mouse-10","Mouse-12","Mouse-16","Mouse-18","Mouse-19","Mouse-20","Mouse-21","Mouse-22","Mouse-23"]
    path = strcat("C:\Users\nrive\Research\AnkG\kinematicInformation\combinedEEG\", currentFile, ".mat");
    load(path);

    for kCount = 1:length(combinedK)
        bodypart_vel = 'midbody_vel';
        movingFor = 4;
        fps = 30;
        avg = fps;
        eegFs = combinedK(kCount).fs;
           
        % One second clip buffer
        clipBuffer = eegFs;
        threshold = 0.05;
        pixel_val = combinedK(kCount).pixel_val;

        runTimes = [];
        index = 0;
        lastTrue = 0;
        normEEG = [];

        [normEEG, ~, ~, ~] = normalizeEEG(combinedK(kCount).EEG, eegFs);
 
        eeg_start = combinedK(kCount).eeg_startTimestamp;
        avgFilter = (pixel_val/avg)*ones(1,avg);
        scaledSignal = conv(avgFilter, combinedK(kCount).(bodypart_vel));
        scaledSignal = scaledSignal(ceil(length(avgFilter)/2):end-floor(length(avgFilter)/2));

        for i = clipBuffer+1:length(scaledSignal)
            if(scaledSignal(i) > threshold)
                if(lastTrue ~= i-1)
                    index = index+1;
                    runTimes(index).vidstart = i;
                    runTimes(index).vidstop = i;
                else
                    runTimes(index).vidstop = i;
                end
                lastTrue = i; 
            end
        end

        for i = 1:length(runTimes)
            runTimes(i).startTime = combinedK(kCount).vid_timestamp(runTimes(i).vidstart);
            runTimes(i).stopTime = combinedK(kCount).vid_timestamp(runTimes(i).vidstop);
            runTimes(i).totalSeconds = (runTimes(i).vidstop-runTimes(i).vidstart)/fps;
            
            startEEG = floor((runTimes(i).startTime-eeg_start)/seconds(1/eegFs));
            stopEEG = floor((runTimes(i).stopTime-eeg_start)/seconds(1/eegFs));
            startEEGIndex = startEEG-clipBuffer;
            stopEEGIndex = stopEEG+clipBuffer;
            % Set to midbody
            if(startEEGIndex > 1 && stopEEGIndex < length(normEEG))
                runTimes(i).avgVelocity = mean(combinedK(kCount).midbody_vel(runTimes(i).vidstart:runTimes(i).vidstop));
                runTimes(i).EEGclip = normEEG(startEEGIndex:stopEEGIndex);
            else
                runTimes(i).avgVelocity = 0;
                runTimes(i).EEGclip = [];
            end
        end

        if(~isempty(runTimes))
            runTimes = runTimes([runTimes.totalSeconds] > movingFor);
            runTimes = runTimes([runTimes.avgVelocity] > 0);
        end
        
        for i = 1:length(runTimes)
            runTimes(i).waveletPower = mean(mean(get_wavelet_power(runTimes(i).EEGclip, eegFs, [1 50], 6), 3),2);
        end
        
        combinedK(kCount).runTimes = runTimes;
    end
    
    K = combinedK;

    save(strcat("C:\Users\nrive\Research\AnkG\kinematicInformation\kStructure\", currentFile, ".mat"), 'K');
    fprintf('%s\n', path)
end