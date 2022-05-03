function [min_d_idx, t_idx] = first_STL_satisfaction(trace_param, time, trace, formula, t)
%FIRST_STL_SATISFACTION 
% input:
% trajectory xi and STL formula phi, time t, find the smallest d (min_d), such that
% (xi, t+d) |= phi
% output:
% min_d_idx: the index of min_d starting from t_idx: 
% min_d = t_idx + min_d_idx - 1
% t_idx: index of time t

Bdata_tmp = BreachTraceSystem(trace_param); % add the trace variable names
Rphi_tmp = BreachRequirement(formula); % add the STL formula
if ismembertol(t,time,1e-8)
    [~,new_start] = ismembertol(t,time,1e-8); % the index of the starting time
else
    fprintf("Time t is not found in time steps...\n")
    fprintf("Assess STL formula from the closest time step.\n")
    [~, closest_ts] = min(abs(time-t));
    fprintf("STL formula is requested to be evaluated at time "+ num2str(t)+ ", yet is actually at time "+ num2str(time(closest_ts)));
    new_start = closest_ts;
end
t_idx = new_start;

shifted_trace = trace(:, new_start:end);
shifted_time = time(1:end-new_start+1); % time and trace that starts from t (where phi is evaluated)

% batch-based evaluate the boolean
sizeBatch = 50;
trajLength = numel(shifted_time); % should be the length start from t
boolean_numBatch = ceil(trajLength/sizeBatch);
allBoolean = [];
min_d_idx = [];
for batch_id = 1:boolean_numBatch
    for kk = sizeBatch*(batch_id-1)+1:sizeBatch*batch_id  % time shifts in current batch
        if kk <= trajLength
            shifted_time_tmp = shifted_time(1:end-kk+1);
            shifted_trace_tmp = shifted_trace(:,kk:end);
            Bdata_tmp.AddTrace([shifted_time_tmp' shifted_trace_tmp']);
        else
            break
        end
    end
    if Bdata_tmp.CountTraces == 0
        break
    end
    boolean_tmp_mat = Rphi_tmp.evalAllTraces(Bdata_tmp);  % evaluate all traces' robust satisfaction values (rsv)
    Rphi_tmp.ResetEval(); % BreachRequirement need to reset in order to eval again
    Bdata_tmp.ResetSampling(); % remove all traces

    allBoolean = cat(2,allBoolean, boolean_tmp_mat'); % update the shifted traces' boolean
    
    if any(allBoolean>0)
        min_d_idx = find(allBoolean>0, 1);
    end

end

end

