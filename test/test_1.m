InitReSV

trace_params = {'temperature', 'humidity'};
time = 0:.1:24; % in hours
temperature = 10 + 15*cos(pi*(time-3)/12+pi)+sin(pi/2*time); % in Celsius deg
humidity = 50 + 10*cos(pi*(time+2)/12)+sin(pi/3*time); % in percents
trace = [temperature; humidity]; % combine into a trace, column oriented
isBase = true;
%% Test ReSV base cases
[psi1, ~] = STL_Formula('psi1','alw_[0,2] temperature[t] <10', isBase, [5,6]);
t = 0; resv_value = STL_EvalReSV(trace_params, time, trace, psi1, t);
fprintf("Expected ReSV: {(5,0.8)}\n"); fprintf("Computed ReSV: \n"); disp_ReSV(resv_value);
t = 2; resv_value2 = STL_EvalReSV(trace_params, time, trace, psi1, t);
fprintf("Expected ReSV: {(5,-1.2)}\n"); fprintf("Computed ReSV: \n"); disp_ReSV(resv_value2);
t = 5; resv_value3 = STL_EvalReSV(trace_params, time, trace, psi1, t);
fprintf("Expected ReSV: {(5,-4.2)}\n"); fprintf("Computed ReSV: \n"); disp_ReSV(resv_value3);

%% Test ReSV NOT cases
[psi1, ~] = STL_Formula('psi1','temperature[t] <10', isBase, [5,6]);
[psi2, ~] = STL_Formula('not psi1','not psi1', ~isBase);
t = 0; resv_value = STL_EvalReSV(trace_params, time, trace, psi1, t);
fprintf("Expected ReSV: {(5,2.8)}\n"); fprintf("Computed ReSV: \n"); disp_ReSV(resv_value);
t = 0; resv_value2 = STL_EvalReSV(trace_params, time, trace, psi2, t);
fprintf("Expected ReSV: {(-5,-2.8)}\n"); fprintf("Computed ReSV: \n"); disp_ReSV(resv_value2);
%% Test ReSV OR case   
[psi1, ~] = STL_Formula('psi1','temperature[t] <10', isBase, [5,6]);
[psi2, ~] = STL_Formula('psi2','temperature[t] <30', isBase, [3,5]);
[psi3, ~] = STL_Formula('psi3','humidity[t] <10', isBase, [5,6]);
[psi4, ~] = STL_Formula('psi4','humidity[t] <80', isBase, [5,6]);
[psi5, ~] = STL_Formula('psi5','psi1 or psi2', ~isBase);
[psi6, ~] = STL_Formula('psi6','psi5 or psi3', ~isBase);
[psi7, ~] = STL_Formula('psi7','psi6 or psi4', ~isBase);
t = 0;
resv_value = STL_EvalReSV(trace_params, time, trace, psi1, t);
resv_value2 = STL_EvalReSV(trace_params, time, trace, psi2, t);
resv_value3 = STL_EvalReSV(trace_params, time, trace, psi3, t);
resv_value4 = STL_EvalReSV(trace_params, time, trace, psi4, t);
resv_value5 = STL_EvalReSV(trace_params, time, trace, psi5, t);
resv_value6 = STL_EvalReSV(trace_params, time, trace, psi6, t);
resv_value7 = STL_EvalReSV(trace_params, time, trace, psi7, t);
fprintf("Expected ReSV: {(5,2.8)}\n"); fprintf("Computed ReSV: \n");disp_ReSV(resv_value);
fprintf("Expected ReSV: {(3,19)}\n"); fprintf("Computed ReSV: \n");disp_ReSV(resv_value2);
fprintf("Expected ReSV: {(-19,-6)}\n"); fprintf("Computed ReSV: \n");disp_ReSV(resv_value3);
fprintf("Expected ReSV: {(5,18)}\n"); fprintf("Computed ReSV: \n");disp_ReSV(resv_value4);
fprintf("Expected ReSV: {(5,2.8),(3,19)}\n"); fprintf("Computed ReSV: \n");disp_ReSV(resv_value5);
fprintf("Expected ReSV: {(5,2.8),(3,19)}\n"); fprintf("Computed ReSV: \n");disp_ReSV(resv_value6);
fprintf("Expected ReSV: {(5,18),(3,19)}\n"); fprintf("Computed ReSV: \n");disp_ReSV(resv_value7);
%% Test ReSV AND case 
[psi1, ~] = STL_Formula('psi1','temperature[t] <10', isBase, [5,6]);
[psi2, ~] = STL_Formula('psi2','temperature[t] <30', isBase, [3,5]);
[psi3, ~] = STL_Formula('psi3','humidity[t] <10', isBase, [5,6]);
[psi4, ~] = STL_Formula('psi4','humidity[t] <80', isBase, [5,6]);
[psi5, ~] = STL_Formula('psi5','psi1 and psi2', ~isBase);
[psi6, ~] = STL_Formula('psi6','psi5 and psi3', ~isBase);
[psi7, psi7struct] = STL_Formula('psi7','psi6 and psi4', ~isBase);
t = 0;
resv_value = STL_EvalReSV(trace_params, time, trace, psi1, t);
resv_value2 = STL_EvalReSV(trace_params, time, trace, psi2, t);
resv_value3 = STL_EvalReSV(trace_params, time, trace, psi3, t);
resv_value4 = STL_EvalReSV(trace_params, time, trace, psi4, t);
resv_value5 = STL_EvalReSV(trace_params, time, trace, psi5, t);
resv_value6 = STL_EvalReSV(trace_params, time, trace, psi6, t);
resv_value7 = STL_EvalReSV(trace_params, time, trace, psi7, t);
fprintf("Expected ReSV: {(5,2.8)}\n"); fprintf("Computed ReSV: \n");disp_ReSV(resv_value);
fprintf("Expected ReSV: {(3,19)}\n"); fprintf("Computed ReSV: \n");disp_ReSV(resv_value2);
fprintf("Expected ReSV: {(-19,-6)}\n"); fprintf("Computed ReSV: \n");disp_ReSV(resv_value3);
fprintf("Expected ReSV: {(5,18)}\n"); fprintf("Computed ReSV: \n");disp_ReSV(resv_value4);
fprintf("Expected ReSV: {(5,2.8),(3,19)}\n"); fprintf("Computed ReSV: \n");disp_ReSV(resv_value5);
fprintf("Expected ReSV: {(-19,-6)}\n"); fprintf("Computed ReSV: \n");disp_ReSV(resv_value6);
fprintf("Expected ReSV: {(-19,-6)}\n"); fprintf("Computed ReSV: \n");disp_ReSV(resv_value7);
%% Test ReSV ALWAYS case 
[psi1, ~] = STL_Formula('psi1','temperature[t] <10', isBase, [5,6]);
t = 0;
resv_value = STL_EvalReSV(trace_params, time, trace, psi1, t);
fprintf("Expected ReSV: {(5,2.8)}\n"); fprintf("Computed ReSV: \n");disp_ReSV(resv_value);
[psi2, ~] = STL_Formula('psi2','always_[5,10] psi1', ~isBase);
resv_value2 = STL_EvalReSV(trace_params, time, trace, psi2, t);
fprintf("Expected ReSV: {(-7.5,-3.3)}\n"); fprintf("Computed ReSV: \n");disp_ReSV(resv_value2);

