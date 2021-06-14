for m = 1:length(mouseInfo)
    group = mouseInfo(m).group;
    mouseName = mouseInfo(m).mouseName;
    
    bin(1).limits = [0 5];
    bin(2).limits = [5 10];
    bin(3).limits = [10 25];
    bin(1).instances = [];
    bin(2).instances = [];
    bin(3).instances = [];
    

    for i = 1:length(mouseName)
        load(strcat("C:\Users\nrive\Research\AnkG\kinematicInformation\kStructure\", mouseName(i)))
        
        for j = 1:length(bin)
            for k = 1:length(K)
                if(~isempty(K(k).runTimes))
                    b = K(k).runTimes([K(k).runTimes.avgVelocity] <= bin(j).limits(2));
                    bin(j).instances = [bin(j).instances b([b.avgVelocity] > bin(j).limits(1))];
                end
            end
        end
    end
    
    binnedInstances(m).bins = bin;
end


for i = 1:length(binnedInstances)
    a = binnedInstances(i).bins;
    bootfun = @(x) mean(x);
    eegWavelet = [];
    
    for j = 1:length(a)
        for k = 1:length(a(j).instances)
            x = a(j).instances(k).waveletPower;
            if(~isnan(x(1)))
                eegWavelet = [eegWavelet x];
            end
        end
       
        [ci, bootstat] = bootci(1000, bootfun, eegWavelet');
        temp(j) = {ci'};
    end
    binnedInstances(i).ci = temp;
end
