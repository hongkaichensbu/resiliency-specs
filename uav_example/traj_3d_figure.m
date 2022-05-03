InitReSV;
load mavtraj.mat

%%
figure
h_3d = gca;
h_pos_hist = plot3(h_3d, x_4, y_4, z_4, 'r-','LineWidth',1.5);
hold(h_3d, 'on')
% legend(h_pos_hist, 'UAV Trajectory');
building_3d(h_3d); 
labels = {'x [m]', 'y [m]', 'z [m]'};
grid off
c = [1;1;1;1];
fill3(gca, [-25,-25,25,25],...
        [-25,25,25,-25],...
        [0,0,0,0], c, 'EdgeColor', 'none', 'LineWidth', 2,'HandleVisibility','off');
% i=350;
% h=quiver3(x_4(i), y_4(i), z_4(i),   x_4(i+5)-x_4(i), y_4(i+5)-y_4(i), z_4(i+5)-z_4(i),10, 'r','LineWidth',1.5)
% set(h,'MaxHeadSize',50);
% quiver3(x_4(250), y_4(250), z_4(250),   x_4(251)-x_4(245), y_4(251)-y_4(245), z_4(251)-z_4(245),5, 'r')
xlabel(labels{1},'FontSize',14);
ylabel(labels{2},'rotation',0,'FontSize',14);
zlabel(labels{3},'rotation',0,'HorizontalAlignment','right','FontSize',14);
xlim([-18,18])
ylim([-15,10])
zlim([0,30])
print('mav_3d','-dpng','-r400')