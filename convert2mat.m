function K = convert2mat(path,videoFs, dv, baseTime)
% Using the path of an DLC output excel file as an input, this function will return the file as a matlab compatible data structure. 
    Ts = 1/videoFs;
    headers = ["timestamp",
               "nose_x";
               "nose_y",
               "midbody_x",
               "midbody_y",
               "baseOfTail_x",
               "baseOfTail_y",
               "leftFrontPaw_x",
               "leftFrontPaw_y",
               "rightFrontPaw_x",
               "rightFrontPaw_y",
               "leftBackPaw_x", 
               "leftBackPaw_y",
               "rightBackPaw_x",
               "rightBackPaw_y"];

    data = readmatrix(path);
    [data, rec] = adp_filt(data);
    
    data(:,2:15) = data(:,1:14);
    data(:,1) = 0:length(data)-1;

    for i = 1:length(data)     
        for j = 1:length(headers)            
            if(j == 1)
                K(i).(headers(j)) = baseTime + seconds((data(i,1)*Ts)+(dv*2*60));
            else
                K(i).(headers(j)) = data(i,j);
            end
        end
    end
end