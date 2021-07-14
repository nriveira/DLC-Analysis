mousePath = dir("C:\Users\nrive\Research\AnkG\ictalClips");
mouseIndex = 1; 
for mp = 3:length(mousePath)
    mouseStr = mousePath(mp).name;
    dayPath = dir(strcat(mousePath(mp).folder, '\', mousePath(mp).name));
    for dp = 3:length(dayPath)
        dayStr = dayPath(dp).name;
        beginPath = dir(strcat(dayPath(dp).folder, '\', dayPath(dp).name));
        for bp = 3:length(beginPath)
            beginStr = beginPath(bp).name;
            dataDir = dir(strcat(beginPath(bp).folder, '\', beginPath(bp).name));
            if(endsWith(dataDir(3).name, '.mat'))
                load(strcat(dataDir(3).folder, '\', dataDir(3).name));
                currentI = D.data;
                
                mouseInd = find(contains(convertCharsToStrings({mouse.name}), mouseStr));
                mouseEEG = mouse(mouseInd).day;
                dayInd = find(contains(convertCharsToStrings({mouseEEG.name}), dayStr));
                dayEEG = mouseEEG(dayInd).begin;
                beginInd = find(contains(convertCharsToStrings({dayEEG.name}), beginStr));
                beginEEG = dayEEG(beginInd).EEG;
                
                %verification that the seizure indices line up
                ictalClips = [];
                for i = 1:length(currentI)
                    ictalClip = beginEEG(currentI(i).seizureStart:currentI(i).seizureStop, :);
                    found = 0;
                    for j = 1:size(ictalClip,2)
                        a = ismember(currentI(i).signalClips(:,1), ictalClip(:,j));
                        startEstimate = max(floor((length(currentI(i).signalClips)/2)-(length(ictalClip)/2)),1);
                        stopEstimate = min(ceil((length(currentI(i).signalClips)/2)+(length(ictalClip)/2)), length(currentI(i).signalClips));
                        
                        expected = length(ictalClip);
                        tot = sum(a(startEstimate:stopEstimate));
                        if(tot >= length(ictalClip))
                            found = 1;
                        end
                    end
                    if(found == 0 && currentI(i).seizureDuration < 2049)
                        fprintf('%s\\%s, %d\n', dataDir(3).folder, dataDir(3).name, currentI(i).seizureDuration)
                    end
                    ictalClips(i).clip = ictalClip;
                    ictalClips(i).startIndex = currentI(i).seizureStart;
                    ictalClips(i).stopIndex = currentI(i).seizureStop;
                    ictalClips(i).seizureDuration = currentI(i).seizureDuration;
                end
                I(mouseIndex).mouse = mouseStr;
                I(mouseIndex).day = dayStr;
                I(mouseIndex).begin = beginStr;
                I(mouseIndex).ictalClips = ictalClips;
                mouseIndex = mouseIndex+1;
            end
        end
    end
end

I = table2struct(sortrows(struct2table(I), {'mouse', 'day', 'begin'}));