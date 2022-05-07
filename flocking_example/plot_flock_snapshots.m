figure;
tt = tiledlayout(1,4,'TileSpacing','none','Padding','Compact');

t = [1, 645, 3000, 3330];

for j = 1:4
gca = nexttile;
hold on
for i = 1:size(x_boid,2)
    a=[x_dot_boid(t(j),i), y_dot_boid(t(j),i)]/(1*norm([x_dot_boid(t(j),i), y_dot_boid(t(j),i)]));
    if j == 2 
        a = a/2;
    elseif j == 4
        a = a/3;
    elseif j == 1 || j == 3
        a = a *1.5;
    end
    q = quiver(x_boid(t(j),i), y_boid(t(j),i),a(1),a(2),10,'color',[0.35, 0.35, 0.35],'LineWidth',1);
    q.MaxHeadSize = 20;
    q.AutoScale = 'on';
    gca.Box = 'on';
%     gca.Color = 'r';
end
ax = gca;
ax.LineWidth = 1;
switch j
    case 2
        xlim([220,280])
        ylim([120,200])
    case 1 
        xlim([100,300])
        ylim([0,200])
    case 3
        xlim([70,270])
        ylim([80,280])
    case 4
        xlim([90,140])
        ylim([250,280])
end

xticks([])
yticks([])

end

% print('flock_snapshot','-dpng','-r400')