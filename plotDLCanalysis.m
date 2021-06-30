clf;
figure(1);
tiledlayout(3,1)

for m = 1:length(mouseInfo)
    group = mouseInfo(m).group;
    mouseName = mouseInfo(m).mouseName;
    velocityTime = dlcAnalysis.(group);
    
%     figure(1); clf;
%     tiledlayout(2,2)
%     
%     nexttile(1, [1 2])
%     histogram([velocityTime.velocityCounts])
%     title(strcat(group, " Velocity (", bodypart, ")"))
%     xlabel("Average Speed (cm/s)")
% 
%     nexttile(3, [1 2])
%     histogram([velocityTime.t])
%     title(strcat(group, " Movement Time (", bodypart, ")"))
%     xlabel("Time in seconds")

    %figure(m); clf;
    nexttile
    hold on

    for i = 1:length(velocityTime)
        plot(velocityTime(i).t, velocityTime(i).velocityCounts ,'.')
        lsline
    end

    title(strcat(group, " Velocity vs Movement Time (", bodypart, ")"))
    xlim([0 1200]);
    ylim([0 60])
    xlabel("Time in seconds")
    ylabel("Average Speed (cm/s)");
    
    legendLabs = [];
    for i = 1:length(mouseName)
        legendLabs = [legendLabs, mouseName(i), ""];
    end
    legend(legendLabs);
    
    box.(group) = velocityTime.velocityCounts;
end

% https://www.mathworks.com/matlabcentral/answers/289642-multiple-boxplots-on-same-figure
A = box.WT';
B = box.Heterozygous';
C = box.Homozygous';
boxGr = [1 * ones(size(A));
         2 * ones(size(B));
         3 * ones(size(C))];

figure(2)
boxplot([A; B; C], boxGr)
title('Running Speed Distribution')
ylabel('Running Speed (cm/s)')
set(gca,'XTickLabel',{'WT','Heterozygous','Homozygous'})