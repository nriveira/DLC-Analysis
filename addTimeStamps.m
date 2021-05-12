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

        M(index).DLC = convert2mat(strcat(path(file).folder, '\',path(file).name), videoFs, M(index).DV);
    end
end

sortedM = table2struct(sortrows(struct2table(M), {'mouse', 'day', 'begin', 'DV'}));

for m = 1:length(sortedM)
    nose_vel = findVelocity(sortedM(m).DLC, 5, 'nose');
    
    figure(1);
    subplot(3,1,1)
    t = (1:length(vel)*Ts);
    plot(vel); xlabel('Time (s)'); ylabel('Velocity (pixels/frame)')

    subplot(3,1,2)
    plot(conf); xlabel('Time (s)'); ylabel('Confidence %')

    subplot(3,1,3)
    confVel = (vel).*conf;
    plot(confVel); xlabel('Time (s)'); ylabel('Velocity (pixels/frame)')
 end