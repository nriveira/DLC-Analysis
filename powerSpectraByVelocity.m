clf; figure(1); hold on;

for m = 1:length(mouseInfo)
    group = mouseInfo(m).group;
    mouseName = mouseInfo(m).mouseName;
    color = mouseInfo(m).color;
    eegWavelet = [];

    for i = 1:length(mouseName)
        load(strcat("C:\Users\nrive\Research\AnkG\kinematicInformation\kStructure\", mouseName(i)))

        for j = 1:length(K)
            for k = 1:length(K(j).runTimes)
                x = mean(K(j).runTimes(k).waveletPower,2);
                if(~isnan(x(1)))
                    eegWavelet = [eegWavelet x];
                end
            end
        end
    end

    bootfun = @(x) mean(x);
    [movementResults(m).ci, bootstat] = bootci(2000, bootfun, eegWavelet');
    movementResults(m).ci = movementResults(m).ci';
end

for m = 1:length(mouseInfo)
    color = mouseInfo(m).color;
    plot(movementResults(m).ci, color);
end

title("Spectra during movement per genotype")
xlabel("Frequency (Hz)");
ylabel("Power");
legend("WT", "", "Heterozygous", "","Homozygous", "")