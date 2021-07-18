limits = 3;
boxes = [];

mouseInfo(1).group = "WT";
mouseInfo(1).mouseName = ["Mouse-3","Mouse-4","Mouse-5"];
mouseInfo(1).color = 'r';

mouseInfo(2).group = "Heterozygous";
mouseInfo(2).mouseName = ["Mouse-8","Mouse-9","Mouse-10","Mouse-12"];
mouseInfo(2).color = 'g';

mouseInfo(3).group = "Homozygous";
mouseInfo(3).mouseName = ["Mouse-16","Mouse-17","Mouse-18","Mouse-22","Mouse-23"];
mouseInfo(3).color = 'b';

%% Create Boxplot Structure
for m = 1:length(mouseInfo)
    group = mouseInfo(m).group;
    boxes(m).name = group;
    mouseName = mouseInfo(m).mouseName;

    for i = 1:length(mouseName)
        boxes(m).mouse(i).name = mouseName(i);
        load(strcat("C:\Users\nrive\Research\AnkG\kinematicInformation\awakeRest\", mouseName(i)))
        awakeRest = [];
        runTimes = [];
        
        for k = 1:length(K)
            runTimes = [runTimes K(k).runTimes];
            awakeRest = [awakeRest K(k).wakeRest.waveletPower];
        end
        
        mousePower.awakeRestGamma = zeros(size(awakeRest,2),1);
        mousePower.awakeRestGamma(:,1) = sum(awakeRest(25:45,:));
        
        mousePower.awakeRestTheta = zeros(size(awakeRest,2),1);
        mousePower.awakeRestTheta(:,1) = sum(awakeRest(5:10,:));
        
        for j = 1:length(limits)
            if(~isempty(runTimes))
                velocityBin = runTimes([runTimes.avgVelocity] <= limits(j));
                moving(j).wavelet = [velocityBin.waveletPower];
                runTimes = runTimes([runTimes.avgVelocity] > limits(j));
            end
        end
        moving(j+1).wavelet = [runTimes.waveletPower];
        
        mousePower.slowMovingGamma = zeros(size(moving(1).wavelet,2),1);
        mousePower.slowMovingGamma(:,1) = sum(moving(1).wavelet(25:45,:));
        mousePower.slowMovingTheta = zeros(size(moving(1).wavelet,2),1);
        mousePower.slowMovingTheta(:,1) = sum(moving(1).wavelet(5:10,:));
        
        
        mousePower.fastMovingGamma = zeros(size(moving(2).wavelet,2),1);
        mousePower.fastMovingGamma(:,1) = sum(moving(2).wavelet(25:45,:));
        mousePower.fastMovingTheta = zeros(size(moving(2).wavelet,2),1);
        mousePower.fastMovingTheta(:,1) = sum(moving(2).wavelet(5:10,:));
        
        boxes(m).mouse(i).mousePower = mousePower;
    end
end

%% Plot data
awakeRestTheta = [];
awakeRestGamma = [];
slowMovingGamma = [];
slowMovingTheta = [];
fastMovingGamma = [];
fastMovingTheta = [];
awakeRestThetaG = [];
awakeRestGammaG = [];
slowMovingGammaG = [];
slowMovingThetaG = [];
fastMovingGammaG = [];
fastMovingThetaG = [];
index = 1;
names = [];

for b = 1:length(boxes)
    for m = 1:length(boxes(b).mouse)
        awakeRestTheta = [awakeRestTheta; boxes(b).mouse(m).mousePower.awakeRestTheta];
        awakeRestGamma = [awakeRestGamma; boxes(b).mouse(m).mousePower.awakeRestGamma];
        slowMovingGamma = [slowMovingGamma; boxes(b).mouse(m).mousePower.slowMovingGamma];
        slowMovingTheta = [slowMovingTheta; boxes(b).mouse(m).mousePower.slowMovingTheta];
        fastMovingGamma = [fastMovingGamma; boxes(b).mouse(m).mousePower.fastMovingGamma];
        fastMovingTheta = [fastMovingTheta; boxes(b).mouse(m).mousePower.fastMovingTheta];
        
        awakeRestThetaG = [awakeRestThetaG; index*ones(size(boxes(b).mouse(m).mousePower.awakeRestTheta))];
        awakeRestGammaG = [awakeRestGammaG; index*ones(size(boxes(b).mouse(m).mousePower.awakeRestGamma))];
        slowMovingGammaG = [slowMovingGammaG; index*ones(size(boxes(b).mouse(m).mousePower.slowMovingGamma))];
        slowMovingThetaG = [slowMovingThetaG; index*ones(size(boxes(b).mouse(m).mousePower.slowMovingTheta))];
        fastMovingGammaG = [fastMovingGammaG; index*ones(size(boxes(b).mouse(m).mousePower.fastMovingGamma))];
        fastMovingThetaG = [fastMovingThetaG; index*ones(size(boxes(b).mouse(m).mousePower.fastMovingTheta))];
        index = index+1;
        names = [names, boxes(b).mouse(m).name];
    end
end

tiledlayout(2,3)
nexttile;
boxplot(awakeRestTheta, awakeRestThetaG);
title("Awake Moving Theta Power")
ylim([0 10])
set(gca,'XTickLabel',names);

nexttile;
boxplot(slowMovingTheta, slowMovingThetaG);
title("<3 cm/s Moving Theta Power")
ylim([0 10])
set(gca,'XTickLabel',names);

nexttile;
boxplot(fastMovingTheta, fastMovingThetaG);
title("3+ cm/s Moving Theta Power")
ylim([0 10])
set(gca,'XTickLabel',names);

nexttile;
boxplot(awakeRestGamma, awakeRestGammaG);
title("Awake Moving Gamma Power")
ylim([0 10])
set(gca,'XTickLabel',names);

nexttile;
boxplot(slowMovingGamma, slowMovingGammaG);
title("<3 cm/s Moving Gamma Power")
ylim([0 10])
set(gca,'XTickLabel',names);

nexttile;
boxplot(fastMovingGamma, fastMovingGammaG);
title("3+ cm/s Moving Gamma Power")
ylim([0 10])
set(gca,'XTickLabel',names);

