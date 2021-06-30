%% Loading data and generating structures for bootstrap analysis
load miceIDsWT.mat
load sleepPhasesDirListWT.mat
wtct=[1,1,1];
hetct=[1,1,1];
homct=[1,1,1];
for miceidx = 1:length(miceIDs)
    cd(char(sleepPhasesDirList{1,miceidx}{1,1}));
    load sleepPhasesEEG.mat
    if isequal(miceIDs{1,miceidx}{1,1},'Mouse3')||isequal(miceIDs{1,miceidx}{1,1},'Mouse4')||isequal(miceIDs{1,miceidx}{1,1},'Mouse5')||isequal(miceIDs{1,miceidx}{1,1},'Mouse23')
        for remidx = 1:length(sleepPhasesEEG.REM)
            wtSpec.Sig(wtct(1)).remsig = sleepPhasesEEG.REM(remidx).spectra;
            wtct(1) = wtct(1)+1;
        end
        for nremidx = 1:length(sleepPhasesEEG.NREM)
            wtSpec.Sig(wtct(2)).nremsig = sleepPhasesEEG.NREM(nremidx).spectra;
            wtct(2) = wtct(2)+1;
        end
        for sleepidx = 1:length(sleepPhasesEEG.AllSleep)
            wtSpec.Sig(wtct(3)).sleepsig = sleepPhasesEEG.AllSleep(sleepidx).spectra;
            wtct(3) = wtct(3)+1;
        end
    end
    if isequal(miceIDs{1,miceidx}{1,1},'Mouse8')||isequal(miceIDs{1,miceidx}{1,1},'Mouse9')||isequal(miceIDs{1,miceidx}{1,1},'Mouse10')||isequal(miceIDs{1,miceidx}{1,1},'Mouse12')
        for remidx = 1:length(sleepPhasesEEG.REM)
            hetSpec.Sig(hetct(1)).remsig = sleepPhasesEEG.REM(remidx).spectra;
            hetct(1) = hetct(1)+1;
        end
        for nremidx = 1:length(sleepPhasesEEG.NREM)
            hetSpec.Sig(hetct(2)).nremsig = sleepPhasesEEG.NREM(nremidx).spectra;
            hetct(2) = hetct(2)+1;
        end
        for sleepidx = 1:length(sleepPhasesEEG.AllSleep)
            hetSpec.Sig(hetct(3)).sleepsig = sleepPhasesEEG.AllSleep(sleepidx).spectra;
            hetct(3) = hetct(3)+1;
        end
    end
    if isequal(miceIDs{1,miceidx}{1,1},'Mouse16')||isequal(miceIDs{1,miceidx}{1,1},'Mouse17')||isequal(miceIDs{1,miceidx}{1,1},'Mouse18')||isequal(miceIDs{1,miceidx}{1,1},'Mouse19')||isequal(miceIDs{1,miceidx}{1,1},'Mouse20')||isequal(miceIDs{1,miceidx}{1,1},'Mouse22')
        for remidx = 1:length(sleepPhasesEEG.REM)
            homSpec.Sig(homct(1)).remsig = sleepPhasesEEG.REM(remidx).spectra;
            homct(1) = homct(1)+1;
        end
        for nremidx = 1:length(sleepPhasesEEG.NREM)
            homSpec.Sig(homct(2)).nremsig = sleepPhasesEEG.NREM(nremidx).spectra;
            homct(2) = homct(2)+1;
        end
        for sleepidx = 1:length(sleepPhasesEEG.AllSleep)
            homSpec.Sig(homct(3)).sleepsig = sleepPhasesEEG.AllSleep(sleepidx).spectra;
            homct(3) = homct(3)+1;
        end
    end
