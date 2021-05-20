path = dir("C:\Users\nrive\Research\AnkG\DLC_Vids\iteration1\oneCageVidsAnalyzed");
videoFs = 30;
Ts = 1/videoFs;
index = 0;

for file = 3:length(path)
    if(endsWith(path(file).name, 'filtered.csv'))
        index = index+1;
        mouseDesc = extractBefore(path(file).name, 'DLC_resnet');
        M(index).mouse = str2double(extractBetween(mouseDesc, 'Mouse-', 'Day'));
        M(index).day = str2double(extractBetween(mouseDesc, 'Day', 'Begin'));
        M(index).begin = str2double(extractBetween(mouseDesc, 'Begin', 'DV'));
        M(index).DV = str2double(extractAfter(mouseDesc, 'DV'));
        M(index).desc = mouseDesc;

        M(index).DLC = convert2mat(strcat(path(file).folder, '\',path(file).name), videoFs, M(index).DV);
    end
end

sortedM = table2struct(sortrows(struct2table(M), {'mouse', 'day', 'begin', 'DV'}));

for m = 1:length(sortedM)
    nose_vel = findVelocity(sortedM(m).DLC, 5, 'nose', 30);
    nose2tail = findDistanceBetween(sortedM(m).DLC, 'nose', 'baseOfTail');
    noseMidbodyTailAngle = findAngle(sortedM(m).DLC, 'nose', 'midbody', 'baseOfTail');
    
    figure(1);
    t = (1:length(nose_vel)).*Ts;
    
    subplot(3,1,1)
    plot(t, nose_vel); xlabel('Time (s)'); ylabel('Velocity (pixels/frame)'); title(sortedM(m).desc);

    subplot(3,1,2)
    plot(t, nose2tail); xlabel('Time (s)'); ylabel('Distance (pixels)'); title(sortedM(m).desc);

    subplot(3,1,3)
    plot(t, noseMidbodyTailAngle); xlabel('Time (s)'); ylabel('Angle (rad)'); title(sortedM(m).desc);
 end