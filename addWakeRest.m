kpath = "C:\Users\nrive\Research\AnkG\kinematicInformation\awakeRest\Mouse-";
buffer = 200;

for w = 77%22:length(wakeRest)
    tic
    load(strcat(kpath, num2str(wakeRest(w).mouse),'.mat'))
    
    fprintf('Now analyzing mouse %d day %d begin %d index %d\n', wakeRest(w).mouse, wakeRest(w).day, wakeRest(w).begin, w)
    currentWakeRest = wakeRest([wakeRest.mouse]==wakeRest(w).mouse);
    currentWakeRest = currentWakeRest([currentWakeRest.day]==wakeRest(w).day);
    currentWakeRest = currentWakeRest([currentWakeRest.begin]==wakeRest(w).begin);
    
    currentK = K([K.day]==wakeRest(w).day);
    currentK = currentK([currentK.begin]==wakeRest(w).begin);

    kMouse = find([K.mouse]==wakeRest(w).mouse);
    kDay = find([K.day]== wakeRest(w).day);
    kBegin = find([K.begin]== wakeRest(w).begin);
    mouseDay = intersect(kMouse, kDay);
    ind = intersect(kBegin, mouseDay);
    eegFs = K(ind).fs;

    [normEEG, ~, ~, ~] = normalizeEEG(K(ind).EEG, eegFs);

    for c = 1:length(currentWakeRest.awakeNotMovingBout)
        currentWakeRest.awakeNotMovingBout(c).startTime = currentK.vid_timestamp(currentWakeRest.awakeNotMovingBout(c).start);
        currentWakeRest.awakeNotMovingBout(c).stopTime = currentK.vid_timestamp(currentWakeRest.awakeNotMovingBout(c).stop);

        eegStart = floor((currentWakeRest.awakeNotMovingBout(c).startTime - currentK.eeg_startTimestamp)/seconds(1/eegFs));
        eegStop = floor((currentWakeRest.awakeNotMovingBout(c).stopTime - currentK.eeg_startTimestamp)/seconds(1/eegFs));

        if((eegStart-buffer > 1) && (eegStop+buffer < length(currentK.EEG)))
            currentWakeRest.awakeNotMovingBout(c).EEGclip = normEEG(eegStart-buffer:eegStop+buffer);
            currentWakeRest.awakeNotMovingBout(c).waveletPower = mean(mean(get_wavelet_power(currentWakeRest.awakeNotMovingBout(c).EEGclip, eegFs, [1 50], 6),2),3);
        end
    end
    toc
    K(ind).wakeRest = currentWakeRest.awakeNotMovingBout;
    save(strcat(kpath, num2str(wakeRest(w).mouse),'.mat'), 'K');
end
