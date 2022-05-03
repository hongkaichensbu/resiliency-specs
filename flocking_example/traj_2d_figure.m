numBoids = size(x_boid,2);
time = 0:length(x_boid)-1;
time = time/10;

omega = 0.01;
radius = 25;

J_array = declarative_cost(x_boid, y_boid, omega, radius);

% figure;
% plot(time, J_array, 'LineWidth',2);
% ylabel('Declarative Cost')
% xlabel('time [s]')

radius = 25;
number_array = num_cc(x_boid, y_boid, radius);

% figure;
% plot(time, number_array, 'LineWidth',2);
% ylabel('Number of connected components')
% xlabel('time [s]')
% ylim([1,numBoids])
% yticks([1:5:30, 30])

figure;
subplot(1,2,1)
plot(time(1:2:end), J_array(1:2:end), 'LineWidth',1.5);
ylabel('$J(\mathbf{x})$','Interpreter','latex', 'FontSize', 10,'rotation',0,'HorizontalAlignment','right');
xlabel('time [s]')
ylim([min(J_array(1:2:end)), max(J_array(1:2:end))])
yticks([min(J_array(1:2:end)), 1E4, 2E4,3E4]);% max(J_array(1:2:end))])
subplot(1,2,2)
plot(time(1:4:end), number_array(1:4:end), 'LineWidth',1.5);
ylabel('$|CC(\mathbf{x})|$','Interpreter','latex', 'FontSize', 10,'rotation',0,'HorizontalAlignment','right');
xlabel('time [s]')
ylim([1,numBoids])
yticks([1:5:30, 30])
print('flock_traj','-dpng','-r400')
% a = []
% for i = 1:size(x_boid,1)
%     a = [a , boids_all(i,1).coord(1)];
% end
% plot(a)