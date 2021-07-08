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
%% Plotting Individual
binsStr = [" <3 cm/s", " 3+ cm/s"];
colors = ["r","g","b"];
ind = 1;

figure(1); clf;
tiledlayout(3,3)

for m = 1:length(mouseInfo)
    meanMid = [];
    nexttile
    hold on;
    for n = 1:length(mouseInfo(m).mouseName)
        current = binnedInstances(m).awCI{n,1};
        x = 1:50;
        top = current(1,:);
        bot = current(2,:);
        mid = mean(current);
        if(n==1)
            variance(:,m) = bot-mid;
        else
            variance(:,m) = variance(:,m)+(bot-mid)';
        end
        meanMid(:,n) = mid;
        
        plot(x, mid, colors(m))
        h = patch([x fliplr(x)], [top fliplr(bot)], colors(m));
        set(h,'facealpha',.5)
        title(strcat("Spectra for ", group, "awake rest"))
        ylim([0, 0.12])
        xlabel('Frequency (Hz)')
        ylabel('Power')
    end
    combinedMid(:,ind) = mean(meanMid,2);
    combinedVar(:,ind) = variance(:,m);
    ind=ind+1;
end    

desc = [" <3 cm/s", "3+ cm/s"];
for i = 1:length(desc)
    variance = [];
    meanMid = [];
    for m = 1:length(mouseInfo)
        nexttile
        hold on;
        for n = 1:length(mouseInfo(m).mouseName)
            current = binnedInstances(m).velCI{i,n};
            x = 1:50;
            top = current(1,:);
            bot = current(2,:);
            mid = mean(current);
            variance(:,n) = (bot-mid)';
            meanMid(:,n) = mid;

            plot(x, mid, colors(m))
            h = patch([x fliplr(x)], [top fliplr(bot)], colors(m));
            set(h,'facealpha',.5)
            title(strcat("Spectra for ", group, desc(i)))
            ylim([0, 0.45])
            xlabel('Frequency (Hz)')
            ylabel('Power')
        end
        combinedMid(:,ind) = mean(meanMid,2);
        combinedVar(:,ind) = sum(variance,2);
        ind=ind+1;
    end
end
hold off;

%% Plotting Average
figure(2);
tiledlayout(3,1);
desc = [" awake rest", " <3 cm/s", "3+ cm/s"];
for i = 1:3
    nexttile
    for j = 1:3
        hold on;
        mid = combinedMid(:,(i-1)*3+j);
        top = mid+combinedVar(:,i);
        bot = mid-combinedVar(:,i);
        x = [1:50]';
        plot(x, mid, colors(j))
        plot(x, top, colors(j))
        plot(x, bot, colors(j))
        %h = patch([x fliplr(x)], [bot fliplr(top)], colors(j));
        set(h,'facealpha',.5)
        title(strcat("Spectra for ", group), desc(j))
        %ylim([0, 0.45])
        xlabel('Frequency (Hz)')
        ylabel('Power')
    end
end
