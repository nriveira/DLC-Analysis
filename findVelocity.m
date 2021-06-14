function vel = findVelocity(K, b, Fs)
    maxVelocity = 50;
    filtLength = 30;
    filt = (1/filtLength)*ones(1,filtLength);
    
    body_x = strcat(b, '_x');
    body_y = strcat(b, '_y');

    x = cell2mat({K(:).(body_x)})';
    x = conv(x, filt);
    x = x(ceil(filtLength/2):end-floor(filtLength/2));
    
    y = cell2mat({K(:).(body_y)})';
    y = conv(y, filt);
    y = y(ceil(filtLength/2):end-floor(filtLength/2));
    
    pos = [x y];
    vel = zeros(1,length(pos));
    for i = 2:length(pos)
        a = sqrt((pos(i,1)-pos(i-1,1))^2 + (pos(i,2)-pos(i-1,2))^2)/(Fs);
       if(a < maxVelocity)
           vel(i) = a;
       else
           vel(i) = vel(i-1);
       end
    end
    
    vel = conv(vel, filt);
    vel = vel(ceil(filtLength/2):end-floor(filtLength/2));
end