path = "C:\Users\nrive\Research\AnkG\kinematicInformation\awakeRest\";
thresholdVel = 3;
mouseInfo(1).group = "WT";
mouseInfo(1).mouseName = ["Mouse-3","Mouse-4","Mouse-5"];
mouseInfo(1).color = 'r';

mouseInfo(2).group = "Heterozygous";
mouseInfo(2).mouseName = ["Mouse-8","Mouse-9","Mouse-10","Mouse-12"];
mouseInfo(2).color = 'g';

mouseInfo(3).group = "Homozygous";
mouseInfo(3).mouseName = ["Mouse-16","Mouse-17","Mouse-18","Mouse-19","Mouse-20","Mouse-22","Mouse-23"];
mouseInfo(3).color = 'b';

for genotype = 1:length(mouseInfo)
    awakeGammaVals = zeros(length(mouseInfo(genotype).mouseName),1);
    slowMovingGammaVals = zeros(length(mouseInfo(genotype).mouseName),1);
    fastMovingGammaVals = zeros(length(mouseInfo(genotype).mouseName),1);
    
    for m = 1:length(mouseInfo(genotype).mouseName)
        load(strcat(path, '\', mouseInfo(genotype).mouseName(m), '.mat'))
        runTimes = [];
        awakeRest = [];
        
        for k = 1:length(K)
            runTimes = [runTimes K(k).runTimes];
            awakeRest = [awakeRest K(k).wakeRest];
        end
        slowRunTimes = runTimes([runTimes.avgVelocity] < thresholdVel);
        slowWP = [slowRunTimes.waveletPower];
        avgSlowMovingWP = mean(slowWP,2);
        avgSlowMovingGamma = sum(avgSlowMovingWP(25:45));
        slowMovingGammaVals(m) = avgSlowMovingGamma;
        
        fastRunTimes = runTimes([runTimes.avgVelocity] >= thresholdVel);
        fastWP = [fastRunTimes.waveletPower];
        avgFastMovingWP = mean(fastWP,2);
        avgFastMovingGamma = sum(avgFastMovingWP(25:45));
        fastMovingGammaVals(m) = avgFastMovingGamma;
        
        awakeRestTimes = [awakeRest.waveletPower];
        avgAwakeWP = mean(awakeRestTimes,2);
        avgAwakeGamma = sum(avgAwakeWP(25:45));
        awakeGammaVals(m) = avgAwakeGamma;
    end
    boxes.(mouseInfo(genotype).group).awakeGamma = awakeGammaVals;
    boxes.(mouseInfo(genotype).group).slowMovingGamma = slowMovingGammaVals;
    boxes.(mouseInfo(genotype).group).fastMovingGamma = fastMovingGammaVals;
end

%% Make Boxplots of the analyzed data
wtAG = boxes.WT.awakeGamma;
wtSMG = boxes.WT.slowMovingGamma;
wtFMG = boxes.WT.fastMovingGamma;

hetAG = boxes.Heterozygous.awakeGamma;
hetSMG = boxes.Heterozygous.slowMovingGamma;
hetFMG = boxes.Heterozygous.fastMovingGamma;

homAG = boxes.Homozygous.awakeGamma;
homSMG = boxes.Homozygous.slowMovingGamma;
homFMG = boxes.Homozygous.fastMovingGamma;

figure(3); tiledlayout(1,3)

nexttile
agBoxAlign = [ones(size(wtAG)); 2*ones(size(hetAG)); 3*ones(size(homAG))];
agBox = [wtAG; hetAG; homAG];
boxplot(agBox, agBoxAlign)
set(gca,'XTickLabel',{'WT','HET','HOM'})

nexttile
smgBoxAlign = [ones(size(wtSMG)); 2*ones(size(hetSMG)); 3*ones(size(homSMG))];
smgBox = [wtSMG; hetSMG; homSMG];
boxplot(smgBox, smgBoxAlign)
set(gca,'XTickLabel',{'WT','HET','HOM'})

nexttile
fmgBoxAlign = [ones(size(wtFMG)); 2*ones(size(hetFMG)); 3*ones(size(homFMG))];
fmgBox = [wtFMG; hetFMG; homFMG];
boxplot(fmgBox, fmgBoxAlign)
set(gca,'XTickLabel',{'WT','HET','HOM'})