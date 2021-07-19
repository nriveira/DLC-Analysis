p = "C:\Users\nrive\Research\AnkG\kinematicInformation\convertedDLC\";

for mice = ["Mouse-17", "Mouse-19"] %["Mouse-3","Mouse-4","Mouse-5","Mouse-8","Mouse-9","Mouse-10","Mouse-12","Mouse-16","Mouse-18","Mouse-19","Mouse-20","Mouse-21","Mouse-22","Mouse-23"]
    path = strcat(p, mice, ".mat");
    load(path)
    currentDay = 0;
    currentBegin = 0;
    index = 0;
    combinedK = [];

    for i = 1:length(K)
        if(K(i).day ~= currentDay || K(i).begin ~= currentBegin)
            index = index+1; 
            combinedK(index).mouse = K(i).mouse;
            combinedK(index).day = K(i).day;
            combinedK(index).begin = K(i).begin;
            combinedK(index).pixel_val = K(i).pixel_val;
            combinedK(index).fs = K(i).fs;

            combinedK(index).vid_timestamp = K(i).kinematics.timestamp;
            combinedK(index).nose_vel = K(i).kinematics.nose_vel;
            combinedK(index).midbody_vel = K(i).kinematics.midbody_vel;
            combinedK(index).baseOfTail_vel = K(i).kinematics.baseOfTail_vel;
            combinedK(index).nose2tail = K(i).kinematics.nose2tail;
            combinedK(index).noseMidbodyTailAngle = K(i).kinematics.noseMidbodyTailAngle;

        else
            combinedK(index).vid_timestamp = [combinedK(index).vid_timestamp K(i).kinematics.timestamp];
            combinedK(index).nose_vel = [combinedK(index).nose_vel K(i).kinematics.nose_vel];
            combinedK(index).midbody_vel = [combinedK(index).midbody_vel K(i).kinematics.midbody_vel];
            combinedK(index).baseOfTail_vel = [combinedK(index).baseOfTail_vel K(i).kinematics.baseOfTail_vel];
            combinedK(index).nose2tail = [combinedK(index).nose2tail K(i).kinematics.nose2tail];
            combinedK(index).noseMidbodyTailAngle = [combinedK(index).noseMidbodyTailAngle K(i).kinematics.noseMidbodyTailAngle];
        end

        currentDay = K(i).day;
        currentBegin = K(i).begin;
    end

    for i = 1:length(combinedK)
        mouseEEG = mouse(strcmp({mouse.name}, strcat('Mouse', num2str(combinedK(i).mouse))));
        dayEEG = mouseEEG.day(strcmp({mouseEEG.day.name}, strcat('Day', num2str(combinedK(i).day))));
        beginEEG = dayEEG.begin(strcmp({dayEEG.begin.name}, strcat('Begin', num2str(combinedK(i).begin))));

        combinedK(i).EEG = beginEEG.EEG(:,1);
        t = timestamps(timestamps.Mouse==combinedK(i).mouse, :);
        t = t(t.Day==combinedK(i).day, :);
        t = t(t.Begin==combinedK(i).begin, :);
        combinedK(i).eeg_startTimestamp = t.EEG_Datetime;
        combinedK(i).vid_timestamp = combinedK(i).vid_timestamp';
        combinedK(i).nose_vel = combinedK(i).nose_vel'; 
        combinedK(i).midbody_vel = combinedK(i).midbody_vel';
        combinedK(i).baseOfTail_vel = combinedK(i).baseOfTail_vel';
        combinedK(i).nose2tail = combinedK(i).nose2tail';
        combinedK(i).noseMidbodyTailAngle = combinedK(i).noseMidbodyTailAngle';
    end

    save(strcat("C:\Users\nrive\Research\AnkG\kinematicInformation\combinedEEG\", mice, '.mat'), 'combinedK')
    fprintf("%s finished saving. \n", mice)
end