function resv_value = STL_EvalReSV(trace_param, time, trace, formula, t)
%STL_EvalReSV v1.0
% - computes the ReSV of an STL-based Resilience specification for one or
% many traces.
% Inputs:
%  - trace_param: parameters of trace, size of N
%  - time: time stamps of the trace, size of 1*L
%  - trace : values of a trace to be evaluated, size N*L
%  - formula: an STL-based Resilience specification 
%  - t: time step when trace is evaluated
% 
% Outputs:
%  - resv_value: the resilience satisfaction value r(formula, trace, t)
% 
% Example:
% trace_params = {'temperature', 'humidity'};
% time = 0:.1:24;
% temperature = 10 + 15*cos(pi*(time-3)/12+pi)+sin(pi/2*time); 
% humidity = 50 + 10*cos(pi*(time+2)/12)+sin(pi/3*time);
% trace = [temperature; humidity]; 
% psi = STL_Resilience_Formula('psi', 'alw (temperature[t]<25) and ev_[0, 12] (humidity[t]>50)', true, [3,4]);
% resv_value = STL_EvalReSV(trace_param, time, trace, psi, 0);
%
% v1.0- Add optimization to the level 2 interior nodes.

assert(numel(t) == 1, "More than one time step is evaluated.");
assert(numel(time) == numel(unique(time)), "Duplicate time step in time.");
assert(issorted(time),"Timestamps are not in chronological order.");
assert(numel(time) == size(trace,2),"Timestamps size is not compatible to trace.");

SRSatompairs = cell(0); % to store all the rec-dur pairs for SRS atoms along 'trace'. Currently, no pair, no atom

[resv_value,~] = GetReSVValues(trace_param, time, trace, formula, t, SRSatompairs);

end


function [resv_value, output_SRSatompairs] = GetReSVValues(trace_param, time, trace, formula, t, current_SRSatompairs)

    isbaseType = get_isbase(formula);
    if isbaseType
        % locate the time step first.
        if ismembertol(t,time,1e-8)
            [~,time_step] = ismembertol(t,time,1e-8); % the index of the starting time
        else
            [~, closest_ts] = min(abs(time-t));
            time_step = closest_ts;
        end

        id = [];
        if ~isempty(current_SRSatompairs)
            for i = 1:size(current_SRSatompairs,2) 
                id = [id, string(get_id(current_SRSatompairs{1,i}))];% first row is 'STL Formula'
            end
            [lia, locb] = ismember(string(get_id(formula)),id);
            if lia == true
                [alpha,beta] = get_limits(formula);
                all_rec_dur_pair = current_SRSatompairs{2,locb};
                rec_dur_pair = all_rec_dur_pair(:, time_step);
                resv_value = ReSV(rec_dur_pair(1), rec_dur_pair(2), alpha, beta, formula, t);
                output_SRSatompairs = current_SRSatompairs;
                return
            end 
        end
        % if SRS atom archive is empty or 'formula' is not in the archive,
        % we compute the rec-dur pairs of 'formula' along 'trace'
        assert(t<=time(end), "Evaluation time is longer than the trace.");

        fprintf("Computing all the r-values of SRS atom ("+ disp(formula)+")......\n");tic;
        all_rec_dur_pair = compute_pair_over_traj(trace_param, time, trace, formula);
        elapsedtime = toc;
%         fprintf("Done! Used " + elapsedtime +" seconds.\n");
        
        num_atom = size(current_SRSatompairs,2);
        current_SRSatompairs{1,num_atom+1} = formula;
        current_SRSatompairs{2,num_atom+1} = all_rec_dur_pair;
        output_SRSatompairs = current_SRSatompairs;

        rec_dur_pair = all_rec_dur_pair(:, time_step);
        [alpha,beta] = get_limits(formula);
        resv_value = ReSV(rec_dur_pair(1), rec_dur_pair(2), alpha, beta, formula, t);
            
%         len_trace = size(trace,2);
%         [min_d_idx, t_idx] = first_STL_satisfaction(trace_param, time, trace, formula, t); 
        % t_idx is the index of t, min_d_index is the index of min_d
        % starting from t_idx, e.g., if min_d_idx = 1 means formula is true
        % at t
