for m = 1:length(mouseInfo)
    group = mouseInfo(m).group;
    mouseName = mouseInfo(m).mouseName;
    bodypart = "midbody";

    velocityCounts = [];

    for i = 1:length(mouseName)
        load(strcat("C:\Users\nrive\Research\AnkG\kinematicInformation\kStructure\", mouseName(i)))
        t = [];
        for j = 1:length(K)
            analyzedK = distributionOfSpeed(K(j));
            velocityCounts = [velocityCounts analyzedK.velocityCounts];
            t = [t analyzedK.timeLength];
        end
        timeLength(i) = {t};
    end

    figure(1); clf
    subplot(2,1,1)
    histogram(velocityCounts)
    title(strcat(group, " Velocity (", bodypart, ")"))
    xlabel("Average Speed (cm/s)")

    subplot(2,1,2)
    timeplot = [];
    for i = 1:length(timeLength)
        timeplot = [timeplot timeLength{1,i}];
    end
    histogram(timeplot)
    title(strcat(group, " Movement Time (", bodypart, ")"))
    xlabel("Time in seconds")

    figure(2); clf
    hold on

    s = 1;
    for i = 1:length(timeLength)
        plot(timeLength{1,i}, velocityCounts(s:s+length(timeLength{1,i})-1),'.')
        s = length(timeLength{1,i});
    end

    title(strcat(group, " Velocity vs Movement Time (", bodypart, ")"))
    xlabel("Time in seconds")
    ylabel("Average Speed (cm/s)");
    legend(mouseName)
end