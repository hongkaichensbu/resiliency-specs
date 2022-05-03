% This file produce a trajectory of UAV controlled by a waypoint follower

% You can change trajectory here

% trajectory generator
% trajhandle = @step;
% trajhandle = @circle;
% trajhandle = @diamond;
trajhandle = @traj3;

runsim;
%%
x_3 =QP{1}.state_hist(1,:);
y_3 =QP{1}.state_hist(2,:);
z_3 = QP{1}.state_hist(3,:);
xdot_3 =QP{1}.state_hist(4,:);
ydot_3 = QP{1}.state_hist(5,:);
zdot_3 = QP{1}.state_hist(6,:);

trace_params = {'x', 'y', 'z', 'xdot','ydot', 'zdot'};
trace_3 = [x_3; y_3; z_3; xdot_3; ydot_3; zdot_3];

time_3 = 0:numel(x_3)-1; % in seconds
figure;
plot(z_3);
legend('MAV altitude trajectory 3');
xlabel("time (seconds)");
ylabel("Altitude (meters)");
%%
isBase = true;
% Drone height constraints
[psi2, ~] = STL_Formula('psi2','alw_[10,Inf] z[t] >=10', isBase, [3,20]); 
[psi22, ~] = STL_Formula('psi22','alw_[0,Inf] z[t] <15', isBase, [3,20]); 

psi_final = STL_Formula('psi_f','psi2 and psi22', ~isBase);

% test individual base case
resv = STL_EvalReSV(trace_params,time_1,trace_1, psi22,0);
disp_ReSV(resv);

resv = STL_EvalReSV(trace_params,time_3,trace_3, psi_final,0);
disp_ReSV(resv);