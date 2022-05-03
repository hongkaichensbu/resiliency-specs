function all_rec_dur_pair = compute_pair_over_traj(trace_param, time, trace, formula)
% formula should be an SRS atom.
% 

Bdata_tmp = BreachTraceSystem(trace_param); % add the trace variable names
Rphi_tmp = BreachRequirement(formula); % add the STL formula
trajLength = length(time);

% find the boolean of the trace
Bdata_tmp.AddTrace([time', trace']); % add the shifted trace

for kk = 1:trajLength-1
    shifted_time_tmp = time(1:end-kk);
    shifted_trace_tmp = trace(:,1+kk:end);
    Bdata_tmp.AddTrace([shifted_time_tmp' shifted_trace_tmp']);
end

initBoolean = Rphi_tmp.evalAllTraces(Bdata_tmp);
allBoolean = initBoolean>0;

Rphi_tmp.ResetEval(); % BreachRequirement need to reset in order to eval again
Bdata_tmp.ResetSampling(); % remove all traces

recoverability = zeros(1,trajLength);
durability = zeros(1,trajLength);

for i = 1:trajLength
    first_true = find(allBoolean(i:end)==true,1);
    if isempty(first_true)
        recoverability(i) = time(trajLength) - time(i);
        t_rec = trajLength - i;
    else
        recoverability(i) = time(first_true+i-1)-time(i);
        t_rec = first_true - 1;
    end
    first_false = find(allBoolean(i+t_rec:end)==false, 1);
    if isempty(first_false)
        durability(i) = time(trajLength) - time(i+t_rec);
    else
        durability(i) = time(first_false+i+t_rec-1)-time(i+t_rec);
    end

% [alpha,beta] = get_limits(formula);
% all_rec_dur_pair = [ -recoverability+alpha; durability-beta];

all_rec_dur_pair = [recoverability; durability];



