function [desired_state] = traj1(t, qn)
% DIAMOND trajectory generator for a diamond

% =================== Your code goes here ===================
% You have to set the pos, vel, acc, yaw and yawdot variables

time_tol = 12;
dt = 0.0001;

    function [pos, vel] = get_pos_vel(t)
        if t >= time_tol
            pos = [0;0;5];
            vel = [0;0;0];
        elseif t >= 0 & t < time_tol/10
            % from [0;0;0] to [1/4;sqrt(2);sqrt(2)]
            [pos, vel, ~] = tj_from_line([0;0;0], [0;0;15], time_tol/10, t);
        elseif t >= time_tol/10 & t < time_tol/2
            % from [1/4;sqrt(2);sqrt(2)] to [1/2;0;2*sqrt(2)]
            [pos, vel, ~] = tj_from_line([0;0;20], [0;0;20], time_tol*(2/5), t-time_tol/10);
        elseif t >= time_tol/2 & t < time_tol* 0.6
            % from [1/2;0;2*sqrt(2)] to [3/4; -sqrt(2); sqrt(2)]
            [pos, vel, ~] = tj_from_line([0;0;20], [0;0;5], time_tol*(0.1), t-time_tol/2);
        else
            % from [3/4; -sqrt(2); sqrt(2)] to [1;0;0]
            [pos, vel, ~] = tj_from_line([0;0;5], [0;0;5], time_tol*(0.4), t-time_tol*0.6);
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


