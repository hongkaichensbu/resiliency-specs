function [pos, vel, acc] = tj_from_line(start_pos, end_pos, time_ttl, t_c)
    v_max = (end_pos-start_pos)*2/time_ttl; % linearly accelarated/decelarated
    if t_c >= 0 & t_c < time_ttl/2  % accelarate for half of the time and decelarate for the other half
        vel = v_max*t_c/(time_ttl/2);
        pos = start_pos + t_c*vel/2;
        acc = [0;0;0];
    else
        vel = v_max*(time_ttl-t_c)/(time_ttl/2);
        pos = end_pos - (time_ttl-t_c)*vel/2;
        acc = [0;0;0];
    end
end