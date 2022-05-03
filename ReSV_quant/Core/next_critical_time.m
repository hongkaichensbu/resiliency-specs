function t = next_critical_time(resv, current_time, timestep)
%LEAST_REC_TIME
% In an ReSV, the next time to recover if starts violation, or smallest time that duration
% end if starts with satisfaction, wrt to current time

% the critical time depends on x_r and x_d of other elements in the ReSV too.

assert(isa(resv, "ReSV"));
tolerance = 10^-6;
num_ele = numel(resv.element);

t_all = [];
for i = 1:num_ele
    if resv.element{i}.values{1,1} == resv.element{i}.alpha % start with satisfaction
        t_all = cat(2, t_all, resv.element{i}.beta + resv.element{i}.values{1,2} + resv.element{i}.t - timestep);
        if resv.element{i}.values{1,2} > tolerance
            t_all = cat(2, t_all, resv.element{i}.values{1,2} + resv.element{i}.t - timestep);
        elseif abs(resv.element{i}.values{1,2}) < tolerance
            t_all = cat(2, t_all, resv.element{i}.t + timestep);
%         elseif resv.element{i}.values{1,2} < -tolerance
        end
    else
        t_all = cat(2, t_all, resv.element{i}.alpha - resv.element{i}.values{1,1} + resv.element{i}.t - timestep);
    end
end

t_all = t_all((t_all - current_time)>=-tolerance); % all the critical time that greater than current time

t = min(t_all);

end

