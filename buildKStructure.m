p = "C:\Users\nrive\Research\AnkG\kinematicInformation\combinedEEG\";

for currentFile = ["Mouse-19"] %"%"Mouse-9", "Mouse-10", "Mouse-12", "Mouse-18", "Mouse-20 (1)", "Mouse-20 (4)", "Mouse-22"]
    path = strcat(p, currentFile, ".mat");
    load(path);

    for kCount = 1:length(combinedK)
        bodypart_vel = 'nose_vel';
        window = 20;
        movingFor = 40;
        fps = 30;
        eegFs = 200;
        clipBuffer = 200;
        threshold = 1;

        runTimes = [];
        index = 0;
        lastTrue = 0;
        normEEG = [];

        for i = 1:size(combinedK(kCount).EEG,2)
            [normEEG(i, :), a, b, c] = normalizeEEG(combinedK(kCount).EEG(:,i), eegFs);
        end

        eeg_start = combinedK(kCount).eeg_startTimestamp;
        avg = fps*window;
        avgFilter = (1/avg)*ones(1,avg);
        avgSignal = conv(avgFilter, combinedK(kCount).(bodypart_vel));
        avgSignal = avgSignal(ceil(avg/2):end-floor(avg/2));

        for i = clipBuffer+1:length(avgSignal)
            if(avgSignal(i) > threshold)
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

        spectra = zeros(length(runTimes), 50);

        for i = 1:length(runTimes)
            runTimes(i).totalSeconds = (runTimes(i).vidstop-runTimes(i).vidstart)/fps;
            runTimes(i).startTime = combinedK(kCount).vid_timestamp(runTimes(i).vidstart);
            runTimes(i).stopTime = combinedK(kCount).vid_timestamp(runTimes(i).vidstop);
            startEEGIndex = floor((runTimes(i).startTime-eeg_start)/seconds(1/eegFs));
            stopEEGIndex = floor((runTimes(i).stopTime-eeg_start)/seconds(1/eegFs));

            startIndex = max(startEEGIndex-clipBuffer, 1);
            stopIndex = min(stopEEGIndex+clipBuffer, size(normEEG, 2));

            runTimes(i).EEGclip = normEEG(:, startIndex:stopIndex)';

            runTimes(i).waveletPower = mean(get_wavelet_power(runTimes(i).EEGclip, eegFs, [1 50], 6), 3);
            spectra(i,:) = mean(runTimes(i).waveletPower, 2);
        end

        runTimes = runTimes([runTimes.totalSeconds] > movingFor);
        combinedK(kCount).runTimes = runTimes;
    end    
    
    K = combinedK;

    save(path, 'K', '-v7.3');
    fprintf('%s\n', path)
end