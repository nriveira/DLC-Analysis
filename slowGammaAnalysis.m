for m = 1:length(mouseInfo)
    group = mouseInfo(m).group;
    mouseName = mouseInfo(m).mouseName;
    bodypart = "midbody";
    velocityTime = [];

    for i = 1:length(mouseName)
        if(mouseName(i) ~= "Mouse-19")
            load(strcat("C:\Users\nrive\Research\AnkG\kinematicInformation\awakeRest\", mouseName(i)))

        end
    end
end