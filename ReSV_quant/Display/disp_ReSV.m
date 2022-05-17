function st = disp_ReSV(resv, disp_full)
%DISP_RESV display values, formula, and timestamp

num_ele = numel(resv.element);
if num_ele == 0
    fprintf("No element in ReSV.\n")
    st = [];
    return
end

st = cell2table(cell(0,6));
st.Properties.VariableNames = ["Recoverability", "Durability", "Formula", "Timestamp", "Alpha", "Beta"];
st.Formula = string([]); 

for i = 1:num_ele
    rec_tmp = resv.element{i}.values.Recoverablity(1);
    dur_tmp = resv.element{i}.values.Durability(1);
    info_formula = disp(resv.element{i}.formula, 0);
    ts_tmp = resv.element{i}.t;
    a_tmp = resv.element{i}.alpha;
    b_tmp = resv.element{i}.beta;
    st(i,:) = {[rec_tmp], [dur_tmp], [info_formula], [ts_tmp], [a_tmp], [b_tmp]};
end

fprintf("------------------------------------------------------------\n");
fprintf("Recoverability   Durability          Formula          Timestamp       Alpha      Beta\n");
if nargin == 2 && varargin(2) == true
    for i = 1:num_ele
        %     fprintf(st(i,:))
        info_formula = disp(resv.element{i}.formula, 0);
        fprintf(['     ',num2str(resv.element{i}.values.Recoverablity(1)),'              ',...
            num2str(resv.element{i}.values.Durability(1)),'         ',...
            info_formula,'       ', num2str(resv.element{i}.t),'           ', ...
            num2str(resv.element{i}.alpha),'           ', ...
            num2str(resv.element{i}.beta)]);
        fprintf('\n');
    end
else
    rec_tmp = [];
    dur_tmp = [];
    sel_i = [];
    for i = 1:num_ele
        %     fprintf(st(i,:))
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
    for i = sel_i
        info_formula = disp(resv.element{i}.formula, 0);
        fprintf(['     ',num2str(resv.element{i}.values.Recoverablity(1)),'              ',...
            num2str(resv.element{i}.values.Durability(1)),'         ',...
            info_formula,'       ', num2str(resv.element{i}.t),'           ', ...
            num2str(resv.element{i}.alpha),'           ', ...
            num2str(resv.element{i}.beta)]);
        fprintf('\n');
    end

end

end

