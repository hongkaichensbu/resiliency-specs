% This file produce a trajectory of UAV controlled by a waypoint follower

% You can change trajectory here

% trajectory generator
% trajhandle = @traj4;
trajhandle = @traj5;

runsim;
%%
InitReSV
load mavtraj.mat
QP= QP2;

x_4 =QP{1}.state_hist(1,:);
y_4 =QP{1}.state_hist(2,:);
z_4 = QP{1}.state_hist(3,:);
z_4(z_4<0) = 0;
xdot_4 =QP{1}.state_hist(4,:);
ydot_4 = QP{1}.state_hist(5,:);
zdot_4 = QP{1}.state_hist(6,:);

% compute distance to buildings
d_4 = zeros(1,numel(x_4));
for i = 1:numel(x_4)
    if x_4(i) <= -5 && x_4(i) >= -15 && y_4(i) <= -5  && y_4(i) >= -15 && z_4(i) <= 28 % rotation up
        if x_4(i) <= -6 && x_4(i) >= -14
            d_4(i)= -5-y_4(i);
        elseif x_4(i) > -6
            d_4(i) = sqrt((x_4(i)+6)^2+(y_4(i)+5)^2);
        else
            d_4(i) = sqrt((x_4(i)+14)^2+(y_4(i)+5)^2);
        end
    elseif x_4(i) <= -5 && x_4(i) >= -15 && y_4(i) <= -5  && y_4(i) >= -15 && z_4(i) > 28 % rotation higher than roof to entering roof
        d_4(i) = sqrt((y_4(i)+5)^2+(z_4(i)-28)^2);
    elseif x_4(i) <= -6 && x_4(i) >= -14 && y_4(i) <= 5  && y_4(i) > -5  % on the roof
        d_4(i) = z_4(i) - 28;
    elseif x_4(i) > -6 && x_4(i) < 6 && y_4(i) <= 5  && y_4(i) >= -5 % exit roof and before entering the second roof
        d1_tmp = sqrt((x_4(i)+6)^2+(z_4(i)-28)^2);
        d2_tmp = sqrt((x_4(i)-6)^2+(z_4(i)-18)^2);
        d_4(i)  =  min(d1_tmp, d2_tmp);
    elseif x_4(i)>=6 && x_4(i) <=14 && y_4(i) <=0 && y_4(i) >= -10% on the second roof
        d_4(i) = z_4(i) - 18;
%         z_4(i) - 18
    elseif x_4(i)>= -5 && x_4(i) <=6 && y_4(i) <= -5 && y_4(i) >= -15 % return to base
        pt = [x_4(i); y_4(i); z_4(i)];
        v1 = [-6;-5;0];
        v2 = [-6;-5;28];
        d1_tmp = point_to_line(pt, v1, v2);
        v3 = [6;-10;18];
        v4 = [6;0;18];
        v5 = [6;-10;0];
        d2_tmp = point_to_line(pt, v3, v4);
        d3_tmp = point_to_line(pt, v3, v5);
        d_4(i) = min(d1_tmp,min(d2_tmp,d3_tmp));
    end
end

trace_params = {'x', 'y', 'z', 'xdot','ydot', 'zdot','d'};
trace_4 = [x_4; y_4; z_4; xdot_4; ydot_4; zdot_4; d_4];
%
% time_4 = 0:numel(x_4)-1; % in seconds

time_4 = QP{1}.time_hist;

isBase = true;

time_4 = time_4(1:end-1);
x_4 = x_4(1:end-1);
y_4 = y_4(1:end-1);
z_4 = z_4(1:end-1);
xdot_4 = xdot_4(1:end-1);
ydot_4 = ydot_4(1:end-1);
zdot_4 = zdot_4(1:end-1);
d_4 = d_4(1:end-1);
trace_4 = [x_4; y_4; z_4; xdot_4; ydot_4; zdot_4; d_4];
%
%%
% figure;
% subplot(4,1,1);
% plot(x_4);
% % legend('MAV altitude trajectory 4');
% xlabel("time (seconds)");
% ylabel("X (meters)");
% subplot(4,1,2);
% plot(y_4);
% xlabel("time (seconds)");
% ylabel("Y (meters)");
% subplot(4,1,3);
% plot(z_4);
% xlabel("time (seconds)");
% ylabel("Z (meters)");
% subplot(4,1,4);
% plot(d_4);
% xlabel("time (seconds)");
% ylabel("distance (meters)");

line_color = 'b';
line_width = 2;
labels = {'x [m]', 'y [m]', 'z [m]', 'd [m]'};
figure;
state = [x_4;y_4;z_4;d_4];

tt = tiledlayout(4,1,'TileSpacing','none','Padding','Compact');

