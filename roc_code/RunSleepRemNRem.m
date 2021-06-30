%% Loading Data
load allIctalClips.mat
load mouse.mat
load timestamps.mat
timestamps = table2struct(timestamps);
WT_flag = 0;
%miceList = {mouse(:).name};
%miceGen = {'1','1','1','2','2','2','2','3','3','3','3','3','1'};
miceList = {'Mouse3','Mouse4','Mouse5','Mouse23'};
miceGen = {'1','1','1','1'};
fps = 30;
fs = 200;
minDur = (95-36)/1000; %based on a paper - send to Angel
%min dur cycle ~10min in rodents
% Ask about theta/delta ratio - paper?
% look at Ernie's paper for REM/NREM
% increases naturally in fast gamma (ripples) during sleep, ripples in REM
% and NREM?
% sleep spindles the harmonic may makes sense
% look at percentage of time per each stage of sleep, could be that KOs are
% spending more time in NREM. Collapse theta and look at amount of theta
% across genotypes, and slow gamma across genotypes for comparison.
% Boxplots. I could also do delta (1-4) for the boxplots.
% verify seizures are cut out.
dirCt = 1; 
%% Converting Sleep/non-Sleep timestamps and extracting EEG/Spectra
for miceidx = 1:length(miceList)
    dirMouse = strcat('C:\Users\evp02\Documents\MATLAB\DLC_Vids\DLC_Vids\',miceList(miceidx));
    mouseName = char(miceList(miceidx));
    mouseNum = mouseName(6:end);
    if isfolder(dirMouse)
        for dayidx = 1:length(mouse(miceidx).day)
            dirDay = strcat(dirMouse,'\',mouse(miceidx).day(dayidx).name);
            dayName = char(mouse(miceidx).day(dayidx).name);
            dayNum = dayName(4:end);
            if isfolder(dirDay)
                for beginidx = 1:length(mouse(miceidx).day(dayidx).begin)
                    dirBegin = strcat(dirDay,'\',mouse(miceidx).day(dayidx).begin(beginidx).name);
                    beginName = char(mouse(miceidx).day(dayidx).begin(beginidx).name);
                    beginNum = beginName(6:end);
                    if isfolder(dirBegin)
                        cd(char(dirBegin))
                        load sleepAwakeMice.mat;
                        classData = mouseClass.classified;
                        clearvars sleepAwakeMice.mat;
                        for timeidx = 1:length(timestamps)
                            if isequal(mouseNum,num2str(timestamps(timeidx).Mouse))
                                if isequal(dayNum,num2str(timestamps(timeidx).Day))
                                    if isequal(beginNum,num2str(timestamps(timeidx).Begin))
                                        vidStart = char(timestamps(timeidx).video_initialTimeStamp);
                                        eegStart = char(timestamps(timeidx).EEG_InitialTimeStamp);
                                        eegSig = mouse(miceidx).day(dayidx).begin(beginidx).EEG(:,1);
                                    end
                                end
                            end
                        end
                        if (isequal(miceGen{miceidx},'1') == 0)
                            for ictalidx = 1:length(I)
                                if isequal(mouseName,I(ictalidx).mouse)
                                    if isequal(dayName,I(ictalidx).day)
                                        if isequal(beginName,I(ictalidx).begin)
                                            ictalSigs = {I(ictalidx).ictalClips(:).clip}.';
                                            if isequal(length(vidStart),12)
                                                if isequal(length(eegStart),12)
                                                    if sum(classData) ~= 0
                                                    WT_flag = 0;
                                                    cd ../../../../..
                                                    [sleepPhasesEEG] = extract_sleep_rem_nrem(vidStart,eegStart,eegSig,ictalSigs,classData,fps,fs,minDur,WT_flag);
                                                    cd(char(dirBegin))
                                                    save sleepPhasesEEG.mat sleepPhasesEEG
                                                    sleepPhasesDirList{dirCt} = {dirBegin};
                                                    miceIDs{dirCt} = {mouseName};
                                                    dirCt = dirCt + 1;
                                                    clearvars sleepPhasesEEG
                                                    cd ../../../../..
                                                    end
                                                end
                                            end                                        
                                        end
                                    end
                                end
                            end
                        else
                            if isequal(length(vidStart),12)
                               if isequal(length(eegStart),12)
                                  if sum(classData) ~= 0
                                    WT_flag = 1;
                                    ictalSigs = [];
                                    cd ../../../../..
                                    [sleepPhasesEEG] = extract_sleep_rem_nrem(vidStart,eegStart,eegSig,ictalSigs,classData,fps,fs,minDur,WT_flag);
                                    cd(char(dirBegin))
                                    save sleepPhasesEEG.mat sleepPhasesEEG
                                    sleepPhasesDirList{dirCt} = {dirBegin};
                                    miceIDs{dirCt} = {mouseName};
                                    dirCt = dirCt + 1;
                                    clearvars sleepPhasesEEG
                                    cd ../../../../..
                                  end
                               end
                            end
                        end
                    end
                end
            end
        end
    end
end
