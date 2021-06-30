% clear all;
% load('mouseInfo.mat')
% binningVelocity;

% figure(1)
% tiledlayout(2,3)
% for i = 1:length(mouseInfo)
% %      figure(i); clf;
%     heat = zeros(26, length(binnedInstances(i).ci));
%     for j = 1:length(binnedInstances(i).ci)
%         x = mean(binnedInstances(i).ci{1,j},2);
%         heat(:,j) = x(25:50);
%     end
%     
%     nexttile
%     h = heatmap(heat,'GridVisible','off', 'CellLabelColor','none', 'Colormap', jet);
%     h.YDisplayData = flipud(h.YDisplayData);
%     %h.ColorLimits = [0 0.11];
%     ylabels = 50:-1:25;
%     CustomYLabels = string(ylabels);
% 
% 	CustomYLabels(mod(ylabels,5) ~= 0) = " ";
%     
%     h.YDisplayLabels = CustomYLabels;
%     
%     title(strcat(mouseInfo(i).group, " spectra running speed power"))
%     xlabel('Running Speed (cm/s)')
%     ylabel('Frequency (Hz)')
% end

binsStr = ["<3 cm/s", "3+ cm/s"];
colors = ["r","g","b"];

figure(1); clf;
tiledlayout(3,1)

nexttile
hold on;
for m = 1:length(mouseInfo)
    x = 1:50;
    top = binnedInstances(m).awCI(1,:);
    bot = binnedInstances(m).awCI(2,:);
    mid = mean(binnedInstances(m).awCI);
    plot(x, mid, colors(m))
    h = patch([x fliplr(x)], [top fliplr(bot)], colors(m));
    set(h,'facealpha',.5)
end

title("Spectra for awake non-moving")
xlabel('Running Speed (cm/s)')
ylabel('Power')
legend(["","WT","","Heterozygous","","Homozygous"],'Location','best')

for i = 1:length(binsStr)
    nexttile
    hold on;
    for m = 1:length(mouseInfo)
        x = 1:50;
        top = binnedInstances(m).ci{1,i}(:,1)';
        bot = binnedInstances(m).ci{1,i}(:,2)';
        mid = mean(binnedInstances(m).ci{1,i}, 2);
        plot(x, mid, colors(m))
        h = patch([x fliplr(x)], [top fliplr(bot)], colors(m));
        set(h,'facealpha',.5)
    end
    
    title(strcat("Spectra for running speed ", binsStr(i)))
    ylim([0 0.3])
    xlabel('Running Speed (cm/s)')
    ylabel('Power')
    
    legend(["","WT","","Heterozygous","","Homozygous"])
end
