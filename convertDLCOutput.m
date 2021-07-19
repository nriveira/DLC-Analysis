for mouseName = ["Mouse-17", "Mouse-19"] %["Mouse-3","Mouse-4","Mouse-5","Mouse-8","Mouse-9","Mouse-10","Mouse-12","Mouse-16","Mouse-18","Mouse-19","Mouse-20","Mouse-21","Mouse-22","Mouse-23"]
    p = strcat("C:\Users\nrive\Research\AnkG\DLC_Vids\iteration2\", mouseName);
    path = dir(p);
    videoFs = 30;

    Time = [];
    Kinematics = [];
    Ts = 1/videoFs;
    index = 1;

    for file = 3:length(path)
        if(endsWith(path(file).name, '.csv'))
            mouseDesc = string(extractBefore(path(file).name, 'DLC_resnet'));
            mouseNum = str2double(extractBetween(mouseDesc, 'Mouse-', 'Day'));
            dayNum = str2double(extractBetween(mouseDesc, 'Day', 'Begin'));
            beginNum = str2double(extractBetween(mouseDesc, 'Begin', 'DV'));
            DVNum = str2double(extractAfter(mouseDesc, 'DV'));
            
            baseTime = timestamps(timestamps.Mouse==mouseNum, :);
            baseTime = baseTime(baseTime.Day==dayNum, :);
            pixel_val = baseTime(baseTime.Begin==beginNum, :).pixel_val;
            videoTime = baseTime(baseTime.Begin==beginNum, :).Video_Datetime;
            fs = baseTime(baseTime.Begin==beginNum, :).Fs;
            
            % Special Case for Mouse 20 since the cage moves
            if(mouseNum==20 && dayNum==1 && beginNum==2)
                if(DVNum < 37)
                    pixel_val = 0.051097656;
                else
                    pixel_val = 0.0714375;
                end
            end

            if(~isempty(videoTime))
                DLC = convert2mat(strcat(path(file).folder,'\',path(file).name), videoFs, DVNum, videoTime);
                nose_vel = findVelocity(DLC, 'nose', Ts);
                midbody_vel = findVelocity(DLC, 'midbody', Ts);
                baseOfTail_vel = findVelocity(DLC, 'baseOfTail', Ts);
                nose2tail = findDistanceBetween(DLC, 'nose', 'baseOfTail');
                noseMidbodyTailAngle = findAngle(DLC, 'nose', 'midbody', 'baseOfTail');
                frame = [];

%                 Time(index).mouse = mouseNum;
%                 Time(index).day = dayNum;
%                 Time(index).begin = beginNum;
%                 Time(index).DV = DVNum;
%                 Time(index).timestamp = {DLC.timestamp}';

                for i = 1:length(DLC) 
                    frame.timestamp(i) = DLC(i).timestamp;
                    frame.nose_vel(i) = nose_vel(i);
                    frame.midbody_vel(i) = midbody_vel(i);
                    frame.baseOfTail_vel(i) = baseOfTail_vel(i);
                    frame.nose2tail(i) = nose2tail(i);
                    frame.noseMidbodyTailAngle(i) = noseMidbodyTailAngle(i);
                end

                Kinematics(index).mouse = mouseNum;
                Kinematics(index).day = dayNum;
                Kinematics(index).begin = beginNum;
                Kinematics(index).DV = DVNum;        
                Kinematics(index).pixel_val = pixel_val;
                Kinematics(index).fs = fs;
                Kinematics(index).kinematics = frame;

                index = index+1;
            else
                fprintf('%s not found \n', mouseDesc);
            end
        end
    end

%     T = table2struct(sortrows(struct2table(Time), {'mouse', 'day', 'begin', 'DV'}));
%     save(strcat("C:\Users\nrive\Research\AnkG\timestampInfo\", mouseName,".mat"), 'T')
    K = table2struct(sortrows(struct2table(Kinematics), {'mouse', 'day', 'begin', 'DV'}));
    save(strcat("C:\Users\nrive\Research\AnkG\kinematicInformation\convertedDLC\", mouseName,".mat"), 'K')
    fprintf("%s finished saving. \n", mouseName)
end