binnedInstances = [];
includeWakeRest = 0;
limits = 3;

for m = 1:length(mouseInfo)
    group = mouseInfo(m).group;
    mouseName = mouseInfo(m).mouseName;
    awakeRest = [];
    velocity = [];

    for i = 1:length(mouseName)
        if(mouseName(i) ~= 'Mouse-19')
            load(strcat("C:\Users\nrive\Research\AnkG\kinematicInformation\awakeRest\", mouseName(i)))
            
            for k = 1:length(K)
                runTimes = K(k).runTimes;
                awakeRestTimes = K(k).wakeRest;
                
                awakeRest = [awakeRest awakeRestTimes];
                for j = 1:length(limits)
                    if(~isempty(runTimes))
                        if(i==1)
                            velocityBin = runTimes([runTimes.avgVelocity] <= limits(j));
                            velocity{j,i} = velocityBin;
                            runTimes = runTimes([runTimes.avgVelocity] > limits(j));
                        else
                            velocity{j,1} = [velocity{j,1} velocityBin];
                        end
                    end
                end
                if(i==1)
                    velocity{j+1,i} = runTimes;
                else
                    velocity{j+1,1} = [velocity{j+1,1} runTimes];
                end
            end
        end
    end
    
    runSpeedBin.awakeRest = awakeRest;
    runSpeedBin.velocity = velocity;

    binnedInstances(m).group = group;
    binnedInstances(m).bins = runSpeedBin;
end

bootfun = @(x) mean(x);

for i = 1:length(mouseInfo)
    a = binnedInstances(i).bins;
    temp = [];
    awCI = bootci(2000, bootfun, [a.awakeRest.waveletPower]');
    
    for j = 1:length(a.velocity)
        velocityBin = a.velocity{j,1};
        awakeRestBin = a.awakeRest;
        
        if(~isempty(awakeRestBin) && j==1 && includeWakeRest) 
            data = [velocityBin.waveletPower awakeRestBin.waveletPower]';
        else
            data = [velocityBin.waveletPower]';
        end
               
        data = data(~isnan(data(:,1)),:);
        ci = bootci(2000, bootfun, data);
        temp{1,j} = ci';
    end
    binnedInstances(i).ci = temp;
    binnedInstances(i).awCI = awCI;
end

