function K = convert2mat(path,videoFs, dv)
% Using the path of an DLC output excel file as an input, this function will return the file as a matlab compatible data structure. 
    Ts = 1/videoFs;

    [data, headers, ~] = xlsread(path);
    
    headers(1,:) = [];

    for i = 1:length(headers(1,:))
        headers(1,i) = strrep(strcat(headers(1,i), '_', headers(2,i)), ' ', '');
        headers(1,i) = strrep(headers(1,i), '-', '_');
    end
    headers(2,:) = [];
    headers{1,1} = 'timestamp';

    for i = 1:length(data)     
        for j = 1:length(data(1,:))
            % Do something different for the timestamp, otherwise add it to the struct.
            if(j == 1)
                K(i).(headers{1,j}) = seconds((data(i,j)*Ts)+ dv*120);
            else
                K(i).(headers{1,j}) = data(i,j);
            end
        end
    end
end