%         t_rec_idx = min(union(min_d_idx, len_trace-t_idx+1)); % t_rec_idx starts from t_idx
%         t_rec = time(t_rec_idx+t_idx-1) - t;
%         
%         formula_temp_id = get_id(formula);
%         not_formula = STL_Formula(['not ' formula_temp_id], ['not ' formula_temp_id], false);
%         
%         tprime = t+t_rec; 
%         [min_dprime_idx, tprime_idx] = first_STL_satisfaction(trace_param, time, trace, not_formula, tprime);
%         t_dur_idx = min(union(min_dprime_idx, len_trace-tprime_idx+1));
%         t_dur = time(t_dur_idx+tprime_idx-1) - tprime;
% 
%         [alpha,beta] = get_limits(formula);
%         resv_value = ReSV(t_rec,t_dur,alpha,beta,formula,t);

    else
        formType = get_type(formula);
        switch(formType)
            case 'not'
                children_tmp = get_children(formula);
                child_1 = children_tmp{1};
                output_SRSatompairs = current_SRSatompairs;
                [resv_value, output_SRSatompairs] = GetReSVValues(trace_param, time, trace, child_1, t, output_SRSatompairs);
                resv_value = resv_value.reverse();

            case 'or'
                children_tmp = get_children(formula);
                child_1 = children_tmp{1};
                child_2 = children_tmp{2};
                output_SRSatompairs = current_SRSatompairs;
                [resv_value_1, output_SRSatompairs] = GetReSVValues(trace_param, time, trace, child_1, t, output_SRSatompairs);
                [resv_value_2, output_SRSatompairs] = GetReSVValues(trace_param, time, trace, child_2, t, output_SRSatompairs);
                resv_value = maximum_res_set(resv_value_1, resv_value_2);

            case 'and'
                children_tmp = get_children(formula);
                child_1 = children_tmp{1};
                child_2 = children_tmp{2};
                output_SRSatompairs = current_SRSatompairs;
                [resv_value_1, output_SRSatompairs] = GetReSVValues(trace_param, time, trace, child_1, t, output_SRSatompairs);
                [resv_value_2, output_SRSatompairs] = GetReSVValues(trace_param, time, trace, child_2, t, output_SRSatompairs);
                resv_value = minimum_res_set(resv_value_1, resv_value_2);

            case 'always'
                I___ = eval(get_interval(formula));
                I___ = max([I___; 0 0]);
                I___(1) = min(I___(1), I___(2));
                children_tmp = get_children(formula);
                child_1 = children_tmp{1};
                
                epsilon = 0.0001;
                if I___(2)~=inf
                    if t+I___(2) > time(end)+epsilon
                        idx_end = numel(time);
                    else
                        idx_end = find(abs(time - t - I___(2))<epsilon, 1); % the last idx in time that is smaller than I___(2)
                    end
                else
                    idx_end = numel(time);
                end
                ReSV_value_all = ReSV(); % empty resv
                idx_start = find(abs(time - t- I___(1))<epsilon, 1); % the first idx in time that is larger than I___(1)
                
                output_SRSatompairs =  current_SRSatompairs;
                switch get_isbase(child_1)
                    case false 
                        for T = idx_start:idx_end
                            [ReSV_value_tmp,output_SRSatompairs] = GetReSVValues(trace_param, time, trace, child_1, time(T),output_SRSatompairs);
                            ReSV_value_all = resv_addition(ReSV_value_all, ReSV_value_tmp);
                        end
                    case true
                        T = idx_start;
                        epsilon = 10^-5;
                        while T <= idx_end
                            [ReSV_value_tmp,output_SRSatompairs] = GetReSVValues(trace_param, time, trace, child_1, time(T),output_SRSatompairs);
                            rec_tmp = ReSV_value_tmp(1).element{1}.alpha - ReSV_value_tmp(1).element{1}.values.Recoverablity(1);
                            dur_tmp = ReSV_value_tmp(1).element{1}.values.Durability(1) + ReSV_value_tmp(1).element{1}.beta;
                            ReSV_value_all = resv_addition(ReSV_value_all, ReSV_value_tmp);
                            if rec_tmp > epsilon  % T in recovery, T is the worst, jump to the beginning of duration.
                                next_time  = time(T)  + rec_tmp;
                                next_T = find(abs(time - next_time)<epsilon, 1);                                
                            elseif abs(rec_tmp) <= epsilon % T in duration, T is the best, jump to the end of duration or idx_end
                                next_time = time(T) + dur_tmp;
                                next_T = find(abs(time - next_time)<epsilon, 1)-1;
                                next_T = min(idx_end, next_T);
                            else 
                                error(disp(child_1) + " takes negative time to recover at time "+ T);
                            end
                            T = max(next_T, T+1);
                        end
                end
                % 
                resv_value = minimum_res_set(ReSV_value_all);

            case 'eventually'
                I___ = eval(get_interval(formula));
                I___ = max([I___; 0 0]);
                I___(1) = min(I___(1), I___(2));
                children_tmp = get_children(formula);
                child_1 = children_tmp{1};

                epsilon = 0.0001;
                if I___(2)~=inf
                    epsilon = 0.001;
                    if t+I___(2) > time(end)+epsilon
                        idx_end = numel(time);
                    else
                        idx_end = find(abs(time - t - I___(2))<epsilon, 1); % the last idx in time that is smaller than I___(2)
                    end
                else
                    idx_end = numel(time);
                end
                ReSV_value_all = ReSV(); % empty resv
                idx_start = find(abs(time - t - I___(1))<epsilon, 1); % the first idx in time that is larger than I___(1)
                
                output_SRSatompairs =  current_SRSatompairs;
                switch get_isbase(child_1)
                    case false 
                        for T = idx_start:idx_end
                            [ReSV_value_tmp,output_SRSatompairs] = GetReSVValues(trace_param, time, trace, child_1, time(T),output_SRSatompairs);
                            ReSV_value_all = resv_addition(ReSV_value_all, ReSV_value_tmp);
                        end
                    case true
                        T = idx_start;
                        epsilon = 10^-5;
                        while T <= idx_end
                            [ReSV_value_tmp,output_SRSatompairs] = GetReSVValues(trace_param, time, trace, child_1, time(T),output_SRSatompairs);
                            rec_tmp = ReSV_value_tmp(1).element{1}.alpha - ReSV_value_tmp(1).element{1}.values.Recoverablity(1);
                            dur_tmp = ReSV_value_tmp(1).element{1}.values.Durability(1) + ReSV_value_tmp(1).element{1}.beta;
                            ReSV_value_all = resv_addition(ReSV_value_all, ReSV_value_tmp);
                            if rec_tmp > epsilon  % T in recovery, T is the worst, jump to the beginning of duration or idx_end.
                                next_time  = time(T)  + rec_tmp;
                                next_T = find(abs(time - next_time)<epsilon, 1);
                                next_T = min(idx_end, next_T);
                            elseif abs(rec_tmp) <= epsilon % T in duration, T is the best, jump to the beginning of next recovery duration
                                next_time = time(T) + dur_tmp;
                                next_T = find(abs(time - next_time)<epsilon, 1);
                            else 
                                error(disp(child_1) + " takes negative time to recover at time "+ T);
                            end
                            T = max(next_T, T+1);
                        end
                end

                resv_value = maximum_res_set(ReSV_value_all);

            case 'until'
                I___ = eval(get_interval(formula));
                I___ = max([I___; 0 0]);
                I___(1) = min(I___(1), I___(2));
                children_tmp = get_children(formula);
                child_1 = children_tmp{1};
                child_2 = children_tmp{2};

                epsilon = 0.0001;
                if I___(2)~=inf
                    epsilon = 0.001;
                    if t+I___(2) > time(end)+epsilon
                        idx_end = numel(time);
                    else
