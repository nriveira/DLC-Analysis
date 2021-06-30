%% Extracting Verified Calls and ROC Data
load BehaviorHandScoredwSWDdata_v3.mat
addpath('/work2/07424/nriveira/stampede2/roc_code/')

behaviorEval = 'walk';
classDirRoot = '/work2/07424/nriveira/stampede2/DLC_Vids/';
timeThreshold = 4;
fps = 30;
for mouseidx = 1:length(Mouse)
    mouseName = Mouse(mouseidx).name;
    for dayidx = 1:length(Mouse(mouseidx).Day)
        dayName = Mouse(mouseidx).Day(dayidx).name;
        for beginidx = 1:length(Mouse(mouseidx).Day(dayidx).Begin)
            if isfield(Mouse(mouseidx).Day(dayidx).Begin,'allBehaviors') == 1
                beginName = Mouse(mouseidx).Day(dayidx).Begin(beginidx).name;
                ROC_data.mouse(mouseidx).name = mouseName;
                ROC_data.mouse(mouseidx).day(dayidx).name = dayName;
                ROC_data.mouse(mouseidx).day(dayidx).begin(beginidx).name = beginName;
                classDir = strcat(classDirRoot,mouseName,'/',dayName,'/',beginName);
                if isfolder(classDir)
                    cd(classDir);
                    dlcfiles = dir(fullfile(classDir,'*.csv'));
                    dlcfiles = natsortfiles(dlcfiles);
                    dlcfiles = {dlcfiles.name}';
%%%%%%%%%%%%%%%%%%%Performing ROC Analysis%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    for timeThreshold = 1:2
                        for motionThreshold = 1:100
                            [~,~,~,~,perc_rect, non_sleep_frames] = ...
                                DLC_awake_sleep_classify(dlcfiles,motionThreshold,timeThreshold,fps);
                            R
C_data.mouse(mouseidx).day(dayidx).begin(beginidx).analysis_data(timeThreshold).data(motionThreshold).classified = non_sleep_frames;
                            ROC_data.mouse(mouseidx).day(dayidx).begin(beginidx).analysis_data(timeThreshold).data(motionThreshold).percentRectified = perc_rect;
                            ROC_data.mouse(mouseidx).day(dayidx).begin(beginidx).analysis_data(timeThreshold).data(motionThreshold).motion_threshold = motionThreshold;
                        end
                    end
                    
save('rocdata.mat','ROC_data','-v7.3')
%%%%%%%%%%%%%%%%%%%Evaluating Ground Truth%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    groundTruth = [];
                    groundTruthPtr = 1;
                    groundCheck = 0; %Sum should equal sum of groundTruth
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

save('rocdata.mat','ROC_data','-v7.3')
