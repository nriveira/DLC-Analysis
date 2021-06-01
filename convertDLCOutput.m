for mouseName = ["Mouse-12", "Mouse-20", "Mouse-22", "Mouse-23"]
    p = strcat("C:\Users\nrive\Research\AnkG\DLC_Vids\iteration1\fourCageVidsTACC\", mouseName);

% for mouseName = ["Mouse-18", "Mouse-20"] "Mouse-3", "Mouse-4", "Mouse-5", 
%     p = strcat("C:\Users\nrive\Research\AnkG\DLC_Vids\iteration1\oneCageVidsTACC\", mouseName);
    path = dir(p);
    videoFs = 30;

    Time = [];
    Kinematics = [];
    Ts = 1/videoFs;
    index = 1;

    for file = 3:length(path)
        if(endsWith(path(file).name, '.csv'))
            mouseDesc = extractBefore(path(file).name, 'DLC_resnet');
            mouse = str2double(extractBetween(mouseDesc, 'Mouse-', 'Day'));
            day = str2double(extractBetween(mouseDesc, 'Day', 'Begin'));
            begin = str2double(extractBetween(mouseDesc, 'Begin', 'DV'));
            DV = str2double(extractAfter(mouseDesc, 'DV'));

            baseTime = timestamps(timestamps.Mouse==mouse, :);
            baseTime = baseTime(baseTime.Day==day, :);
            baseTime = baseTime(baseTime.Begin==begin, :).Datetime;

            if(~isempty(baseTime))
                DLC = convert2mat(strcat(path(file).folder, '\',path(file).name), videoFs, DV, baseTime);
                nose_vel = findVelocity(DLC, 5, 'nose', 30);
                midbody_vel = findVelocity(DLC, 5, 'midbody', 30);
                baseOfTail_vel = findVelocity(DLC, 5, 'baseOfTail', 30);
                nose2tail = findDistanceBetween(DLC, 'nose', 'baseOfTail');
                noseMidbodyTailAngle = findAngle(DLC, 'nose', 'midbody', 'baseOfTail');

                Time(index).mouse = mouse;
                Time(index).day = day;
                Time(index).begin = begin;
                Time(index).DV = DV;
                Time(index).timestamp = {DLC.timestamp}';

                for i = 1:length(DLC) 
                    frame.timestamp(i) = DLC(i).timestamp;
                    frame.nose_vel(i) = nose_vel(i);
                    frame.midbody_vel(i) = midbody_vel(i);
                    frame.baseOfTail_vel(i) = baseOfTail_vel(i);
                    frame.nose2tail(i) = nose2tail(i);
                    frame.noseMidbodyTailAngle(i) = noseMidbodyTailAngle(i);
                end

                Kinematics(index).mouse = mouse;
                Kinematics(index).day = day;
                Kinematics(index).begin = begin;
                Kinematics(index).DV = DV;                
                Kinematics(index).timestamp = {DLC.timestamp}';
                Kinematics(index).kinematics = frame;

                frame = [];
                index = index+1;
            else
                fprintf('%s not found \n', mouseDesc);
            end
        end
    end

    T = table2struct(sortrows(struct2table(Time), {'mouse', 'day', 'begin', 'DV'}));
    K = table2struct(sortrows(struct2table(Kinematics), {'mouse', 'day', 'begin', 'DV'}));

    save(strcat("C:\Users\nrive\Research\AnkG\timestampInfo\fourCage\", mouseName,".mat"), 'T')
    save(strcat("C:\Users\nrive\Research\AnkG\kinematicInformation\fourCage\", mouseName,".mat"), 'K')
    fprintf("%s finished saving. \n", mouseName)
end