for i = 1:4
% subplot(4, 1, i)
nexttile
hold on
plot(time_4, state(i,:), line_color, 'LineWidth', line_width);
hold off
xlim([time_4(1), time_4(end)])
grid off
xlabel('time [s]', 'FontSize',14);
if i~=4
    xticks([])
end
switch i
    case 1
        yticks([-10,0,10])%, 'FontSize',6);
    case 2
        yticks([-10,-5,0])
    case 3
        yticks([0,10,20])
    case 4
        yticks([0,4,8])
end
        
ylabel(labels{i},'rotation',0,'HorizontalAlignment','right', 'FontSize',14);
end
print('MAV_coordinate3','-dpng','-r400')
%% Put temporal operators as BASE CASE STL-based Res Spec
isBase = true;
% Drone height constraints
[psi_height, ~] = STL_Formula('psi2','alw_[0,104.05] z[t] <= 120', isBase, [4,4]); 
tic
resv_height2 = STL_EvalReSV(trace_params,time_4,trace_4, psi_height,0);
toc
disp_ReSV(resv_height2);

% Drone delivery
[psi_delivery1, ~] = STL_Formula('psi3','ev_[0,43] alw_[0,1] (x[t]+10)^2+(y[t]-0)^2+(z[t]-30)^2<1', isBase, [4,4]); 
[psi_delivery2, ~] = STL_Formula('psi4','ev_[0,65] alw_[0,3] (x[t]-10)^2+(y[t]+5)^2+(z[t]-20)^2<1', isBase, [4,4]); 
tic
resv_delivery1 = STL_EvalReSV(trace_params,time_4,trace_4, psi_delivery1,0);
disp_ReSV(resv_delivery1);
toc
tic
resv_delivery2 = STL_EvalReSV(trace_params,time_4,trace_4, psi_delivery2,0);
disp_ReSV(resv_delivery2);
toc

% collision avoidance
[psi_collision_avoid, ~] = STL_Formula('psi_collision_avoid','alw_[0,104.05] d[t] >= 2', isBase, [4,4]); 
tic
resv_collision_avoid = STL_EvalReSV(trace_params,time_4,trace_4, psi_collision_avoid,0);
toc
disp_ReSV(resv_collision_avoid);

%% Put temporal operators outside the BASE CASE STL-based Res Spec
isBase = true;
% Drone height constraints
[psi_height2, ~] = STL_Formula('psi2','z[t] <= 120', isBase, [4,4]); 
[psi_height2_full, ~] = STL_Formula('psi2_full','alw_[0,130] psi2', ~isBase); 
tic
resv_height2 = STL_EvalReSV(trace_params,time_4,trace_4, psi_height2_full,0);
toc
disp_ReSV(resv_height2);

% Drone delivery
[psi_delivery1, ~] = STL_Formula('psi3','(x[t]+10)^2+(y[t]-0)^2+(z[t]-30)^2<1', isBase, [4,4]); 
[psi_delivery2, ~] = STL_Formula('psi4','(x[t]-10)^2+(y[t]+5)^2+(z[t]-20)^2<1', isBase, [4,4]); 

[psi_delivery1_full1, ~] = STL_Formula('psi3_full1','alw_[0,1] psi3', ~isBase); 
[psi_delivery1_full2, ~] = STL_Formula('psi3_full2', 'ev_[0,43] psi3_full1', ~isBase);

% for delivery 2, we need to start G from a point that makes the reovery in
% the first episode shorter than that in the second since the duration in
% the second is larger than the first (perhaps we could play with alpha and beta to
% make them equivalent wrt to resiliency but the ordering is final). The
% second episode should be start from a small portion of its recovery for
% the same reasons.
[psi_delivery2_full1, ~] = STL_Formula('psi4_full1','alw_[0,3] psi4', ~isBase); 
[psi_delivery2_full2, ~] = STL_Formula('psi4_full2', 'ev_[0,65] psi4_full1', ~isBase);

tic
resv_delivery1 = STL_EvalReSV(trace_params,time_4,trace_4, psi_delivery1_full2,0);
disp_ReSV(resv_delivery1);
toc
tic
resv_delivery2 = STL_EvalReSV(trace_params,time_4,trace_4, psi_delivery2_full2,0);
disp_ReSV(resv_delivery2);
toc

% collision avoidance
[psi_collision_avoid, ~] = STL_Formula('psi_collision_avoid','d[t] >= 1.5', isBase, [4,4]); 
[psi_collision_avoid_full, ~] = STL_Formula('psi_collision_avoid_full','alw_[0,130] psi_collision_avoid', ~isBase); 
tic
resv_collision_avoid = STL_EvalReSV(trace_params,time_4,trace_4, psi_collision_avoid_full,0);
toc
disp_ReSV(resv_collision_avoid);