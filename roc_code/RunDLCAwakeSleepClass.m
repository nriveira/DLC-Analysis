%% Define Based on ROC
motionThreshold = 85;
motionThreshold = 95; %Higher sensitivity but also FPR
%% Running DLC awake-sleep classifier
miceList = {'3','4','5','8','9','10','12','16','17','18','19','20','22','23'};
miceGen = {'1','1','1','2','2','2','2','3','3','3','3','3','1'};
timeThreshold = 40;
fps = 30;
for miceidx = 1:length(miceList)
<<<<<<< HEAD
    dirMouse = "C:\Users\nrive\Research\AnkG\DLC_Vids\DLC_Vids\Mouse";
=======
    %dirName = '/work/07432/enriquev/stampede2/MATLAB/DLC_Vids/Mouse-';
    dirMouse = 'C:\Users\evp02\Documents\MATLAB\DLC_Vids\DLC_Vids\Mouse';
>>>>>>> 1ef9a4eefdd0d401dfc2b619e1f06d7f920907ee
    mouseClass.mouseNum = miceList(miceidx);
    dirMouse = char(strcat(dirMouse,miceList(miceidx)));
    dayfiles = dir(fullfile(dirMouse));
    dayfiles = natsortfiles(dayfiles);
    dayfiles = {dayfiles.name}';
    dayfiles = dayfiles(3:end);
    for dayidx = 1:length(dayfiles)
        dirDay = char(strcat(dirMouse,'\',dayfiles{dayidx}));
        beginfiles = dir(fullfile(dirDay));
        beginfiles = natsortfiles(beginfiles);
        beginfiles = {beginfiles.name}';
        beginfiles = beginfiles(3:end);
        for beginidx = 1:length(beginfiles)
            dirBegin = char(strcat(dirDay,'\',beginfiles{beginidx}));
            cd(dirBegin)
            dlcfiles = dir(fullfile(dirBegin,'*.csv'));
            dlcfiles = natsortfiles(dlcfiles);
            dlcfiles = {dlcfiles.name}';
            [centroids,deltas,deltapercentiles,sleep_awake_frames,perc_rect,non_sleep_frames] = ...
                DLC_awake_sleep_classify(dlcfiles,motionThreshold,timeThreshold,fps);
            mouseClass.classified = sleep_awake_frames;
            mouseClass.percentiles = deltapercentiles;
            mouseClass.motionDeltas = deltas;
            mouseClass.positionCenters = centroids;
            mouseClass.percentRect = perc_rect;
            mouseAwakeNonMoving.data = non_sleep_frames;
            save sleepAwakeMice.mat mouseClass
            save mouseAwakeNonMoving.mat mouseAwakeNonMoving;
        end
    end
end

    