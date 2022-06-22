%% Section 1: Initialize SRS logic and the modified Breach framework
InitReSV;
mkdir tables
mkdir figures
addpath("tables")
addpath("figures")
%% Section 2: Run example 2 in the paper
fprintf('The following reprduces example 2.\n');
example2_plot;
close all
%% Section 3: Run UAV case study
fprintf('The following reprduces UAV package delivery case study.\n');
trace_uav;
close all
% write table 1 into a xls file. 
Cols = ["SRS Formula", "r(\psi_i,\xi,0)", "Execution time (sec)"];
writematrix(Cols,'tables\Table1.xls','Range','A1:C1');
[alpha_beta, resv_values] = resv2mat(resv_height2_tb1); % Table 1, Row 2
writematrix(["\psi_1 = R_"+alpha_beta(1)+","+alpha_beta(2)+"(\varphi_1)", ...
    resv_values(1), num2str(resv_height2_tb1_et)], 'tables\Table1.xls','Range','A2:C2');
[alpha_beta, resv_values] = resv2mat(resv_delivery1_tb1); % Table 1, Row 3
writematrix(["\psi_2 = R_"+alpha_beta(1)+","+alpha_beta(2)+"(\varphi_2)", ...
    resv_values(1), num2str(resv_delivery1_tb1_et)], 'tables\Table1.xls','Range','A3:C3');
[alpha_beta, resv_values] = resv2mat(resv_delivery2_tb1); % Table 1, Row 4
writematrix(["\psi_3 = R_"+alpha_beta(1)+","+alpha_beta(2)+"(\varphi_3)", ...
    resv_values(1), num2str(resv_delivery2_tb1_et)], 'tables\Table1.xls','Range','A4:C4');
[alpha_beta, resv_values] = resv2mat(resv_collision_avoid_tb1); % Table 1, Row 5
writematrix(["\psi_4 = R_"+alpha_beta(1)+","+alpha_beta(2)+"(\varphi_4)", ...
    resv_values(1), num2str(resv_collision_avoid_tb1_et)], 'tables\Table1.xls','Range','A5:C5');

% write table 2 into a xls file. 
Cols = ["SRS Formula", "r(\psi'_i,\xi,0)", "Corresponding SRS atoms", "Execution time (sec)"];
writematrix(Cols,'tables\Table2.xls','Range','A1:D1');
[alpha_beta, resv_values] = resv2mat(resv_height2_tb2); % Table 2, Row 2
writematrix(["\psi'_1 = G_[0,T] R_"+alpha_beta(1)+","+alpha_beta(2)+"(\varphi'_1)", ...
    resv_values(1),resv_values(2), num2str(resv_height2_tb2_et)], 'tables\Table2.xls','Range','A2:D2');
[alpha_beta, resv_values] = resv2mat(resv_delivery1_tb2); % Table 2, Row 3
writematrix(["\psi'_2 = F_[0,43] G_[0,1] R_"+alpha_beta(1)+","+alpha_beta(2)+"(\varphi'_2)", ...
    resv_values(1), resv_values(2), num2str(resv_delivery1_tb2_et)], 'tables\Table2.xls','Range','A3:D3');
[alpha_beta, resv_values] = resv2mat(resv_delivery2_tb2); % Table 2, Row 4
writematrix(["\psi'_3 = F_[0,65] G_[0,3] R_"+alpha_beta(1)+","+alpha_beta(2)+"(\varphi'_3)", ...
    resv_values(1), resv_values(2), num2str(resv_delivery2_tb2_et)], 'tables\Table2.xls','Range','A4:D4');
[alpha_beta, resv_values] = resv2mat(resv_collision_avoid_tb2); % Table 2, Row 5
writematrix(["\psi'_4 = G_[0,T] R_"+alpha_beta(1)+","+alpha_beta(2)+"(\varphi'_4)", ...
    resv_values(1), resv_values(2), num2str(resv_collision_avoid_tb2_et)], 'tables\Table2.xls','Range','A5:D5');

%% Section 4: Run multi-agent flocking case study
fprintf('The following reprduces multi-agent flocking case study.\n');
trace_flocking;
close all
% write table 3 into a xls file. 
Cols = ["SRS Formula", "r(\psi_i,\xi,0)", "Execution time (sec)"];
writematrix(Cols,'tables\Table3.xls','Range','A1:C1');
[alpha_beta, resv_values] = resv2mat(resv_cost_tb3); % Table 3, Row 2
writematrix(["\psi_1 = R_"+alpha_beta(1)+","+alpha_beta(2)+"(\varphi_1)", ...
    resv_values(1), num2str(resv_cost_tb3_et)], 'tables\Table3.xls','Range','A2:C2');
[alpha_beta, resv_values] = resv2mat(resv_cc_tb3); % Table 3, Row 3
writematrix(["\psi_2 = R_"+alpha_beta(1)+","+alpha_beta(2)+"(\varphi_2)", ...
    resv_values(1), num2str(resv_cc_tb3_et)], 'tables\Table3.xls','Range','A3:C3');

% write table 4 into a xls file. 
Cols = ["SRS Formula", "r(\psi'_i,\xi,0)", "Corresponding SRS atoms", "Execution time (sec)"];
writematrix(Cols,'tables\Table4.xls','Range','A1:D1');
[alpha_beta, resv_values] = resv2mat(resv_cost_tb4); % Table 4, Row 2
writematrix(["\psi'_1 = G_[0,500] F_[0,60] R_"+alpha_beta(1)+","+alpha_beta(2)+"(\varphi'_1)", ...
    resv_values(1), resv_values(2), num2str(resv_cost_tb4_et)], 'tables\Table4.xls','Range','A2:D2');
[alpha_beta, resv_values] = resv2mat(resv_cc_tb4); % Table 4, Row 3
writematrix(["\psi'_2 = G_[0,500] F_[0,60] R_"+alpha_beta(1)+","+alpha_beta(2)+"(\varphi'_2)", ...
    resv_values(1), resv_values(2), num2str(resv_cc_tb4_et)], 'tables\Table4.xls','Range','A3:D3');
