%% Evaluating ROC Metrics
load rocdata.mat

datact = 1;
for rocidx = 1:length(ROC_data.mouse)
    if ~isempty(ROC_data.mouse(rocidx).name)
        for dayidx = 1:length(ROC_data.mouse(rocidx).day)
            if isfield(ROC_data.mouse(rocidx).day(dayidx).begin,'analysis_data')
                for beginidx = 1:length(ROC_data.mouse(rocidx).day(dayidx).begin)
                    if ~isempty(ROC_data.mouse(rocidx).day(dayidx).begin(beginidx).truevalues)
                        groundTruth = ROC_data.mouse(rocidx).day(dayidx).begin(beginidx).truevalues.';
                        for classidx = 1:length(ROC_data.mouse(rocidx).day(dayidx).begin(beginidx).analysis_data)
                            for timeidx = 1:length(ROC_data.mouse(rocidx).day(dayidx).begin(beginidx).analysis_data(classidx).data)
                                
                                classifiedData = ROC_data.mouse(rocidx).day(dayidx).begin(beginidx).analysis_data(classidx).data(timeidx).classified';
                                if length(classifiedData) >= length(groundTruth)
                                    classifiedData = classifiedData(1:length(groundTruth));
                                else
                                    groundTruth = groundTruth(1:length(classifiedData));
                                end
                                falsePositives = sum(classifiedData > groundTruth);
                                falseNegatives = sum(classifiedData < groundTruth);
                                trueData = classifiedData + groundTruth;
                                truePositives = sum(trueData(:) == 2);
                                trueNegatives = sum(trueData(:) == 0);
                                motionThresholdROC(timeidx).thresholds(classidx).FP(datact) = falsePositives;
                                motionThresholdROC(timeidx).thresholds(classidx).FN(datact) = falseNegatives;
                                motionThresholdROC(timeidx).thresholds(classidx).TP(datact) = truePositives;
                                motionThresholdROC(timeidx).thresholds(classidx).TN(datact) = trueNegatives;
                                datact = datact+1;
                                
                            end
                        end
                    end
                end
            end
        end
    end
end
%% Constructing ROC Curve and evaluating AUC
for timeidx = 1:length(motionThresholdROC)
    for mthidx = 1:length(motionThresholdROC(timeidx).thresholds)
        truePos = sum(motionThresholdROC(timeidx).thresholds(mthidx).TP);
        trueNeg = sum(motionThresholdROC(timeidx).thresholds(mthidx).TN);
        falsePos = sum(motionThresholdROC(timeidx).thresholds(mthidx).FP);
        falseNeg = sum(motionThresholdROC(timeidx).thresholds(mthidx).FN);
        sensitivity = truePos/(truePos+falseNeg);
        specificity = trueNeg/(trueNeg+falsePos);
        ROCplotData(timeidx, mthidx,1) = 1-specificity;
        ROCplotData(timeidx, mthidx,2) = sensitivity;
    end
end
ROCcurve = figure();
hold on
selectedT = 20;
for t = 1:20
    if(t ~= selectedT)
        plot(ROCplotData(:,t,1),ROCplotData(:,t,2), 'c');
        scatter(ROCplotData(:,t,1),ROCplotData(:,t,2),'.', 'c');
        xlabel('False Positive Fraction (1-Specificity)');
        ylabel('True Positive Fraction (Sensitivity)');
        AUC = string(trapz(ROCplotData(:,t,1),ROCplotData(:,t,2)));
        titleName = strcat('Classifier ROC Curve, AUC=', AUC);
        title(titleName);
    end
end
plot(ROCplotData(:,t,1),ROCplotData(:,selectedT,2), 'k');
scatter(ROCplotData(:,selectedT,1),ROCplotData(:,selectedT,2),'.', 'k');

hold off;