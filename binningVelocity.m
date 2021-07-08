binnedInstances = [];
includeWakeRest = 0;
limits = 3;

for m = 1:length(mouseInfo)
    group = mouseInfo(m).group;
    mouseName = mouseInfo(m).mouseName;
    awakeRest = [];
    velocity = [];

    for i = 1:length(mouseName)
        load(strcat("C:\Users\nrive\Research\AnkG\kinematicInformation\awakeRest\", mouseName(i)))

        for k = 1:length(K)
            runTimes = K(k).runTimes;
            awakeRestTimes = K(k).wakeRest;

            awakeRest{i,1} = awakeRestTimes;
            for j = 1:length(limits)
                if(~isempty(runTimes))
                    velocityBin = runTimes([runTimes.avgVelocity] <= limits(j));
                    velocity{j,i} = velocityBin;
                    runTimes = runTimes([runTimes.avgVelocity] > limits(j));
                end
            end
            velocity{j+1,i} = runTimes;
        end
    end
    
    binnedInstances(m).group = group;
    binnedInstances(m).awakeRest = awakeRest;
    binnedInstances(m).velocity = velocity;
end
bootfun = @(x) mean(x);
%% Analyze Awake Rest
for i = 1:length(mouseInfo)
    vel = binnedInstances(i).velocity;
    awakeRest = binnedInstances(i).awakeRest;
    velCI = [];
    awCI = [];
    
    for aw = 1:length(awakeRest)
        wp = [awakeRest{aw,1}.waveletPower]';
        awCI{aw,1} = bootci(2000, bootfun, wp);
    end

    for v = 1:size(vel,1)
        for bins = 1:size(vel,2)
            velocityBin = vel{v,bins};
            wp = [velocityBin.waveletPower]';
            wp(any(isnan(wp),2),:) = [];
            velCI{v,bins} = bootci(1000, bootfun, wp);
        end
    end
    
    binnedInstances(i).velCI = velCI;
    binnedInstances(i).awCI = awCI;
end

