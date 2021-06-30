%% Evaluating ROC Metrics
load rocdata.mat

datact = 1;
for rocidx = 1:length(ROC_data.mouse)
    if isempty(ROC_data.mouse(rocidx).name) ~= 1
        for dayidx = 1:length(ROC_data.mouse(rocidx).day)
            if isfield(ROC_data.mouse(rocidx).day(dayidx).begin,'analysis_data') == 1
                for beginidx = 1:length(ROC_data.mouse(rocidx).day(dayidx).begin)
                    if isempty(ROC_data.mouse(rocidx).day(dayidx).begin(beginidx).truevalues) ~= 1
                        groundTruth = ROC_data.mouse(rocidx).day(dayidx).begin(beginidx).truevalues.';
                        for classidx = 1:length(ROC_data.mouse(rocidx).day(dayidx).begin(beginidx).analysis_data)
                            classifiedData = ROC_data.mouse(rocidx).day(dayidx).begin(beginidx).analysis_data(classidx).classified;
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
                            motionThresholdROC.thresholds(classidx).FP(datact) = falsePositives;
                            motionThresholdROC.thresholds(classidx).FN(datact) = falseNegatives;
                            motionThresholdROC.thresholds(classidx).TP(datact) = truePositives;
                            motionThresholdROC.thresholds(classidx).TN(datact) = trueNegatives;
                            datact = datact+1;
                        end
                    end
                end
            end
        end
    end
end
%% Constructing ROC Curve and evaluating AUC
for mthidx = 1:length(motionThresholdROC.thresholds)
    truePos = sum(motionThresholdROC.thresholds(mthidx).TP);
    trueNeg = sum(motionThresholdROC.thresholds(mthidx).TN);
    falsePos = sum(motionThresholdROC.thresholds(mthidx).FP);
    falseNeg = sum(motionThresholdROC.thresholds(mthidx).FN);
    sensitivity = truePos/(truePos+falseNeg);
    specificity = trueNeg/(trueNeg+falsePos);
    ROCplotData(mthidx,1) = 1-specificity;
    ROCplotData(mthidx,2) = sensitivity;
end
ROCcurve = figure();
hold on
plot(ROCplotData(:,1),ROCplotData(:,2));
scatter(ROCplotData(:,1),ROCplotData(:,2),'.');
xlabel('False Positive Fraction (1-Specificity)');
ylabel('True Positive Fraction (Sensitivity)');
AUC = string(trapz(ROCplotData(:,1),ROCplotData(:,2)));
titleName = strcat('Classifier ROC Curve, AUC =',AUC);
title(titleName);
hold off;