function [desired_state] = traj5(t, qn)
% A realistic trajectory that the drone starts from the ground of next to
% a building, ascends to the roof of the building and hovering for a while
% then returns to the ground. 
% The trajectory could be divided into three segments
% 1. rotational up (multiple recovery for proximity requirement)
% 2. Trangular delivery (two attempts at each location).
% 3. rotational down (multiple recovery for proximity requirement)

% =================== Your code goes here ===================
% You have to set the pos, vel, acc, yaw and yawdot variables

time_tol = 120;
dt = 0.001;
radius = 4.5;
ground_center = [10;10];
delivery_center_1 = [-10;0];
delivery_center_2 = [10;-5];

% angle when t = time_tol/3
angle_1 = tj_from_line(0, 4*pi, time_tol/3, time_tol/3);
[x_1,y_1] = pos_from_angle(angle_1);
pos_1 = [x_1 ; y_1] - ground_center;

% position where the landing starts
% pos_2 = [-pos_1(1); pos_1(2)];
pos_2 = [-4.5; -10];

% angle when t = 0
angle_0 = tj_from_line(0, 4*pi, time_tol/3, 0);
[x_0,y_0] = pos_from_angle(angle_0);
pos_0 = [x_0 ; y_0] - ground_center;

    function [x,y] = pos_from_angle(a)
        x = radius*cos(a);
        y = radius*sin(a);
    end

    function [pos, vel] = get_pos_vel(t)
        if t >= time_tol  % after the trajectory
            pos = [pos_2;0];
            vel = [0;0;0];
        elseif t >= 0 && t < time_tol/3  % rotational up
            angle = tj_from_line(0, 4*pi, time_tol/3, t);
            [x,y] = pos_from_angle(angle);
            [pos, vel, ~] = tj_from_line([0;0;0], [0;0;30], time_tol/3, t);
            pos(1) = x - ground_center(1);
            pos(2) = y - ground_center(2);
        elseif t >= time_tol/3 && t < time_tol*2/3  % triangular delivery (9 steps)
            delivery_ts = [1:9]/9;
            if t < time_tol/3 + time_tol/3 * delivery_ts(1)
%                 [pos, vel, ~] = tj_from_line([pos_1;30], [delivery_center_1;30], time_tol/3 * delivery_ts(1), t-time_tol/3);
                [pos, vel, ~] = tj_from_line([pos_1;30], [delivery_center_1+[-1.5;+2];30], time_tol/3 * delivery_ts(1), t-time_tol/3);
            elseif t < time_tol/3 + time_tol/3 * delivery_ts(2)
%                 [pos, vel, ~] = tj_from_line([delivery_center_1;30],[delivery_center_1;33], time_tol/3 * delivery_ts(1),  t-time_tol/3-time_tol/3 * delivery_ts(1));
                [pos, vel, ~] = tj_from_line([delivery_center_1+[-1.5;+2];30],[delivery_center_1;30], time_tol/3 * delivery_ts(1),  t-time_tol/3-time_tol/3 * delivery_ts(1));
            elseif t < time_tol/3 + time_tol/3 * delivery_ts(3)
                [pos, vel, ~] = tj_from_line([delivery_center_1;30],[delivery_center_1;30], time_tol/3 * delivery_ts(1),  t-time_tol/3-time_tol/3 * delivery_ts(2));
            elseif t < time_tol/3 + time_tol/3 * delivery_ts(4)
%                 [pos, vel, ~] = tj_from_line([delivery_center_1;30],[delivery_center_1;31], time_tol/3 * delivery_ts(1),  t-time_tol/3-time_tol/3 * delivery_ts(3));
                [pos, vel, ~] = tj_from_line([delivery_center_1;30],[0;0;30], time_tol/3 * delivery_ts(1),  t-time_tol/3-time_tol/3 * delivery_ts(3));
            elseif t < time_tol/3 + time_tol/3 * delivery_ts(5)
%                 [pos, vel, ~] = tj_from_line([delivery_center_1;31],[delivery_center_2;20], time_tol/3 * delivery_ts(1),  t-time_tol/3-time_tol/3 * delivery_ts(4));
                [pos, vel, ~] = tj_from_line([0;0;30],[delivery_center_2+[0;0.5];20], time_tol/3 * delivery_ts(1),  t-time_tol/3-time_tol/3 * delivery_ts(4));
            elseif t < time_tol/3 + time_tol/3 * delivery_ts(6)
%                 [pos, vel, ~] = tj_from_line([delivery_center_2;20],[delivery_center_2;23], time_tol/3 * delivery_ts(1),  t-time_tol/3-time_tol/3 * delivery_ts(5));
                [pos, vel, ~] = tj_from_line([delivery_center_2+[0;0.5];20],[delivery_center_2+[2.5;0];20], time_tol/3 * delivery_ts(1),  t-time_tol/3-time_tol/3 * delivery_ts(5));
            elseif t < time_tol/3 + time_tol/3 * delivery_ts(7)
%                 [pos, vel, ~] = tj_from_line([delivery_center_2;23],[delivery_center_2;20], time_tol/3 * delivery_ts(1),  t-time_tol/3-time_tol/3 * delivery_ts(6));
                [pos, vel, ~] = tj_from_line([delivery_center_2+[2.5;0];20],[delivery_center_2+[0;-0.5];20], time_tol/3 * delivery_ts(1),  t-time_tol/3-time_tol/3 * delivery_ts(6));
            elseif t < time_tol/3 + time_tol/3 * delivery_ts(8)
                [pos, vel, ~] = tj_from_line([delivery_center_2+[0;-0.5];20],[delivery_center_2+[0;-0.5];20], time_tol/3 * delivery_ts(1),  t-time_tol/3-time_tol/3 * delivery_ts(7));
            else 
                [pos, vel, ~] = tj_from_line([delivery_center_2+[0;-0.5];20],[pos_2;20], time_tol/3 * delivery_ts(1), t-time_tol/3-time_tol/3 * delivery_ts(8));
            end
        else % rotational down
%             angle_s = tj_from_line(0, 4*pi, time_tol/3, t-time_tol*2/3);
%             angle_e = tj_from_line(0, 4*pi, time_tol/3, t-time_tol*2/3+dt);
%             [x1,y1] = pos_from_angle(angle_s);
%             [x2,y2] = pos_from_angle(angle_e);
%             [pos_s, vel_s, ~] = tj_from_line([0;0;30], [0;0;0], time_tol/3, t-time_tol*2/3);
%             [pos_e, vel_e, ~] = tj_from_line([0;0;30], [0;0;0], time_tol/3, t-time_tol*2/3+dt);
%             pos = [x1-ground_center(1);y1-ground_center(2);0] + pos_s;
%             vel = [[x2-x1;y2-y1]/dt;0] + vel_s;
%             angle = tj_from_line(0, 4*pi, time_tol/3, t-time_tol*2/3);
%             [x,y] = pos_from_angle(angle);
            [pos, vel, ~] = tj_from_line([pos_2;20], [pos_2;0], time_tol/3, t-time_tol*2/3);
%             pos(1) = x - ground_center(1);
%             pos(2) = y - ground_center(2);
        end
    end

    if t >= time_tol
        pos = [pos_2;0];
        vel = [0;0;0];
        acc = [0;0;0];
    else
        [pos, vel] = get_pos_vel(t);
        [pos1, vel1] = get_pos_vel(t+dt);
%         if t>38
%         disp("compute traj");
%         end
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


