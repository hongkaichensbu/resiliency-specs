function [limits, values] = resv2mat(resv)
%RESV2MAT Summary of this function goes here
%   Detailed explanation goes here

num_ele = numel(resv.element);

rec_tmp = [];
dur_tmp = [];
sel_i = [];
for i = 1:num_ele
    if ismembertol(resv.element{i}.values.Recoverablity(1),rec_tmp,10^-6) == false && ...
            ismembertol(resv.element{i}.values.Durability(1),dur_tmp,10^-6) ==false
        sel_i =cat(2, sel_i, i);
        rec_tmp = cat(1, rec_tmp, resv.element{i}.values.Recoverablity(1));
        dur_tmp = cat(1, dur_tmp, resv.element{i}.values.Durability(1));
    else
        [~,aid]= ismembertol(rec_tmp, resv.element{i}.values.Recoverablity(1),10^-6);
        [~,bid]= ismembertol(dur_tmp,resv.element{i}.values.Durability(1),10^-6);
        dup_id = intersect(aid,bid);
        if resv.element{sel_i(dup_id)}.t >= resv.element{i}.t
            sel_i(dup_id) = i;
        end
    end
end

limits = [resv.element{1}.alpha, resv.element{1}.beta];
values = ["{","{"];
for i = sel_i(1:end-1)
   values(1) = values(1)+"("+num2str(resv.element{i}.values.Recoverablity(1))+","+...
       num2str(resv.element{i}.values.Durability(1))+"), ";
   values(2) = values(2)+num2str(resv.element{i}.t)+", ";
end
for i = sel_i(end)
   values(1) = values(1)+"("+num2str(resv.element{i}.values.Recoverablity(1))+","+...
       num2str(resv.element{i}.values.Durability(1))+")}";
   values(2) = values(2)+num2str(resv.element{i}.t)+"}";
end

end

