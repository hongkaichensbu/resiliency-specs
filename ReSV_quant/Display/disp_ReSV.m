function st = disp_ReSV(resv)
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

end