%% Test ReSV EVENTUALLY case 
[psi1, psi1struct] = STL_Formula('psi1','temperature[t] <10', isBase, [5,6]);
t = 0;
resv_value = STL_EvalReSV(trace_params, time, trace, psi1, t);
fprintf("Expected ReSV: {(5,2.8)}\n"); fprintf("Computed ReSV: \n");disp_ReSV(resv_value);
[psi2, psi2struct] = STL_Formula('psi2','eventually_[5,10] psi1', ~isBase);
resv_value2 = STL_EvalReSV(trace_params, time, trace, psi2, t);
fprintf("Expected ReSV: {(5,-2.2)}\n"); fprintf("Computed ReSV: \n");disp_ReSV(resv_value2);

%% Test ReSV UNTIL case 
[psi1, ~] = STL_Formula('psi1','temperature[t] <10', isBase, [5,6]);
[psi2, ~] = STL_Formula('psi2','humidity[t] <45', isBase, [5,6]);
[psi3, ~] = STL_Formula('psi3', 'psi1 until_[5,10] psi2', ~isBase);
t = 0;
resv_value = STL_EvalReSV(trace_params, time, trace, psi1, t);
resv_value2 = STL_EvalReSV(trace_params, time, trace, psi2, t);
resv_value3 = STL_EvalReSV(trace_params, time, trace, psi3, t);
fprintf("Expected ReSV: {(5,2.8)}\n"); fprintf("Computed ReSV: \n");disp_ReSV(resv_value);
fprintf("Expected ReSV: {(-1.1,1.5)}\n"); fprintf("Computed ReSV: \n");disp_ReSV(resv_value2);
fprintf("Expected ReSV: {(5,-2.2)}\n"); fprintf("Computed ReSV: \n");disp_ReSV(resv_value3);