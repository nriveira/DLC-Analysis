function analyzedK = distributionOfSpeed(K)
    analyzedK.velocityCounts = [];
    analyzedK.timeLength = [];
    analyzedK.bodyLength = [];
    for clip = 1:length(K.runTimes)
        analyzedK.velocityCounts = [analyzedK.velocityCounts mean(K.nose_vel(K.runTimes(clip).vidstart:K.runTimes(clip).vidstop))];
        analyzedK.timeLength = [analyzedK.timeLength K.runTimes(clip).totalSeconds];
        analyzedK.bodyLength = [analyzedK.bodyLength mean(K.nose2tail(K.runTimes(clip).vidstart:K.runTimes(clip).vidstop))];
    end
end