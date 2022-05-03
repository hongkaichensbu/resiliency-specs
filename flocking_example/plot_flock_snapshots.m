% figure;
tt = tiledlayout(1,4,'TileSpacing','none','Padding','Compact');

t = [1, 645, 3000, 3330];%3294];

for j = 1:4
% subplot(2,2,j); 
nexttile
hold on
for i = 1:size(x_boid,2)
%     scatter(x_boid(t(j),i), y_boid(t(j),i),'r','filled','^');
    a=[x_dot_boid(t(j),i), y_dot_boid(t(j),i)]/norm([x_dot_boid(t(j),i), y_dot_boid(t(j),i)]);
    if j == 2 
        a = a/2;
    elseif j == 4
        a = a/3;
    elseif j == 1 || j == 3
        a = a *1.5;
    end
    quiver(x_boid(t(j),i), y_boid(t(j),i),a(1),a(2),10,'k','LineWidth',2);
end
ax = gca;
ax.LineWidth = 1;
switch j
    case 2
        xlim([220,280])
        ylim([120,200])
%                 xlim([100,300])
%         ylim([0,200])
    case 1 
        xlim([100,300])
        ylim([0,200])
    case 3
        xlim([100,300])
        ylim([80,280])
    case 4
        xlim([90,140])
        ylim([250,280])
end

xticks([])
yticks([])
% if j == 1 || j ==2
% xticks([])
% else
%     xlabel('x [m]');
% end
% if j ==2 ||j==4
% yticks([])
% else
%     ylabel('y [m]','rotation',0,'HorizontalAlignment','right');
% end
% if j == 3
%    xticks([0,100,200])
%    yticks([0:50:250])
% end 
% xlabel('x [m]')
% ylabel('x [m]')
end

% print('flock_snapshot','-dpng','-r400')