%                     assert(t+I___(2)<=time(end)+epsilon,"Time interval excceeds the length of the signal.");
                        idx_end = find(abs(time - t - I___(2))<epsilon, 1); % the last idx in time that is smaller than I___(2)
                    end
                else
                    idx_end = numel(time);
                end
                % startegy: use two pointers, one for psi_1, one for psi_2
                % Note: using two pointers has the same computation load to the
                % pre-computing on intervals [t,t+b] and [t+b];
                idx_start = find(abs(time - t - I___(1))<epsilon, 1); % the first idx in time that is larger than I___(1)
%                 idx_end = find((time - I___(2))>=0, 1)-1; % the last idx in time that is smaller than I___(2)
                
                % start from time t
                if ismembertol(t,time,1e-8)
                    [~,t_idx] = ismembertol(t,time,1e-8);
                else
                    [~, closest_ts] = min(abs(time-t));
                    t_idx = closest_ts;
                end
                output_SRSatompairs_tmp = current_SRSatompairs;
                [resv_value_psi1,output_SRSatompairs_tmp] = precompute_ReSV(trace_param, time, trace, child_1,...
                    t_idx, t_idx+idx_end, output_SRSatompairs_tmp);
                [resv_value_psi2, output_SRSatompairs_tmp] = precompute_ReSV(trace_param, time, trace, child_2,...
                    t_idx+idx_start, t_idx+idx_end, output_SRSatompairs_tmp);
                
                % compute by definition
%                 tic
                union_minres_r_psi1_psi2_t_prime = ReSV();
                for t_prime = idx_start:idx_end
                    r_psi2_t_prime = resv_value_psi2(t_prime-idx_start+1);
                    union_r_psi1_t_dprime = ReSV();
                    for t_dprime = 1:t_prime
                        union_r_psi1_t_dprime = resv_addition(union_r_psi1_t_dprime, resv_value_psi1(t_dprime));
                    end
                    minres_union_psi1_t_dprime = minimum_res_set(union_r_psi1_t_dprime);
                    minres_r_psi1_psi2 = minimum_res_set(r_psi2_t_prime, minres_union_psi1_t_dprime);
                    union_minres_r_psi1_psi2_t_prime = resv_addition(union_minres_r_psi1_psi2_t_prime, minres_r_psi1_psi2);
                end
                resv_value = maximum_res_set(union_minres_r_psi1_psi2_t_prime);
%                 toc
                output_SRSatompairs = output_SRSatompairs_tmp;
        end

    end

end

% compute ReSV of formula at each time stamp in interval time with index
% [idx1,idx2]
function [resv_value, output_SRSatompairs] = precompute_ReSV(trace_param, time, trace, formula, idx1, idx2, current_SRSatompairs)
    resv_value = [];
    % pre-compute resv of formula over time[idx1,idx2]
    for i = idx1:idx2
        [resv_tmp, output_SRSatompairs] = GetReSVValues(trace_param, time, trace, formula, time(i), current_SRSatompairs);
        resv_value = cat(2, resv_value, resv_tmp);
    end

end