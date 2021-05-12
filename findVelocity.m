function vel = findVelocity(K, rollingAvg, bodypart)
    filt = ones(1,rollingAvg)./ rollingAvg;

    body_x = strcat(bodypart, '_x');
    body_y = strcat(bodypart, '_y');

    x = cell2mat({K(:).(body_x)})';
    x = conv(x,filt);
    x = x(floor(rollingAvg/2)+1:end-floor(rollingAvg/2));

    y = cell2mat({K(:).(body_y)})';
    y = conv(y,filt);
    y = y(floor(rollingAvg/2)+1:end-floor(rollingAvg/2));

    pos = [x y];
    vel = zeros(1,length(pos));
    for i = 2:length(pos)
        a = (pos(i,1)-pos(i-1,1))^2 + (pos(i,2)-pos(i-1,2))^2;
        vel(i) = a;
    end

    vel = conv(vel,filt)';
    vel = vel(floor(rollingAvg/2)+1:end-floor(rollingAvg/2));
end