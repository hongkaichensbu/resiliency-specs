InitReSV
load flocktraj.mat
%%
traj_2d_figure;
close all
%%
% trace_params = {'x', 'y', 'xdot','ydot', 'cost', 'cc'};
% trace = [x_boid; y_boid; x_dot_boid; y_dot_boid; J_array; number_array];
trace_params = {'cost', 'cc'};
trace = [J_array; number_array];

isBase = true;
time = 0:length(x_boid)-1;
time = time/10;
%%
figure;
plot(J_array<=500)
ylim([-1/2,3/2])
figure;
plot(number_array == 1)
%%
[psi_cost, ~] = STL_Formula('psi1','alw_[0,500] ev_[0,60] cost[t] <= 500', isBase, [30,30]);
tic
resv_cost = STL_EvalReSV(trace_params,time,trace, psi_cost,0);
toc
disp_ReSV(resv_cost);

[psi_cc, ~] = STL_Formula('psi2','alw_[0,500] ev_[0,60] cc[t] <= 1', isBase, [30,30]);
tic
resv_cc = STL_EvalReSV(trace_params,time,trace, psi_cc,0);
toc
disp_ReSV(resv_cc);

%% Put temporal operators outside the BASE CASE STL-based Res Spec
isBase = true;
%
[psi_cost, ~] = STL_Formula('psi1','cost[t] <= 500', isBase, [30,30]);
[psi_cost_full, ~] = STL_Formula('psi1_full','ev_[0,60] psi1', ~isBase);
[psi_cost_full2, ~] = STL_Formula('psi1_full2','alw_[0,500] psi1_full', ~isBase);
tic
resv_cost = STL_EvalReSV(trace_params,time,trace, psi_cost_full2,0);
toc
disp_ReSV(resv_cost);

% resv_cost = STL_EvalReSV(trace_params,time,trace, psi_cost, 100.3);
% disp_ReSV(resv_cost);
%%
[psi_cc, ~] = STL_Formula('psi2','cc[t] <= 1', isBase, [30,30]);
[psi_cc_full, ~] = STL_Formula('psi2_full','ev_[0,60] psi2', ~isBase);
[psi_cc_full2, ~] = STL_Formula('psi1_full2','alw_[0,500] psi2_full', ~isBase);
tic
resv_cc = STL_EvalReSV(trace_params,time,trace, psi_cc_full2,0);
toc
disp_ReSV(resv_cc);