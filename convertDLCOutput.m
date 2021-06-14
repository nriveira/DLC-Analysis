for mouseName = ["Mouse-3", "Mouse-4", "Mouse-12", "Mouse-20", "Mouse-22"]
    p = strcat("C:\Users\nrive\Research\AnkG\DLC_Vids\iteration1\fourCageVidsTACC\", mouseName);
    timestamps.pixel_val(74) = 0.0714375;

% for mouseName = ["Mouse-8", "Mouse-9", "Mouse-10", "Mouse-18", "Mouse-19", "Mouse-20"]
%     p = strcat("C:\Users\nrive\Research\AnkG\DLC_Vids\iteration1\oneCageVidsTACC\", mouseName);
%     timestamps.pixel_val(74) = 0.051097656;
    path = dir(p);
    videoFs = 30;

    Time = [];
    Kinematics = [];
    Ts = 1/videoFs;
    index = 1;

    for file = 3:length(path)
        if(endsWith(path(file).name, '.csv'))
            mouseDesc = extractBefore(path(file).name, 'DLC_resnet');
            mouseStr = str2double(extractBetween(mouseDesc, 'Mouse-', 'Day'));
            dayStr = str2double(extractBetween(mouseDesc, 'Day', 'Begin'));
            beginStr = str2double(extractBetween(mouseDesc, 'Begin', 'DV'));
            DVStr = str2double(extractAfter(mouseDesc, 'DV'));

            baseTime = timestamps(timestamps.Mouse==mouseStr, :);
            baseTime = baseTime(baseTime.Day==dayStr, :);
            pixel_val = baseTime(baseTime.Begin==beginStr, :).pixel_val;
            baseTime = baseTime(baseTime.Begin==beginStr, :).Datetime;

            if(~isempty(baseTime))
                DLC = convert2mat(strcat(path(file).folder,'\',path(file).name), videoFs, DVStr, baseTime);
                nose_vel = findVelocity(DLC, 'nose', Ts);
                midbody_vel = findVelocity(DLC, 'midbody', Ts);
                baseOfTail_vel = findVelocity(DLC, 'baseOfTail', Ts);
                nose2tail = findDistanceBetween(DLC, 'nose', 'baseOfTail');
                noseMidbodyTailAngle = findAngle(DLC, 'nose', 'midbody', 'baseOfTail');

%                 Time(index).mouse = mouseStr;
%                 Time(index).day = dayStr;
%                 Time(index).begin = beginStr;
%                 Time(index).DV = DVStr;
%                 Time(index).timestamp = {DLC.timestamp}';

                for i = 1:length(DLC) 
                    frame.timestamp(i) = DLC(i).timestamp;
                    frame.nose_vel(i) = nose_vel(i);
                    frame.midbody_vel(i) = midbody_vel(i);
                    frame.baseOfTail_vel(i) = baseOfTail_vel(i);
                    frame.nose2tail(i) = nose2tail(i);
                    frame.noseMidbodyTailAngle(i) = noseMidbodyTailAngle(i);
                end

                Kinematics(index).mouse = mouseStr;
                Kinematics(index).day = dayStr;
                Kinematics(index).begin = beginStr;
                Kinematics(index).DV = DVStr;        
                Kinematics(index).pixel_val = pixel_val;
                Kinematics(index).kinematics = frame;

                frame = [];
                index = index+1;
            else
                fprintf('%s not found \n', mouseDesc);
            end
        end
    end

%     T = table2struct(sortrows(struct2table(Time), {'mouse', 'day', 'begin', 'DV'}));
    K = table2struct(sortrows(struct2table(Kinematics), {'mouse', 'day', 'begin', 'DV'}));

%     save(strcat("C:\Users\nrive\Research\AnkG\timestampInfo\", mouseName,".mat"), 'T')
    save(strcat("C:\Users\nrive\Research\AnkG\kinematicInformation\convertedDLC\", mouseName,".mat"), 'K')
    fprintf("%s finished saving. \n", mouseName)
end