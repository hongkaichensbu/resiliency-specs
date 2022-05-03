function [desired_state] = traj3(t, qn)
% DIAMOND trajectory generator for a diamond

% =================== Your code goes here ===================
% You have to set the pos, vel, acc, yaw and yawdot variables

time_tol = 50;
dt = 0.0001;

    function [pos, vel] = get_pos_vel(t)
        if t >= time_tol
            pos = [0;0;5];
            vel = [0;0;0];
        elseif t >= 0 & t < time_tol/8
            [pos, vel, ~] = tj_from_line([0;0;0], [0;0;20], time_tol/8, t);
        elseif t >= time_tol/8 & t < time_tol/4
            [pos, vel, ~] = tj_from_line([0;0;20], [0;0;6], time_tol/8, t-time_tol/8);
        elseif t >= time_tol/4 & t < time_tol*3/8
            [pos, vel, ~] = tj_from_line([0;0;6], [0;0;20], time_tol/8, t-time_tol*2/8);
        elseif t >= time_tol*3/8 & t < time_tol/2
            [pos, vel, ~] = tj_from_line([0;0;20], [0;0;7], time_tol/8, t-time_tol*3/8);
        elseif t >= time_tol/2 & t < time_tol*5/8
            [pos, vel, ~] = tj_from_line([0;0;7], [0;0;20], time_tol/8, t-time_tol*4/8);
        elseif t >= time_tol*5/8 & t < time_tol*3/4
            [pos, vel, ~] = tj_from_line([0;0;20], [0;0;8], time_tol/8, t-time_tol*5/8);
        elseif t >= time_tol*3/4 & t < time_tol*7/8
            [pos, vel, ~] = tj_from_line([0;0;8], [0;0;20], time_tol/8, t-time_tol*6/8);
        else
            [pos, vel, ~] = tj_from_line([0;0;20], [0;0;3], time_tol/8, t-time_tol*7/8);
        end
    end

    if t >= time_tol
        pos = [0;0;5];
        vel = [0;0;0];
        acc = [0;0;0];
    else
        [pos, vel] = get_pos_vel(t);
        [~, vel1] = get_pos_vel(t+dt);
        acc = (vel1-vel)/dt;
    end
    
yaw = 0;
yawdot = 0;

% =================== Your code ends here ===================

desired_state.pos = pos(:);
desired_state.vel = vel(:);
desired_state.acc = acc(:);
desired_state.yaw = yaw;
desired_state.yawdot = yawdot;

end