% find the indices of begin/end of TRUE period
% begin_end_idx_true = [];
% if allBoolean(1) == true
%     begin_end_idx_true = cat(2, begin_end_idx_true, 1);
% end
% for j = 2:trajLength-1
%     if (allBoolean(j-1)==false && allBoolean(j)==true) || (allBoolean(j)==true && allBoolean(j+1)==false)
%         begin_end_idx_true = cat(2, begin_end_idx_true, j);
%     end
% end
% if allBoolean(trajLength) == true
%     begin_end_idx_true = cat(2, begin_end_idx_true, trajLength);
% end
% assert(mod(begin_end_idx_true,2)==0, "Odd number of switching indices.");
% 
% switch numel(begin_end_idx_true)
%     case 2
%         if begin_end_idx_true(1) > 1 && begin_end_idx_true(2) < trajLength
%             recoverability(1 : begin_end_idx_true(1)-1) = time(begin_end_idx_true(1))-...
%                 time(1 : begin_end_idx_true(1)-1);
%             recoverability(begin_end_idx_true(1) : begin_end_idx_true(2)) = 0;
%             durability(1 : begin_end_idx_true(1)-1) = (time(begin_end_idx_true(2)+1)-...
%                 time(begin_end_idx_true(1))) * ones(1,begin_end_idx_true(1)-1);
%             durability(begin_end_idx_true(1) : begin_end_idx_true(2)) = time(begin_end_idx_true(2)+1)-...
%                 time(begin_end_idx_true(1) : begin_end_idx_true(2));
%         else
%             recoverability(begin_end_idx_true(1) : begin_end_idx_true(2)) = 0;
%             durability(begin_end_idx_true(1) : begin_end_idx_true(2)) = time(begin_end_idx_true(2)+1)-...
%                 time(begin_end_idx_true(1) : begin_end_idx_true(2));
%         end
%         if begin_end_idx_true(end) == trajLength
%             k = numel(begin_end_idx_true)-1;
%             recoverability(begin_end_idx_true(k-1)+1 : begin_end_idx_true(k)-1) = time(begin_end_idx_true(k))-...
%                 time(begin_end_idx_true(k-1)+1 : begin_end_idx_true(k)-1);
%             recoverability(begin_end_idx_true(k) : begin_end_idx_true(k+1)) = 0;
%             durability(begin_end_idx_true(k-1)+1 : begin_end_idx_true(k)-1) = (time(begin_end_idx_true(k+1)+1)-...
%                 time(begin_end_idx_true(k))) * ones(1,begin_end_idx_true(k)-begin_end_idx_true(k-1)-1);
%             durability(begin_end_idx_true(k) : begin_end_idx_true(k+1)) = time(begin_end_idx_true(k+1)+1)-...
%                 time(begin_end_idx_true(k) : begin_end_idx_true(k+1));
%         else
%             recoverability(begin_end_idx_true(k-1)+1 : begin_end_idx_true(k)-1) = time(begin_end_idx_true(k))-...
%                 time(begin_end_idx_true(k-1)+1 : begin_end_idx_true(k)-1);
%             recoverability(begin_end_idx_true(k) : begin_end_idx_true(k+1)) = 0;
%             durability(begin_end_idx_true(k-1)+1 : begin_end_idx_true(k)-1) = (time(begin_end_idx_true(k+1)+1)-...
%                 time(begin_end_idx_true(k))) * ones(1,begin_end_idx_true(k)-begin_end_idx_true(k-1)-1);
%             durability(begin_end_idx_true(k) : begin_end_idx_true(k+1)) = time(begin_end_idx_true(k+1)+1)-...
%                 time(begin_end_idx_true(k) : begin_end_idx_true(k+1));
%         end
% for k = 1+2:2:numel(begin_end_idx_true)-2
%     recoverability(begin_end_idx_true(k-1)+1 : begin_end_idx_true(k)-1) = time(begin_end_idx_true(k))-...
%         time(begin_end_idx_true(k-1)+1 : begin_end_idx_true(k)-1);
%     recoverability(begin_end_idx_true(k) : begin_end_idx_true(k+1)) = 0;
%     durability(begin_end_idx_true(k-1)+1 : begin_end_idx_true(k)-1) = (time(begin_end_idx_true(k+1)+1)-...
%         time(begin_end_idx_true(k))) * ones(1,begin_end_idx_true(k)-begin_end_idx_true(k-1)-1);
%     durability(begin_end_idx_true(k) : begin_end_idx_true(k+1)) = time(begin_end_idx_true(k+1)+1)-...
%         time(begin_end_idx_true(k) : begin_end_idx_true(k+1));
% end
% if begin_end_idx_true(end) == trajLength
%     k = numel(begin_end_idx_true)-1;
%     recoverability(begin_end_idx_true(k-1)+1 : begin_end_idx_true(k)-1) = time(begin_end_idx_true(k))-...
%         time(begin_end_idx_true(k-1)+1 : begin_end_idx_true(k)-1);
%     recoverability(begin_end_idx_true(k) : begin_end_idx_true(k+1)) = 0;
%     durability(begin_end_idx_true(k-1)+1 : begin_end_idx_true(k)-1) = (time(begin_end_idx_true(k+1)+1)-...
%         time(begin_end_idx_true(k))) * ones(1,begin_end_idx_true(k)-begin_end_idx_true(k-1)-1);
%     durability(begin_end_idx_true(k) : begin_end_idx_true(k+1)) = time(begin_end_idx_true(k+1)+1)-...
%         time(begin_end_idx_true(k) : begin_end_idx_true(k+1));
% else
%     recoverability(begin_end_idx_true(k-1)+1 : begin_end_idx_true(k)-1) = time(begin_end_idx_true(k))-...
%         time(begin_end_idx_true(k-1)+1 : begin_end_idx_true(k)-1);
%     recoverability(begin_end_idx_true(k) : begin_end_idx_true(k+1)) = 0;
%     durability(begin_end_idx_true(k-1)+1 : begin_end_idx_true(k)-1) = (time(begin_end_idx_true(k+1)+1)-...
%         time(begin_end_idx_true(k))) * ones(1,begin_end_idx_true(k)-begin_end_idx_true(k-1)-1);
%     durability(begin_end_idx_true(k) : begin_end_idx_true(k+1)) = time(begin_end_idx_true(k+1)+1)-...
%         time(begin_end_idx_true(k) : begin_end_idx_true(k+1));
% end
% 
% all_rec_dur_pair = begin_end_idx_true;
end