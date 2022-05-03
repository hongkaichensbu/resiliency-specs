function fig = plot_ReSV(resv)
%PLOT_RESV Summary of this function goes here
%   Detailed explanation goes here
st = disp_ReSV(resv);

figure;
for i = 1: numel(st.Recoverability)
    scatter(st.Recoverability(i), st.Durability(i),"MarkerFaceColor","flat");
    hold on
end
xmin = min(st.Recoverability);
xmax = max(st.Recoverability);
ymin = min(st.Durability);
ymax = max(st.Durability);
margin = 5;

xlim([xmin-margin,xmax+margin]);
ylim([ymin-margin,ymax+margin]);

for_leg = [];
for i = 1: numel(st.Formula)
    for_leg = cat(2, for_leg, st.Formula(i)+', time=' +num2str(st.Timestamp(i)));
end
legend(for_leg, 'Interpreter', 'none');
xlabel("Recoverability")
ylabel("Durability")
% set(fig,'DefaultTextInterpreter','none')
legend()

end

