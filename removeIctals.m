% to pull out seizures
load("C:\Users\nrive\Research\DLC-Code\ictalClips\allIctalClips.mat")
kDir = dir("C:\Users\nrive\Research\AnkG\kinematicInformation\awakeRest");

% Cycle through each K data structure per mouse
for i = 3:length(kDir)
    load(strcat(kDir(i).folder,'\', kDir(i).name));
    for k = 1:length(K)
        mouseName = strcat('Mouse', num2str(K(k).mouse));
        dayName = strcat('Day', num2str(K(k).day));
        beginName = strcat('Begin', num2str(K(k).begin));
        
        % Per K data structure, find the corresponding I data structure
        for ictalidx = 1:length(I)
            if isequal(mouseName,I(ictalidx).mouse)
                if isequal(dayName,I(ictalidx).day)
                    if isequal(beginName,I(ictalidx).begin)
                        
                        % After matching the K and I data structures, cycle
                        % through each awakeRest and runTimes to take out
                        % any seizures.
                        ictalSigs = {I(ictalidx).ictalClips(:).clip}.';
                        for ictalSigIndex = 1:length(ictalSigs)
                            for eegIndex = 1:length(K(k).runTimes)
                                eegSig = K(k).runTimes(eegIndex).EEGclip;
                                if(~isempty(eegSig))
                                    seizureEvent = ictalSigs{ictalSigIndex,1};
                                    seizureEvent = seizureEvent(:,1);
                                    if(length(seizureEvent) > 1)
                                        thresh = floor(length(seizureEvent)/2);
                                        seizureEvent1 = seizureEvent(1:thresh);
                                        seizureEvent2 = seizureEvent(thresh: end);

                                        ictalLocs = strfind(eegSig(:,1).',seizureEvent1.');
                                        eegSig(ictalLocs:(ictalLocs+length(seizureEvent1)-1),:) = [];
                                        ictalLocs = strfind(eegSig(:,1).',seizureEvent2.');
                                        eegSig(ictalLocs:(ictalLocs+length(seizureEvent2)-1),:) = [];

                                        K(k).runTimes(eegIndex).EEGclipNoI = eegSig;

                                        if(length(K(k).runTimes(eegIndex).EEGclipNoI) < length(K(k).runTimes(eegIndex).EEGclip))
                                            fprintf('Seizure Found: %s %s %s', mouseName, dayName, beginName)
                                        end
                                    end
                                end
                            end
                            
                            for eegIndex = 1:length(K(k).wakeRest)
                                eegSig = K(k).wakeRest(eegIndex).EEGclip';
                                if(~isempty(eegSig))
                                    seizureEvent = ictalSigs{ictalSigIndex,1};
                                    seizureEvent = seizureEvent(:,1);
                                    if(length(seizureEvent) > 1)
                                        thresh = floor(length(seizureEvent)/2);
                                        seizureEvent1 = seizureEvent(1:thresh);
                                        seizureEvent2 = seizureEvent(thresh: end);

                                        ictalLocs = strfind(eegSig(:,1).',seizureEvent1.');
                                        eegSig(ictalLocs:(ictalLocs+length(seizureEvent1)-1),:) = [];
                                        ictalLocs = strfind(eegSig(:,1).',seizureEvent2.');
                                        eegSig(ictalLocs:(ictalLocs+length(seizureEvent2)-1),:) = [];

                                        K(k).wakeRest(eegIndex).EEGclipNoI = eegSig;
                                        if(length(K(k).wakeRest(eegIndex).EEGclipNoI) < length(K(k).wakeRest(eegIndex).EEGclip))
                                            fprintf('Seizure Found: %s %s %s', mouseName, dayName, beginName)
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
end