%% Extracting Verified Calls and ROC Data
load BehaviorHandScoredwSWDdata_v3.mat
addpath('C:\Users\nrive\Research\DLC-Analysis\roc_code')

behaviorEval = 'walk';
classDirRoot = 'C:\Users\nrive\Research\AnkG\DLC_Vids\DLC_Vids\';
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
                classDir = strcat(classDirRoot,mouseName,'\',dayName,'\',beginName);
                if isfolder(classDir)
                    cd(classDir);
                    dlcfiles = dir(fullfile(classDir,'*.csv'));
                    dlcfiles = natsortfiles(dlcfiles);
                    dlcfiles = {dlcfiles.name}';
                   
                    % Find the right pixel values
                    beginNum = str2double(extractAfter(beginName,'Begin'));
                    dayNum = str2double(extractAfter(dayName,'Day'));
                    mouseNum = str2double(extractAfter(mouseName,'Mouse'));
                    pixelValues = timestamps([timestamps.Mouse]==mouseNum,:);
                    pixelValues = pixelValues([pixelValues.Day]==dayNum,:);
                    pixelValues = pixelValues([pixelValues.Begin]==beginNum,:);
                    pixelValues = pixelValues.pixel_val;
                    if(isempty(pixelValues))
                        pixelValues = .0511;
                    end
%%%%%%%%%%%%%%%%%%%Performing ROC Analysis%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    % Loading data
                    motionData = [];
                    for dlcfilect = 1:length(dlcfiles)
                        csvname = char(dlcfiles(dlcfilect));
                        DVdata = readtable(csvname);
                        motionData  = [motionData;DVdata];
                    end
                    clearvars DVdata;

                    % Running likelihood processing
                    motionData = table2array(motionData);
                    [motionData,perc_rect] = adp_filt(motionData); %B-SOiD function
                    motionData = motionData.*pixelValues;
                    
                    tic
                    for timeThreshold = 1:5
                        for motionThreshold = 1:100
                            [~,~,~,~, non_sleep_frames] = ...
                                DLC_awake_sleep_classify(dlcfiles,(motionThreshold * 0.5),timeThreshold, fps, motionData);
                            ROC_data.mouse(mouseidx).day(dayidx).begin(beginidx).analysis_data(timeThreshold).data(motionThreshold).classified = non_sleep_frames;
                            ROC_data.mouse(mouseidx).day(dayidx).begin(beginidx).analysis_data(timeThreshold).data(motionThreshold).percentRectified = perc_rect;
                            ROC_data.mouse(mouseidx).day(dayidx).begin(beginidx).analysis_data(timeThreshold).data(motionThreshold).motion_threshold = motionThreshold;
                        end
                        fprintf('finished %d\n', timeThreshold)
                    end
                    toc
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

save('C:\Users\nrive\Research\DLC-Analysis\roc_code\rocdata.mat','ROC_data','-v7.3')
