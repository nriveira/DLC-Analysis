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
tiledlayout(3,3)

for m = 1:length(mouseInfo)
    nexttile
    hold on;
    for n = 1:length(mouseInfo(m).mouseName)
        current = binnedInstances(m).awCI{n,1};
        x = 1:50;
        top = current(1,:);
        bot = current(2,:);
        mid = mean(current);
        plot(x, mid, colors(m))
        h = patch([x fliplr(x)], [top fliplr(bot)], colors(m));
        set(h,'facealpha',.5)
        title(strcat("Spectra for ", group, "awake rest"))
        ylim([0, 0.12])
        xlabel('Frequency (Hz)')
        ylabel('Power')
    end
end    

desc = [" <3 cm/s", "3+ cm/s"];
for i = 1:2
    for m = 1:length(mouseInfo)
        nexttile
        hold on;
        for n = 1:length(mouseInfo(m).mouseName)
            current = binnedInstances(m).velCI{i,n};
            x = 1:50;
            top = current(1,:);
            bot = current(2,:);
            mid = mean(current);
            plot(x, mid, colors(m))
            h = patch([x fliplr(x)], [top fliplr(bot)], colors(m));
            set(h,'facealpha',.5)
            title(strcat("Spectra for ", group, desc(i)))
            ylim([0, 0.55])
            xlabel('Frequency (Hz)')
            ylabel('Power')
        end
    end
end
hold off;
