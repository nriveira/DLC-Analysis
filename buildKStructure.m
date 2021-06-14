for currentFile = ["Mouse-9", "Mouse-10", "Mouse-12", "Mouse-18", "Mouse-19" "Mouse-20", "Mouse-22"] %"Mouse-3", "Mouse-4", "Mouse-8", 
    path = strcat("C:\Users\nrive\Research\AnkG\kinematicInformation\combinedEEG\", currentFile, ".mat");
    load(path);

    for kCount = 1:length(combinedK)
        bodypart_vel = 'midbody_vel';
        movingFor = 1;
        fps = 30;
        
        if((combinedK(kCount).mouse==18) && ((combinedK(kCount).day==1) | (combinedK(kCount).day==2)))
            eegFs = 250;
        else
            eegFs = 200;
        end
            
        clipBuffer = 200;
        threshold = 0.05;
        pixel_val = combinedK(kCount).pixel_val;

        runTimes = [];
        index = 0;
        lastTrue = 0;
        normEEG = [];
        
        i = 1;
        while(i <= size(combinedK(kCount).EEG,2))
            if(sum(combinedK(kCount).EEG(:,i))==0)
                combinedK(kCount).EEG(:,i) = [];
            else
                i=i+1;
            end
        end

        for i = 1:size(combinedK(kCount).EEG,2)
            [normEEG(i, :), ~, ~, ~] = normalizeEEG(combinedK(kCount).EEG(:,i), eegFs);
        end
 
        eeg_start = combinedK(kCount).eeg_startTimestamp;
%         avgFilter = (pixel_val/avg)*ones(1,avg);
%         avgSignal = conv(avgFilter, combinedK(kCount).(bodypart_vel));
%         avgSignal = avgSignal(ceil(avg/2):end-floor(avg/2));
        scaledSig = pixel_val*combinedK(kCount).(bodypart_vel);

        for i = clipBuffer+1:length(scaledSig)
            if(scaledSig(i) > threshold)
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
            runTimes(i).avgVelocity = mean(combinedK(kCount).midbody_vel(:,runTimes(i).vidstart:runTimes(i).vidstop));
            
            startEEG = floor((runTimes(i).startTime-eeg_start)/seconds(1/eegFs));
            stopEEG = floor((runTimes(i).stopTime-eeg_start)/seconds(1/eegFs));
            startEEGIndex = max(startEEG-clipBuffer, 1);
            stopEEGIndex = min(stopEEG+clipBuffer, size(normEEG, 2));
            
            % Set to midbody
            runTimes(i).avgVelocity = mean(combinedK(kCount).midbody_vel(1,runTimes(i).vidstart:runTimes(i).vidstop));
            runTimes(i).EEGclip = normEEG(:, startEEGIndex:stopEEGIndex)';
        end

        if(~isempty(runTimes))
            runTimes = runTimes([runTimes.totalSeconds] > movingFor);
        end
        
        i=1;
        while(i < length(runTimes))
            if(isempty(runTimes(i).EEGclip))
                runTimes(i) = [];
            else
                i=i+1;
            end
        end
        
        for i = 1:length(runTimes)
            runTimes(i).waveletPower = mean(mean(get_wavelet_power(runTimes(i).EEGclip, eegFs, [1 50], 6), 3),2);
        end
        
        combinedK(kCount).runTimes = runTimes;
    end    
    
    K = combinedK;

    save(strcat("C:\Users\nrive\Research\AnkG\kinematicInformation\kStructure\", currentFile, ".mat"), 'K', '-v7.3');
    fprintf('%s\n', path)
end