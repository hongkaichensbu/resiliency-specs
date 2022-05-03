figure;hold on
t = 10;
r = 25;
th = 0:pi/100:2*pi;
x = r* cos(th);
y = r*sin(th);
for i = 1:size(x_boid,2)
    scatter(x_boid(t,i), y_boid(t,i),'r','filled');
%     viscircles([x_boid(t,i), y_boid(t,i)],20, 'Color', '#4DBEEE');
    fill(x+x_boid(t,i), y+y_boid(t,i), 'yellow', 'EdgeColor','none','FaceAlpha',0.2);
    fill(x/5+x_boid(t,i), y/5+y_boid(t,i), 'blue', 'EdgeColor','none','FaceAlpha',0.2);
    h = quiver(x_boid(t,i), y_boid(t,i),x_dot_boid(t,i), y_dot_boid(t,i),10,'k','LineWidth',2,...
        'AutoScaleFactor',10);
    set(h,'MaxHeadSize',50);
end
xlabel('x [m]')
ylabel('y [m]')
xlim([0,150])
ylim([0,150])

t= 700;
figure;hold on
r = 25;
th = 0:pi/100:2*pi;
x = r* cos(th);
y = r*sin(th);
for i = 1:5
    scatter(x_boid(t,i), y_boid(t,i),'r','filled');
%     viscircles([x_boid(t,i), y_boid(t,i)],20, 'Color', '#4DBEEE');
    fill(x+x_boid(t,i), y+y_boid(t,i), 'yellow', 'EdgeColor','none','FaceAlpha',0.2);
    fill(x/5+x_boid(t,i), y/5+y_boid(t,i), 'blue', 'EdgeColor','none','FaceAlpha',0.2);
    h = quiver(x_boid(t,i), y_boid(t,i),x_dot_boid(t,i), y_dot_boid(t,i),10,'k','LineWidth',2,...
        'AutoScaleFactor',10);
    set(h,'MaxHeadSize',50);
end
xlabel('x [m]')
ylabel('y [m]')
xlim([0,150])
ylim([0,150])