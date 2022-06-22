% This file implements the FLock Formation cast study in "An STL-based Formulation of Resilience in Cyber-Physical Systems"

InitReSV
load flocktraj.mat
%% Plot Figure 4
traj_2d_figure;

%% Plot figure 5
plot_flock_snapshots;

%% Prepare Trajectories
trace_params = {'cost', 'cc'};
trace = [J_array; number_array];

isBase = true;
time = 0:length(x_boid)-1;
time = time/10;
%% Generate results of Table 3
[psi_cost_tb3, ~] = STL_Formula('psi1','alw_[0,500] ev_[0,60] cost[t] <= 500', isBase, [30,30]);
tic
resv_cost_tb3 = STL_EvalReSV(trace_params,time,trace, psi_cost_tb3,0);
resv_cost_tb3_et = toc;
disp_ReSV(resv_cost_tb3);

[psi_cc_tb3, ~] = STL_Formula('psi2','alw_[0,500] ev_[0,60] cc[t] <= 1', isBase, [30,30]);
tic
resv_cc_tb3 = STL_EvalReSV(trace_params,time,trace, psi_cc_tb3,0);
resv_cc_tb3_et = toc;
disp_ReSV(resv_cc_tb3);

%% Generate results in Table 4
isBase = true;

[psi_cost_tb4, ~] = STL_Formula('psi1','cost[t] <= 500', isBase, [30,30]);
[psi_cost_full_tb4, ~] = STL_Formula('psi1_full','ev_[0,60] psi1', ~isBase);
[psi_cost_full2_tb4, ~] = STL_Formula('psi1_full2','alw_[0,500] psi1_full', ~isBase);
tic
resv_cost_tb4 = STL_EvalReSV(trace_params,time,trace, psi_cost_full2_tb4,0);
resv_cost_tb4_et = toc;
disp_ReSV(resv_cost_tb4);

[psi_cc_tb4, ~] = STL_Formula('psi2','cc[t] <= 1', isBase, [30,30]);
[psi_cc_full_tb4, ~] = STL_Formula('psi2_full','ev_[0,60] psi2', ~isBase);
[psi_cc_full2_tb4, ~] = STL_Formula('psi1_full2','alw_[0,500] psi2_full', ~isBase);
tic
resv_cc_tb4 = STL_EvalReSV(trace_params,time,trace, psi_cc_full2_tb4,0);
resv_cc_tb4_et = toc;
disp_ReSV(resv_cc_tb4);