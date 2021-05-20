function angle = findAngle(K, b1, b2, b3)
%FINDDISTANCEBETWEEN finds the distance between two body parts for a deeplabcut output. 
%   Called by convertDLCOutput function    
    body_x1 = strcat(b1, '_x');
    body_y1 = strcat(b1, '_y');
    x1 = cell2mat({K(:).(body_x1)})';
    y1 = cell2mat({K(:).(body_y1)})';
    point1 = [x1 y1];
    
    body_x2 = strcat(b2, '_x');
    body_y2 = strcat(b2, '_y');
    x2 = cell2mat({K(:).(body_x2)})';
    y2 = cell2mat({K(:).(body_y2)})';
    point2 = [x2 y2];
    
    body_x3 = strcat(b3, '_x');
    body_y3 = strcat(b3, '_y');
    x3 = cell2mat({K(:).(body_x3)})';
    y3 = cell2mat({K(:).(body_y3)})';
    point3 = [x3 y3];
    
    angle = zeros(length(point1),1);
    
    for i = 1:length(angle)
        angle(i,1) = atan2(abs(det([point3(i,:)-point1(i,:); point2(i,:)-point1(i,:)])), dot(point3(i,:)-point1(i,:), point2(i,:)-point1(i,:)));
    end
end