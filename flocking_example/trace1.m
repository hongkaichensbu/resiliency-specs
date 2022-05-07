% This file implements the FLock Formation cast study in "An STL-based Formulation of Resilience in Cyber-Physical Systems"

InitReSV
load flocktraj.mat
%% Plot Figure 4
traj_2d_figure;
% close all
%% Prepare Trajectories
trace_params = {'cost', 'cc'};
trace = [J_array; number_array];

isBase = true;
time = 0:length(x_boid)-1;
time = time/10;
%% Generate results of Table 3
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

%% Generate results in Table 4
isBase = true;

[psi_cost, ~] = STL_Formula('psi1','cost[t] <= 500', isBase, [30,30]);
[psi_cost_full, ~] = STL_Formula('psi1_full','ev_[0,60] psi1', ~isBase);
[psi_cost_full2, ~] = STL_Formula('psi1_full2','alw_[0,500] psi1_full', ~isBase);
tic
resv_cost = STL_EvalReSV(trace_params,time,trace, psi_cost_full2,0);
toc
disp_ReSV(resv_cost);

[psi_cc, ~] = STL_Formula('psi2','cc[t] <= 1', isBase, [30,30]);
[psi_cc_full, ~] = STL_Formula('psi2_full','ev_[0,60] psi2', ~isBase);
[psi_cc_full2, ~] = STL_Formula('psi1_full2','alw_[0,500] psi2_full', ~isBase);
tic
resv_cc = STL_EvalReSV(trace_params,time,trace, psi_cc_full2,0);
toc
disp_ReSV(resv_cc);