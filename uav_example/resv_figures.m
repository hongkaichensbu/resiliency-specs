%% We plot the recoverability-durability-t 3D plots for all requirements
InitReSV
load mavtraj.mat
% 1. base cases.
% bool_1 = z_4>0;
% [bool_1_rec,bool_1_dur]= rec_dur(bool_1, time_4, 4, beta)

%% 4. package delivery
distance_to_location = sqrt((x_4-10).^2 + (y_4+5).^2 + (z_4-20).^2);
bool_1 = (x_4-10).^2 + (y_4+5).^2 + (z_4-20).^2<1;
[bool_1_rec,bool_1_dur]= rec_dur(bool_1, time_4, 4, 4);


figure= gcf;
subplot(2,1,1);
plot(time_4,distance_to_location, 'LineWidth', 1.5, 'DisplayName','UAV to location $C_2$');
yline(1,'LineWidth',1.5, 'DisplayName', '1 meter','Color','r');
xlim([0,time_4(end)])
xlabel('time [s]')
ylabel('distance [m]','rotation',0,'HorizontalAlignment','right');
legend('Interpreter','latex', 'FontSize', 9)
subplot(2,1,2);
plot(time_4,2*bool_1-1, 'LineWidth', 1.5, 'DisplayName','$\chi(\varphi''_4,\xi,t)$');
xlim([0,time_4(end)])
ylim([-1.5,1.5])
yticks([-1,1])
xlabel('time [s]')
ylabel('Boolean','rotation',0,'HorizontalAlignment','right');
legend('Interpreter','latex', 'FontSize',9)
set(gcf, 'renderer','painters');

print('MAV_bool2','-dpng','-r400')

%% phi_4 and resv of phi_4

t1=1231; t2=1233; t3=1301;
figure;
% yyaxis left
subplot(3,1,1)
plot(time_4,2*bool_1-1, 'LineWidth', 1.5, 'DisplayName','$\chi(\varphi''_4,\xi,t)$');
xlim([0,time_4(end)])
ylim([-1.5,1.5])
yticks([-1,1])
xlabel('time [s]')
ylabel('Boolean','rotation',0,'HorizontalAlignment','right');
legend('Interpreter','latex', 'FontSize',9)
subplot(3,1,2)
plot(time_4,bool_1_rec, 'LineWidth', 2, 'DisplayName','$r(R_{4,4}(\varphi''_4),\xi,t)$'); hold on
scatter( time_4(t1),bool_1_rec(t1),  'o', 'LineWidth', 2, 'DisplayName','$r(R_{4,4}(\varphi''_4),\xi,61.5)$');
scatter(time_4(t2),bool_1_rec(t2), 's', 'LineWidth', 2, 'DisplayName','$r(R_{4,4}(\varphi''_4),\xi,61.6)$');
scatter(  time_4(t3),bool_1_rec(t3),  'd', 'LineWidth', 2, 'DisplayName','$r(R_{4,4}(\varphi''_4),\xi,65)$');
xlabel('time [s]')
ylabel('Recoverability','rotation',0,'HorizontalAlignment','right');
xlim([0,time_4(end)])
legend('Interpreter','latex', 'FontSize', 9);
% create smaller axes in top right, and plot on it
    axes('Position',[.2 .5 .2 .12])
