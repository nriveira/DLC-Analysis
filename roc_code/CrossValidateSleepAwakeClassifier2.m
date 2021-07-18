fps = 30;
behaviorEval = 'walk';

for mouseidx = 1:length(Mouse)
mouseName = Mouse(mouseidx).name;
    for dayidx = 1:length(Mouse(mouseidx).Day)
        dayName = Mouse(mouseidx).Day(dayidx).name;
        for beginidx = 1:length(Mouse(mouseidx).Day(dayidx).Begin)
            if isfield(Mouse(mouseidx).Day(dayidx).Begin,'allBehaviors')
                beginName = Mouse(mouseidx).Day(dayidx).Begin(beginidx).name;
                if ~isempty(Mouse(mouseidx).Day(dayidx).Begin(beginidx).allBehaviors)
                    motionStruct = motion(strcmp({motion.mouseName}, mouseName)==1);
                    motionStruct = motionStruct(strcmp({motionStruct.dayName}, dayName));
                    motionStruct = motionStruct(strcmp({motionStruct.beginName}, beginName));
                    motionData = motionStruct.motionData;
                    dlcfiles = motionStruct.dlcfiles;
                    perc_rect = motionStruct.perc_rect;

                    tic
                    for timeThreshold = 1:5
                        for motionThreshold = 1:100
                            [~,~,~,~, non_sleep_frames] = ...
                                DLC_awake_sleep_classify(dlcfiles,(motionThreshold * 0.5),timeThreshold, fps, motionData);
                            ROC_data.mouse(i).analysis_data(timeThreshold).data(motionThreshold).classified = non_sleep_frames;
                            ROC_data.mouse(i).analysis_data(timeThreshold).data(motionThreshold).percentRectified = perc_rect;
                            ROC_data.mouse(i).analysis_data(timeThreshold).data(motionThreshold).motion_threshold = motionThreshold;
                        end
                        fprintf('finished %d\n', timeThreshold)
                    end
                    toc
                end
            end
        end
    end
end

%% %%%%%%%%%%%%%%%%Evaluating Ground Truth%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i = 1;
groundTruth = [];
groundTruthPtr = 1;
groundCheck = 0; %Sum should equal sum of groundTruth
for mouseidx = 1:length(Mouse)
    mouseName = Mouse(mouseidx).name;
    for dayidx = 1:length(Mouse(mouseidx).Day)
        dayName = Mouse(mouseidx).Day(dayidx).name;
        for beginidx = 1:length(Mouse(mouseidx).Day(dayidx).Begin)
            if isfield(Mouse(mouseidx).Day(dayidx).Begin,'allBehaviors')
                beginName = Mouse(mouseidx).Day(dayidx).Begin(beginidx).name;
                if (~isempty(Mouse(mouseidx).Day(dayidx).Begin(beginidx).allBehaviors))
                    for groundidx = 1:length(Mouse(mouseidx).Day(dayidx).Begin(beginidx).allBehaviors)
                        groundLen = ...
                        floor((Mouse(mouseidx).Day(dayidx).Begin(beginidx).allBehaviors(groundidx).DurTime_ms)*(fps/1000));
                        groundID = ...
                        (Mouse(mouseidx).Day(dayidx).Begin(beginidx).allBehaviors(groundidx).Behavior);
                        if isequal(groundID,behaviorEval) == 1
                            groundTruth = [groundTruth; ones(groundLen,1)];
                            groundCheck = groundCheck + groundLen;
                        else
                            groundTruth = [groundTruth; zeros(groundLen,1)];
                        end
                    end      
                    ROC_data.mouse(mouseidx).day(dayidx).begin(beginidx).truevalues = groundTruth;
                end
            end
        end
    end
end