%% Awake Rest Plots
figure(1); tiledlayout(3,3);
for i = 1:length(confidence)
    nexttile; hold on;
    legendEntry = [];   
    group = confidence(i).name;
    opacityInc = 1/length(confidence(i).group);
    opacity = opacityInc:opacityInc:1;
    
    for j = 1:length(confidence(i).group)
        for k = 1:length(confidence(i).group(j).movement)       
            x = 1:50;
            bot = confidence(i).group(j).movement(k).awakeRestCI(1,:);
            top = confidence(i).group(j).movement(k).awakeRestCI(2,:);
            patch([x fliplr(x)], [top fliplr(bot)], mouseInfo(i).color, 'FaceAlpha', opacity(j));
            legendEntry = [legendEntry strcat(confidence(i).group(j).name, " n=", num2str(size(confidence(i).group(j).movement(k).awakeRest,2)))];
        end
    end
    
    title(strcat("Spectra for awake rest - ", group))
    legend(legendEntry)
    ylim([0 0.4])
    xlabel("Frequency (Hz)")
    ylabel("Power")
end

%% <3 cm/s Plots
for i = 1:length(confidence)
    nexttile; hold on;
    legendEntry = [];   
    group = confidence(i).name;
    opacityInc = 1/length(confidence(i).group);
    opacity = opacityInc:opacityInc:1;
    
    group = confidence(i).name;
    for j = 1:length(confidence(i).group)
        for k = 1:length(confidence(i).group(j).movement)        
            x = 1:50;
            data = confidence(i).group(j).movement(k).moving(1).movementCI;
            bot = data(1,:);
            top = data(2,:);
            patch([x fliplr(x)], [top fliplr(bot)], mouseInfo(i).color, 'FaceAlpha', opacity(j));
            legendEntry = [legendEntry strcat(confidence(i).group(j).name, " n=", num2str(size(confidence(i).group(j).movement.moving(1).wavelet,2)))];
        end
    end
    
    title(strcat("Spectra for <3 cm/s of movement - ", group))
    ylim([0 0.4])
    legend(legendEntry)
    xlabel("Frequency (Hz)")
    ylabel("Power")
end

%% 3+ cm/s Plots
for i = 1:length(confidence)
    nexttile; hold on;
    legendEntry = [];   
    group = confidence(i).name;
    opacityInc = 1/length(confidence(i).group);
    opacity = opacityInc:opacityInc:1;
    for j = 1:length(confidence(i).group)
        for k = 1:length(confidence(i).group(j).movement)        
            x = 1:50;
            data = confidence(i).group(j).movement(k).moving(2).movementCI;
            bot = data(1,:);
            top = data(2,:);
            patch([x fliplr(x)], [top fliplr(bot)], mouseInfo(i).color, 'FaceAlpha', opacity(j));
            legendEntry = [legendEntry strcat(confidence(i).group(j).name, " n=", num2str(size(confidence(i).group(j).movement.moving(2).wavelet,2)))];
        end
    end
    
    title(strcat("Spectra for +3 cm/s of movement - ", group))
    ylim([0 0.25])
    legend(legendEntry)
    xlabel("Frequency (Hz)")
    ylabel("Power")
end

%% Plotting Average awake rest
figure(2); clf; tiledlayout(1,3)
nexttile;
hold on;
for i = 1:length(confidence)
    group = confidence(i).name;
    stdError = zeros(50, length(confidence(i).group));
    average = zeros(50, length(confidence(i).group));
    groupSize = length(confidence(i).group);
    for j = 1:length(confidence(i).group)
        for k = 1:length(confidence(i).group(j).movement)      
            x = 1:50;
            bot = confidence(i).group(j).movement(k).awakeRestCI(1,:);
            top = confidence(i).group(j).movement(k).awakeRestCI(2,:);
            ciSD = (top-bot)./4;
            stdError(:,j) = ciSD./sqrt(groupSize);
            average(:,j) = (top+bot)./2;
        end
    end
    SE = sum(stdError,2).^2;
    spectraMean = sum(average,2)./groupSize;
    ci95 = 2*(SE.^(1/2));
    bot = spectraMean'-ci95';
    top = spectraMean'+ci95';
    patch([x fliplr(x)], [top fliplr(bot)], mouseInfo(1).colorNum)
end
title("Combined spectra for awake rest")
xlabel("Frequency (Hz)")
ylabel("Power")
legend("WT","HET","HOM")
axis square;

nexttile;
hold on;
for i = 1:length(confidence)
    group = confidence(i).name;
    stdError = zeros(50, length(confidence(i).group));
    average = zeros(50, length(confidence(i).group));
    groupSize = length(confidence(i).group);
    for j = 1:length(confidence(i).group)
        for k = 1:length(confidence(i).group(j).movement)      
            data = confidence(i).group(j).movement(k).moving(1).movementCI;
            bot = data(1,:);
            top = data(2,:);
            ciSD = (top-bot)./4;
            stdError(:,j) = ciSD./sqrt(groupSize);
            average(:,j) = (top+bot)./2;
        end
    end
    SE = sum(stdError,2).^2;
    spectraMean = sum(average,2)./groupSize;
    ci95 = 2*(SE.^(1/2));
    bot = spectraMean'-ci95';
    top = spectraMean'+ci95';
    patch([x fliplr(x)], [top fliplr(bot)], mouseInfo(2).colorNum)
end
title("Combined spectra for <3 cm/s of movement")
xlabel("Frequency (Hz)")
ylabel("Power")
legend("WT","HET","HOM")
axis square;

nexttile;
hold on;
for i = 1:length(confidence)
    group = confidence(i).name;
    stdError = zeros(50, length(confidence(i).group));
    average = zeros(50, length(confidence(i).group));
    groupSize = length(confidence(i).group);
    for j = 1:length(confidence(i).group)
        for k = 1:length(confidence(i).group(j).movement)      
            data = confidence(i).group(j).movement(k).moving(2).movementCI;
            bot = data(1,:);
            top = data(2,:);
            ciSD = (top-bot)./4;
            stdError(:,j) = ciSD./sqrt(groupSize);
            average(:,j) = (top+bot)./2;
        end
    end
    SE = sum(stdError,2).^2;
    spectraMean = sum(average,2)./groupSize;
    ci95 = 2*(SE.^(1/2));
    bot = spectraMean'-ci95';
    top = spectraMean'+ci95';
    patch([x fliplr(x)], [top fliplr(bot)], mouseInfo(3).colorNum)
end
title("Combined spectra for 3+ cm/s of movement")
xlabel("Frequency (Hz)")
ylabel("Power")
legend("WT","HET","HOM")

axis square;