end
cd ../../../../..
%save('wtSpec.mat', 'wtSpec', '-v7.3')
%save('hetSpec.mat', 'hetSpec', '-v7.3')
%save('homSpec.mat', 'homSpec', '-v7.3')
%% Performing Bootstrap Analysis on All Genotypes - REM
remPlot = figure();
genNames = {'WT','HET','HOM'};
freq = 1:0.2:50;
plotColors = ['b','g','r'];
axis square
hold on
for genidx = 1:3
    if genidx == 1
        load wtSpec.mat
        pfBootData = {wtSpec.Sig(:).remsig};
    end
    if genidx == 2
        load hetSpec.mat
        pfBootData = {hetSpec.Sig(:).remsig};
    end
    if genidx == 3
        load homSpec.mat
        pfBootData = {homSpec.Sig(:).remsig};
    end
        pfBootData = pfBootData(~cellfun('isempty',pfBootData));
        if(length(pfBootData) > 1)
            ci = bootci(1000, {@avgMatrices, pfBootData}, 'type', 'norm');
            meanCI = mean(ci,3);
            CI.lower = meanCI(1,:);
            CI.mean = mean(avgMatrices(pfBootData),2).';
            CI.upper = meanCI(2,:);
        end
        plot(freq,CI.lower, plotColors(genidx),'HandleVisibility','off');
        plot(freq,CI.upper, plotColors(genidx),'HandleVisibility','off');
        plot(freq,CI.mean, plotColors(genidx),'HandleVisibility','off');
        freq2 = [freq,fliplr(freq)];
        plotShade = [CI.lower,fliplr(CI.upper)];
        fh = fill(freq2,plotShade,plotColors(genidx));
        set(fh,'facealpha',0.2);
    if genidx == 1
        clearvars wtSpec pfBootData CI
    end
    if genidx == 2
        clearvars hetSpec pfBootData CI
    end
    if genidx == 3
        clearvars homSpec pfBootData CI
    end
end
legend(genNames);
titleName = 'Power-Frequency Spectra for REM Sleep';
plotSaveName = 'REM_PF.fig';
title(titleName);
ylabel('Normalized Power');
xlabel('Frequency (Hz)');
xticks(0:5:50);
hold off
saveas(remPlot,plotSaveName);
%% Performing Bootstrap Analysis on All Genotypes - Non-REM
nonremPlot = figure();
genNames = {'WT','HET','HOM'};
freq = 1:0.2:50;
plotColors = ['b','g','r'];
axis square
hold on
for genidx = 1:3
    if genidx == 1
        load wtSpec.mat
        pfBootData = {wtSpec.Sig(:).nremsig};
    end
    if genidx == 2
        load hetSpec.mat
        pfBootData = {hetSpec.Sig(:).nremsig};
    end
    if genidx == 3
        load homSpec.mat
        pfBootData = {homSpec.Sig(:).nremsig};
    end
        pfBootData = pfBootData(~cellfun('isempty',pfBootData));
        if(length(pfBootData) > 1)
            ci = bootci(1000, {@avgMatrices, pfBootData}, 'type', 'norm');
            meanCI = mean(ci,3);
            CI.lower = meanCI(1,:);
            CI.mean = mean(avgMatrices(pfBootData),2).';
            CI.upper = meanCI(2,:);
        end
        plot(freq,CI.lower, plotColors(genidx),'HandleVisibility','off');
        plot(freq,CI.upper, plotColors(genidx),'HandleVisibility','off');
        plot(freq,CI.mean, plotColors(genidx),'HandleVisibility','off');
        freq2 = [freq,fliplr(freq)];
        plotShade = [CI.lower,fliplr(CI.upper)];
        fh = fill(freq2,plotShade,plotColors(genidx));
        set(fh,'facealpha',0.2);
    if genidx == 1
        clearvars wtSpec pfBootData CI
    end
    if genidx == 2
        clearvars hetSpec pfBootData CI
    end
    if genidx == 3
        clearvars homSpec pfBootData CI
    end
