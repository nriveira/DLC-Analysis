path = dir("C:\Users\nrive\Research\AnkG\classifiedMouse");
wakeRest = [];
minLength = 4;

index = 1;
for m = 3:length(path)
    mouseNum = str2double(extractAfter(path(m).name, 'Mouse'));
    dayDir = dir(strcat(path(m).folder,'/',path(m).name));
    for d = 3:length(dayDir)
        dayNum =  str2double(extractAfter(dayDir(d).name, 'Day'));
        beginDir = dir(strcat(dayDir(d).folder,'/',dayDir(d).name));
        for b = 3:length(beginDir)
            beginNum =  str2double(extractAfter(beginDir(b).name, 'Begin'));
            fileDir = dir(strcat(beginDir(b).folder,'/',beginDir(b).name));
            
            for f = 3:length(fileDir)
                load(strcat(fileDir(f).folder,'/',fileDir(f).name))
            end
            
            fprintf('Mouse%d Day%d Begin%d\n', mouseNum, dayNum, beginNum);
            wakeRest(index).mouse = mouseNum;
            wakeRest(index).day = dayNum;
            wakeRest(index).begin = beginNum;
                       
            ANM = [];
            anmIndex = 0;
            previousOne = length(mouseAwakeNonMoving.data);
            
            for i = 1:length(mouseAwakeNonMoving.data)
                if(mouseAwakeNonMoving.data(i)==1)
                    if(previousOne ~= i-1)
                        anmIndex = anmIndex+1;
                        ANM(anmIndex).start = i;
                        ANM(anmIndex).stop = i;
                    else
                        ANM(anmIndex).stop = i+1;
                    end
                    ANM(anmIndex).totalSeconds = (ANM(anmIndex).stop - ANM(anmIndex).start)/30;
                    previousOne = i;
                end
            end
            ANM = ANM([ANM.totalSeconds] > minLength);
            wakeRest(index).awakeNotMovingBout = ANM;            
            
            index = index+1;
        end
    end
end

wakeRest = table2struct(sortrows(struct2table(wakeRest), {'mouse', 'day', 'begin'}));
