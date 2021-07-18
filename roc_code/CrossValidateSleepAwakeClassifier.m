%% Extracting Verified Calls and ROC Data
load BehaviorHandScoredwSWDdata_v3.mat
addpath('C:\Users\nrive\Research\DLC-Analysis\roc_code')

behaviorEval = 'walk';
classDirRoot = 'C:\Users\nrive\Research\AnkG\DLC_Vids\DLC_Vids\';
fps = 30;
motion = [];
idx = 1;

for mouseidx = 1:length(Mouse)
    mouseName = Mouse(mouseidx).name;
    for dayidx = 1:length(Mouse(mouseidx).Day)
        dayName = Mouse(mouseidx).Day(dayidx).name;
        for beginidx = 1:length(Mouse(mouseidx).Day(dayidx).Begin)
            if isfield(Mouse(mouseidx).Day(dayidx).Begin,'allBehaviors') == 1
                beginName = Mouse(mouseidx).Day(dayidx).Begin(beginidx).name;
                
                motion(idx).mouseName = mouseName;
                motion(idx).dayName = dayName;
                motion(idx).beginName = beginName;
                
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
                    
                    motion(idx).dlcfiles = dlcfiles;
                    motion(idx).motionData = motionData;
                    motion(idx).perc_rect = perc_rect;
                    idx = idx+1;
                end
            end
        end
    end
end

save('C:\Users\nrive\Research\DLC-Analysis\roc_code\motion.mat','motion','-v7.3')