end
legend(genNames);
titleName = 'Power-Frequency Spectra for non-REM Sleep';
plotSaveName = 'Non_REM_PF.fig';
title(titleName);
ylabel('Normalized Power');
xlabel('Frequency (Hz)');
xticks(0:5:50);
hold off
saveas(nonremPlot,plotSaveName);
%% Performing Bootstrap Analysis on All Genotypes - General Sleep
sleepPlot = figure();
genNames = {'WT','HET','HOM'};
freq = 1:0.2:50;
plotColors = ['b','g','r'];
axis square
hold on
for genidx = 1:3
    if genidx == 1
        load wtSpec.mat
        pfBootData = {wtSpec.Sig(:).sleepsig};
    end
    if genidx == 2
        load hetSpec.mat
        pfBootData = {hetSpec.Sig(:).sleepsig};
    end
    if genidx == 3
        load homSpec.mat
        pfBootData = {homSpec.Sig(:).sleepsig};
    end
        pfBootData = pfBootData(~cellfun('isempty',pfBootData));
        if(length(pfBootData) > 1)
            ci = bootci(1000, {@avgMatrices, pfBootData}, 'type', 'norm');
            meanCI = mean(ci,3);
            CI.lower = meanCI(1,:);
            CI.mean = mean(avgMatrices(pfBootData),2).';
            CI.upper = meanCI(2,:);
        end
        plot(freq,CI.lower, plotColors(genidx),'HandleVisibility','off');
        plot(freq,CI.upper, plotColors(genidx),'HandleVisibility','off');
        plot(freq,CI.mean, plotColors(genidx),'HandleVisibility','off');
        freq2 = [freq,fliplr(freq)];
        plotShade = [CI.lower,fliplr(CI.upper)];
        fh = fill(freq2,plotShade,plotColors(genidx));
        set(fh,'facealpha',0.2);
    if genidx == 1
        clearvars wtSpec pfBootData CI
    end
    if genidx == 2
        clearvars hetSpec pfBootData CI
    end
    if genidx == 3
        clearvars homSpec pfBootData CI
    end
end
legend(genNames);
titleName = 'Power-Frequency Spectra for General Sleep';
plotSaveName = 'Sleep_PF.fig';
title(titleName);
ylabel('Normalized Power');
xlabel('Frequency (Hz)');
xticks(0:5:50);
hold off
saveas(sleepPlot,plotSaveName);
%% Performing Bootstrap Analysis on genotypes separated by sleep stage
sleepcombPlot = figure();
genNames = {'WT-REM','HET-REM','HOM-REM','WT-NREM','HET-NREM','HOM-NREM'};
freq = 1:0.2:50;
plotColors = ['b','g','r','c','y','m'];
axis square
hold on
for genidx = 1:6
    if genidx == 1
        load wtSpec.mat
        pfBootData = {wtSpec.Sig(:).remsig};
    end
    if genidx == 2
        load hetSpec.mat
        pfBootData = {hetSpec.Sig(:).remsig};
    end
    if genidx == 3
        load homSpec.mat
        pfBootData = {homSpec.Sig(:).remsig};
    end
    if genidx == 4
        load wtSpec.mat
        pfBootData = {wtSpec.Sig(:).nremsig};
    end
    if genidx == 5
        load hetSpec.mat
        pfBootData = {hetSpec.Sig(:).nremsig};
    end
    if genidx == 6
        load homSpec.mat
        pfBootData = {homSpec.Sig(:).nremsig};
    end
        pfBootData = pfBootData(~cellfun('isempty',pfBootData));
        if(length(pfBootData) > 1)
            ci = bootci(1000, {@avgMatrices, pfBootData}, 'type', 'norm');
            meanCI = mean(ci,3);
            CI.lower = meanCI(1,:);
            CI.mean = mean(avgMatrices(pfBootData),2).';
            CI.upper = meanCI(2,:);
        end
        plot(freq,CI.lower, plotColors(genidx),'HandleVisibility','off');
        plot(freq,CI.upper, plotColors(genidx),'HandleVisibility','off');
        plot(freq,CI.mean, plotColors(genidx),'HandleVisibility','off');
        freq2 = [freq,fliplr(freq)];
        plotShade = [CI.lower,fliplr(CI.upper)];
        fh = fill(freq2,plotShade,plotColors(genidx));
        set(fh,'facealpha',0.2);
    if genidx == 1
        clearvars wtSpec pfBootData CI
    end
    if genidx == 2
        clearvars hetSpec pfBootData CI
    end
    if genidx == 3
        clearvars homSpec pfBootData CI
    end
    if genidx == 4
        clearvars wtSpec pfBootData CI
    end
    if genidx == 5
        clearvars hetSpec pfBootData CI
    end
    if genidx == 6
        clearvars homSpec pfBootData CI
    end
end
legend(genNames);
titleName = 'Power-Frequency Spectra for non-REM and REM Sleep';
plotSaveName = 'sleepcombPlot.fig';
title(titleName);
ylabel('Normalized Power');
xlabel('Frequency (Hz)');
xticks(0:5:50);
hold off
saveas(sleepcombPlot,plotSaveName);

% make sure its cutting out seizures
% There could be seizures due to the hump - possibly harmonics
% 