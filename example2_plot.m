%% This file is the implementation of Example 2 in paper "An STL-based Formulation of Resilience in Cyber-Physical Systems"
InitReSV
xp = [ -2, -1, 1, 2, 3, 1, -1, -2, 1, 2, 3, 2, 1, -1, -2, -1, 1, 2, 3, 2, 1, -1, -2, -3, -2, -1];
x = 2*((xp>=0)-0.5);
t = 0:length(x)-1;

alpha = 1;
beta = 2;
rec = -[2, 1, 0 ,0 , 0, 0, 2, 1, 0, 0, 0, 0, 0, 3, 2, 1, 0, 0, 0, 0, 0, 4, 3, 2, 1, 0] + alpha;
dur =  [ 4, 4, 4, 3, 2, 1, 5, 5, 5, 4, 3, 2, 1, 5, 5, 5, 5, 4, 3, 2, 1, 0, 0, 0, 0, 0] -beta;

%% Plot figure 2(a)
figure;
subplot(2,1,1)
yyaxis left
plot(xp, 'k', 'LineWidth',2, 'DisplayName','$x$'); hold on
scatter(t+1,xp,'k','filled','HandleVisibility','off')
xticks(1:2:length(xp))
xticklabels(0:2:length(xp))
xlim([1,length(x)])
ylim([-4,4])
ylabel('$x$','Interpreter','latex','Interpreter','latex', 'FontSize', 14,'rotation',0,'HorizontalAlignment','right');
yyaxis right
stairs(x, 'color',[245,198,0]/255, 'LineWidth',2, 'DisplayName','$\chi(\varphi,x,t)$'); hold on
scatter(t+1,x, [],[245,198,0]/255,'filled','HandleVisibility','off')
xticks(1:2:length(xp))
xticklabels(0:2:length(xp))
xlim([1,length(x)])
yticks([-1,1])
ylim([-1.5, 1.5])
ylabel('$\chi(\varphi,x,t)$','Interpreter','latex', 'FontSize',14);%,'rotation',0,'HorizontalAlignment','right');
ax = gca;
ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = [210,159,0]/255;

subplot(2,1,2)
yyaxis left
stairs(rec, 'red', 'LineWidth',2, 'DisplayName','$x$'); hold on
scatter(t+1,rec,'red','filled','HandleVisibility','off')
xticks(1:2:length(xp))
xticklabels(0:2:length(xp))
xlim([1,length(x)])
ylim([-3.5,1.5])
xlabel('t [s]', 'FontSize',14)
ylabel('$-t_{rec}(x>0,x,t'')+\alpha$','Interpreter','latex', 'FontSize', 12);
yyaxis right
stairs(dur, 'blue', 'LineWidth',2, 'DisplayName','$\chi(\varphi,x,t)$'); hold on
scatter(t+1,dur,'blue','filled','HandleVisibility','off')
[~,idx] = find(x>=0);
for i = 1:numel(idx)
    line([idx(i), idx(i)], [-2.5, 3.5],'color',[124,187,158,128]/255, 'LineWidth',8);
end
xticks(1:2:length(xp))
xticklabels(0:2:length(xp))
xlim([1,length(x)])
ylim([-2.5, 3.5])
xlabel('t [s]', 'FontSize',14)
ylabel('$t_{dur}(x>0,x,t'')-\beta$','Interpreter','latex', 'FontSize', 12);
ax = gca;
ax.YAxis(1).Color = 'red';
ax.YAxis(2).Color = 'blue';
%% Plot Figure 2(b)
figure;
scatter(rec(1:21),dur(1:21),200, [153,153,153]/255 ,'filled','HandleVisibility','off'); hold on
scatter([-2,-1,1],[3,2,-1],200, 'red' ,'filled','HandleVisibility','off')
plot([-2,-1,1],[3,2,-1],'Color',[248,25,25,128]/255,'LineWidth',2)
xticks([-3:2])
yticks([-2:1:4])
grid on
xlim([-3.5,2.5])
ylim([-2.5, 4.5])
xlabel("Recoverability", 'FontSize', 16);
ylabel("Durability", 'FontSize', 16);
%% Computes the r-value of psi_1 
trace_params = {'x'};
trace_exp2 = xp;

isBase = true;

[psi, ~] = STL_Formula('psi1','x[t] > 0', isBase, [1,2]); 
[psi_f, ~] = STL_Formula('psi1_full','alw_[0,20] psi1', ~isBase); 
resv_exp2 = STL_EvalReSV(trace_params,t,trace_exp2, psi_f,0);
disp_ReSV(resv_exp2);