% clear all;
% load('mouseInfo.mat')
% binningVelocity;
colors = ["r","g","b","k"];

for i = 1:length(mouseInfo)
    figure(i); clf;
    hold on;
    for j = 1:length(binnedInstances(i).ci)
        plot(1:50, cell2mat(binnedInstances(i).ci(j)), colors(j));
    end
    
    title(strcat(mouseInfo(i).group, " spectra binned by running speed"))
    xlabel('Frequency (Hz)')
    ylabel('Power')
    legend("0.05-5 cm/s", "", "5-10 cm/s", "", "10+ cm/s", "")
end