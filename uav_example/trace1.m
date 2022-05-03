% This file produce a trajectory of UAV controlled by a waypoint follower

% You can change trajectory here

% trajectory generator
% trajhandle = @step;
trajhandle = @circle;
% trajhandle = @diamond;
% trajhandle = @traj1;

runsim;
%%
x_1 =QP{1}.state_hist(1,:);
y_1 =QP{1}.state_hist(2,:);
z_1 = QP{1}.state_hist(3,:);
xdot_1 =QP{1}.state_hist(4,:);
ydot_1 = QP{1}.state_hist(5,:);
zdot_1 = QP{1}.state_hist(6,:);

trace_params = {'x', 'y', 'z', 'xdot','ydot', 'zdot'};
trace_1 = [x_1; y_1; z_1; xdot_1; ydot_1; zdot_1];

time_1 = 0:numel(x_1)-1; % in seconds

figure;
plot(z_1);
legend('MAV altitude trajectory 1');
xlabel("time (seconds)");
ylabel("Altitude (meters)");
%%
isBase = true;
% descrption of drone task (application)
% reqirements of task, predicate and temporal. design of alpha, beta.
% desired waypoint

% height constraints in a range
% justification of parameters.
% requirement that naturally needs resilience. package delivery.
[psi1, ~] = STL_Formula('psi1','alw_[30,50] z[t] >15', isBase, [10,20]); % control req
[psi11, ~] = STL_Formula('psi11','alw_[30,50] z[t] <25', isBase, [10,20]); % control req

% Drone height regulation
[psi2, ~] = STL_Formula('psi2','alw_[10,Inf] z[t] >=1', isBase, [3,20]); % safety req
[psi22, ~] = STL_Formula('psi22','alw_[0,Inf] z[t] <80', isBase, [3,20]); % safety req

% hover
[psi_hover, ~] = STL_Formula('psi3','alw_[120,Inf] z[t] <5', isBase, [5,6]); % control req

% paper: applicational meaning of the ReSV besides technical contribution

psi_height = STL_Formula('psi_height','psi1 and psi11', ~isBase);
psi_regulate = STL_Formula('psi_regulate','psi2 and psi22', ~isBase);

psi4 = STL_Formula('psi4','psi_height and psi_regulate', ~isBase);
psi_final = STL_Formula('psi_f','psi4 and psi3', ~isBase);

% resv2 = STL_EvalReSV(trace_params,time_1,trace_1, psi1,0);
% resv2 = STL_EvalReSV(trace_params,time_1,trace_1, psi11,0);
% resv2 = STL_EvalReSV(trace_params,time_1,trace_1, psi2,0);
% resv2 = STL_EvalReSV(trace_params,time_1,trace_1, psi22,0);
% disp_ReSV(resv2);

% test individual base case
resv4 = STL_EvalReSV(trace_params,time_1,trace_1, psi_hover,0);
disp_ReSV(resv4);

fprintf("The overall STL-based resilience formula is ...\n");
trace_1_formula_struct = tree_disp(psi_final,1,5)
resv5 = STL_EvalReSV(trace_params,time_1,trace_1, psi_final, 0);
disp_ReSV(resv5);
plot_ReSV(resv5);