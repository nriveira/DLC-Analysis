for m = 1:length(mouseInfo)
    group = mouseInfo(m).group;
    mouseName = mouseInfo(m).mouseName;
    bodypart = "midbody";
    velocityTime = [];

    for i = 1:length(mouseName)
        if(mouseName(i) ~= "Mouse-19")
            load(strcat("C:\Users\nrive\Research\AnkG\kinematicInformation\awakeRest\", mouseName(i)))
            for j = 1:length(K)
                [velocityTime(i).velocityCounts, velocityTime(i).t] = distributionOfSpeed(K);
            end
        end
    end
    dlcAnalysis.(group) = velocityTime;
end

function [velocityCounts, timeLength] = distributionOfSpeed(K)
    velocityCounts = [];
    timeLength = [];
    for k = 1:length(K)
        for clip = 1:length(K(k).runTimes)
            velocityCounts = [velocityCounts mean(K(k).midbody_vel(K(k).runTimes(clip).vidstart:K(k).runTimes(clip).vidstop))];
            timeLength = [timeLength K(k).runTimes(clip).totalSeconds];
        end
    end
end