confidence = [];
limits = 3;
bootfun = @(x) mean(x);

mouseInfo(1).group = "WT";
mouseInfo(1).mouseName = ["Mouse-3","Mouse-4","Mouse-5"];
mouseInfo(1).color = 'r';

mouseInfo(2).group = "Heterozygous";
mouseInfo(2).mouseName = ["Mouse-8","Mouse-9","Mouse-10","Mouse-12"];
mouseInfo(2).color = 'g';

mouseInfo(3).group = "Homozygous";
mouseInfo(3).mouseName = ["Mouse-16","Mouse-17","Mouse-18","Mouse-20","Mouse-22","Mouse-23"];
mouseInfo(3).color = 'b';

for m = 1:length(mouseInfo)
    group = mouseInfo(m).group;
    confidence(m).name = group;
    mouseName = mouseInfo(m).mouseName;

    for i = 1:length(mouseName)
        load(strcat("C:\Users\nrive\Research\AnkG\kinematicInformation\awakeRest\", mouseName(i)))
        awakeRest = [];
        movement = [];
        runTimes = [];

        for k = 1:length(K)
            runTimes = [runTimes K(k).runTimes];
        end
        
        movement.awakeRest = [K(k).wakeRest.waveletPower];

        for j = 1:length(limits)
            if(~isempty(runTimes))
                velocityBin = runTimes([runTimes.avgVelocity] <= limits(j));
                movement.moving(j).wavelet = [velocityBin.waveletPower];
                runTimes = runTimes([runTimes.avgVelocity] > limits(j));
            end
        end
        movement.moving(j+1).wavelet = [runTimes.waveletPower];
        
        confidence(m).group(i).name = mouseName(i);
        confidence(m).group(i).movement = movement;        
    end
end

%% Analyze Awake Rest
for g = 1:length(confidence)
    for m1 = 1:length(confidence(g).group)
        for m2 = 1:length(confidence(g).group(m1).movement)
            bootdata = confidence(g).group(m1).movement(m2).awakeRest;
            confidence(g).group(m1).movement(m2).awakeRestCI = bootci(1000, {bootfun, bootdata'},'Type','student');
            
            for m3 = 1:length(confidence(g).group(m1).movement(m2).moving)
                bootdata = confidence(g).group(m1).movement(m2).moving(m3).wavelet;
                confidence(g).group(m1).movement(m2).moving(m3).movementCI = bootci(1000, {bootfun, bootdata'},'Type','student');
            end
        end
    end
end