box on
plot(time_4(1229:1335),bool_1_rec(1229:1335), 'LineWidth', 2); hold on
xticks([time_4(1231),time_4(1232),time_4(1233)]);yticks([]);
xlim([time_4(1229),time_4(1235)])
ylim([bool_1_rec(1229)-0.1,bool_1_rec(1235)+0.1])
scatter( time_4(t1),bool_1_rec(t1),  'o', 'LineWidth', 2);
scatter(time_4(t2),bool_1_rec(t2), 's', 'LineWidth', 2);
scatter(  time_4(t3),bool_1_rec(t3),  'd', 'LineWidth', 2);
subplot(3,1,3)
% yyaxis right
plot(time_4,bool_1_dur, 'LineWidth', 2, 'DisplayName','$r(R_{4,4}(\varphi''_4),\xi,t)$'); hold on
scatter( time_4(t1),bool_1_dur(t1),  'o', 'LineWidth', 2, 'DisplayName','$r(R_{4,4}(\varphi''_4),\xi,61.5)$');
scatter(time_4(t2),bool_1_dur(t2), 's', 'LineWidth', 2, 'DisplayName','$r(R_{4,4}(\varphi''_4),\xi,61.6)$');
scatter(  time_4(t3),bool_1_dur(t3),  'd', 'LineWidth', 2, 'DisplayName','$r(R_{4,4}(\varphi''_4),\xi,65)$');
xlabel('time [s]')
ylabel('Durability','rotation',0,'HorizontalAlignment','right');
xlim([0,time_4(end)])
legend('Interpreter','latex', 'FontSize', 9);
axes('Position',[.2 .2 .2 .12])
plot(time_4(1229:1335),bool_1_dur(1229:1335), 'LineWidth', 2); hold on
xticks([time_4(1231),time_4(1232),time_4(1233)]);yticks([]);
xlim([time_4(1229),time_4(1235)])
ylim([bool_1_dur(1229)-0.3,bool_1_dur(1235)+0.3])
scatter( time_4(t1),bool_1_dur(t1),  'o', 'LineWidth', 2);
scatter(time_4(t2),bool_1_dur(t2), 's', 'LineWidth', 2);
scatter(  time_4(t3),bool_1_dur(t3),  'd', 'LineWidth', 2);
set(gcf, 'renderer','painters');
print('MAV_resv2d','-dpng','-r400')
%% todo: add a third 3d plot for t-rec-dur.
figure;
scatter3(bool_1_rec, bool_1_dur, time_4,'.','LineWidth', 2, 'DisplayName','$r(\varphi''_4,\xi,t)$'); hold on
% projection in t-rec plan at dur = -5
scatter3(bool_1_rec, (-10)*ones(size(bool_1_dur)), time_4,'r.','LineWidth', 2, 'DisplayName','$r(\varphi''_4,\xi,t)$ Projection');
% projection in t-dur plan at rec = 10
scatter3( 30*ones(size(bool_1_rec)), bool_1_dur, time_4,'r.','LineWidth', 2,'HandleVisibility','off');
t1=1229; t2=1261; t3=1301;
scatter3( bool_1_rec(t1), bool_1_dur(t1), time_4(t1), 'o', 'LineWidth', 2, 'DisplayName','$r(\varphi''_4,\xi,61.4)$');
scatter3(bool_1_rec(t2), bool_1_dur(t2), time_4(t2), '*', 'LineWidth', 2, 'DisplayName','$r(\varphi''_4,\xi,63)$');
scatter3( bool_1_rec(t3), bool_1_dur(t3), time_4(t3), 'd', 'LineWidth', 2, 'DisplayName','$r(\varphi''_4,\xi,65)$');
grid on
zlabel('time [s]')
xlabel('Recoverability')
ylabel('Durability')
legend('Interpreter','latex')
%%
t1=1229; t2=1261; t3=1301;
figure;
% yyaxis left
subplot(2,1,1)
plot(time_4,bool_1_rec, 'LineWidth', 2, 'DisplayName','$r(\varphi''_4,\xi,t)$'); hold on
scatter( time_4(t1),bool_1_rec(t1),  'o', 'LineWidth', 2, 'DisplayName','$r(\varphi''_4,\xi,61.4)$');
scatter(time_4(t2),bool_1_rec(t2), 's', 'LineWidth', 2, 'DisplayName','$r(\varphi''_4,\xi,63)$');
scatter(  time_4(t3),bool_1_rec(t3),  'd', 'LineWidth', 2, 'DisplayName','$r(\varphi''_4,\xi,65)$');
xlabel('time [s]')
ylabel('Recoverability','rotation',0,'HorizontalAlignment','right');
xlim([0,time_4(end)])
legend('Interpreter','latex', 'FontSize', 9);
subplot(2,1,2)
% yyaxis right
plot(time_4,bool_1_dur, 'LineWidth', 2, 'DisplayName','$r(\varphi''_4,\xi,t)$'); hold on
scatter( time_4(t1),bool_1_dur(t1),  'o', 'LineWidth', 2, 'DisplayName','$r(\varphi''_4,\xi,61.4)$');
scatter(time_4(t2),bool_1_dur(t2), 's', 'LineWidth', 2, 'DisplayName','$r(\varphi''_4,\xi,63)$');
scatter(  time_4(t3),bool_1_dur(t3),  'd', 'LineWidth', 2, 'DisplayName','$r(\varphi''_4,\xi,65)$');
xlabel('time [s]')
ylabel('Durability','rotation',0,'HorizontalAlignment','right');
xlim([0,time_4(end)])
legend('Interpreter','latex', 'FontSize', 9);
set(gcf, 'renderer','painters');
print('MAV_resv2d','-dpng','-r400')

function [bool_1_rec,bool_1_dur]= rec_dur(bool_1, time, alpha, beta)
    bool_1_rec = zeros(size(bool_1));
    bool_1_dur = zeros(size(bool_1));
    for i = 1:numel(bool_1)
        next_true = find_next_true_idx(bool_1, i);
        if isempty(next_true)
            bool_1_rec(i) = -(time(end) - time(i)) + alpha;
            next_true = i;
        else
            bool_1_rec(i) = -(time(next_true) - time(i)) + alpha;
        end
        next_false = find_next_false_idx(bool_1, next_true);
        if isempty(next_false)
            bool_1_dur(i) = (time(end) - time(next_true)) - beta;
        else
            bool_1_dur(i) = (time(next_false) - time(next_true)) - beta;
        end
    end
end




function n_idx_cali = find_next_false_idx(array, idx)
    n_idx = find(array(idx:end)<0.5, 1);
    n_idx_cali = n_idx + idx -1;
end

function n_idx_cali = find_next_true_idx(array, idx)
    n_idx = find(array(idx:end)>0.5, 1);
    n_idx_cali = n_idx + idx -1;
end