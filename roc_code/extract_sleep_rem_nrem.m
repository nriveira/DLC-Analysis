function [sleepPhasesEEG] = extract_sleep_rem_nrem(vidStart,eegStart,eegSig,ictalSigs,classData,fps,fs,minDur,WT_flag)
%% Interpolating classifier data
    v = classData;
    x = 1:length(classData);
    xq = 1:(fps/fs):length(classData);
    interpolated_classData = interp1(x,v,xq).';
%% Aligning video and EEG data
    hhVid = str2double(vidStart(1:2)); hhEEG = str2double(eegStart(1:2));
    mmVid = str2double(vidStart(4:5)); mmEEG = str2double(eegStart(4:5));
    ssVid = str2double(vidStart(7:8)); ssEEG = str2double(eegStart(7:8));
    msmsVid = str2double(vidStart(10:12)); msmsEEG = str2double(eegStart(10:12));
    vidVal = (hhVid*60*60 + mmVid*60 + ssVid + msmsVid/1000)*fs;
    eegVal = (hhEEG*60*60 + mmEEG*60 +ssEEG + msmsEEG/1000)*fs;
    valDif = round(abs(vidVal - eegVal));
    temp1 = eegSig;
    temp2 = interpolated_classData;
    if vidVal > eegVal
        eegSig(1:valDif,:) = [];
    end
    if eegVal > vidVal
        interpolated_classData(1:valDif) = [];
    end
    if length(interpolated_classData) > length(eegSig)
        interpolated_classData = interpolated_classData(1:length(eegSig));
    end
    if length(eegSig) > length(interpolated_classData)
        eegSig = eegSig(1:length(interpolated_classData),:);
    end
%% Removing seizure signals/bouts
if WT_flag == 0
    for ictalidx = 1:length(ictalSigs)
        seizureEvent = ictalSigs{ictalidx,1};
        seizureEvent = seizureEvent(:,1);
        ictalLocs = strfind(eegSig.',seizureEvent.');
        eegSig(ictalLocs:(ictalLocs+length(seizureEvent)-1)) = [];
        interpolated_classData(ictalLocs:(ictalLocs+length(seizureEvent)-1)) = [];
    end
end
%% Evaluating REM and NREM Sleep
sleepEEG = eegSig.*interpolated_classData;
sleepEEG(sleepEEG == 0) = [];
[remEdgeInds, nremEdgeInds] = find_rem_and_nrem_bouts(sleepEEG, fs, minDur);
for remidx = 1:length(remEdgeInds)
    remEEG = sleepEEG(remEdgeInds(remidx,1):remEdgeInds(remidx,2));
    sleepPhasesEEG.REM(remidx).data = remEEG;
    remEEG = lowpass(remEEG,50,fs);
    [remEEG,~,~,~] = normalizeEEG(remEEG,fs);
    remSpectra = get_wavelet_power(remEEG, fs, [1,50], 6, 0, 0);
    sleepPhasesEEG.REM(remidx).spectra = remSpectra;
end
for nremidx = 1:length(nremEdgeInds)
    nremEEG = sleepEEG(nremEdgeInds(nremidx,1):nremEdgeInds(nremidx,2));
    sleepPhasesEEG.NREM(nremidx).data = nremEEG;
    nremEEG = lowpass(nremEEG,50,fs);
    [nremEEG,~,~,~] = normalizeEEG(nremEEG,fs);
    nremSpectra = get_wavelet_power(nremEEG, fs, [1,50], 6, 0, 0);
    sleepPhasesEEG.NREM(nremidx).spectra = nremSpectra;
end
sleepPhasesEEG.AllSleep.data = sleepEEG;
sleepEEG = lowpass(sleepEEG,50,fs);
[sleepEEG,~,~,~] = normalizeEEG(sleepEEG,fs);
sleepSpectra = get_wavelet_power(sleepEEG, fs, [1,50], 6, 0, 0);
sleepPhasesEEG.AllSleep.spectra = sleepSpectra;
end

    
