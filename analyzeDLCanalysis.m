mouseInfo(1).group = "WT";
mouseInfo(1).mouseName = ["Mouse-3","Mouse-4","Mouse-5"];
mouseInfo(1).color = 'r';

mouseInfo(2).group = "Heterozygous";
mouseInfo(2).mouseName = ["Mouse-8","Mouse-9","Mouse-10","Mouse-12"];
mouseInfo(2).color = 'g';

mouseInfo(3).group = "Homozygous";
mouseInfo(3).mouseName = ["Mouse-16","Mouse-17","Mouse-18","Mouse-20","Mouse-20","Mouse-22","Mouse-23"];

for m = 1:length(mouseInfo)
    group = mouseInfo(m).group;
    mouseName = mouseInfo(m).mouseName;
    bodypart = "midbody";
    velocityTime = [];

    for i = 1:length(mouseName)
        load(strcat("C:\Users\nrive\Research\AnkG\kinematicInformation\awakeRest\", mouseName(i)))
        for j = 1:length(K)
            [velocityTime(i).velocityCounts, velocityTime(i).t] = distributionOfSpeed(K);
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