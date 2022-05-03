function [] = building_3d(gca)
%BUILDING_POINTS Summary of this function goes here
%   Detailed explanation goes here

linewidth = 2;
linewidth2 = 1.5;
color = '#EDB120';
color2 = '#77AC30';
color3 = '#7E2F8E';
color4 = '#0072BD';

building_center(1,:) = [-10,0];
building_center(2,:) = [10,-5];

% building_height = 29;
x = 4;
y = 5;

% two delivery locations.
n = 30;
[X,Y,Z] = sphere(n);
X1 = X - 10;
Y1 = Y - 0;
Z1 = Z + 30;
% h = surf(X1,Y1,Z1,1,'FaceColor','y','LineStyle','none','DisplayName','Delivery Locations');
% set(h, 'FaceAlpha', 0.5)
% scatter3(-10,0,30,10,'filled','k','HandleVisibility','off');
% text(-10,0,30+0.2,'C_1');
X2 = X + 10;
Y2 = Y - 5;
Z2 = Z + 20;
% h = surf(X2,Y2,Z2,1,'FaceColor','y','LineStyle','none','HandleVisibility','off');
% set(h, 'FaceAlpha', 0.5)
% scatter3(10,-5,20,10,'filled', 'k','HandleVisibility','off');
% text(10,-5,20+0.2,'C_2');

% Base location
X3 = X - 5;
Y3 = Y - 10;
Z3 = max(0,Z);
% h = surf(X3,Y3,Z3,1,'FaceColor','b','LineStyle','none','DisplayName','Base Location');
% set(h, 'FaceAlpha', 0.5)
% scatter3(-5,-10,0,10,'filled', 'k','HandleVisibility','off');
% text(-5,-10,0+0.2,'C_3');

% Starting point
radius = 4.5;
x_s = radius*cos(0);
y_s = radius*sin(0);
ground_center = [10;10];
x_s = x_s - ground_center(1);
y_s = y_s -ground_center(2);
% scatter3(x_s,y_s,0,50,'filled','p','HandleVisibility','off');
text(x_s-5,y_s,0+1.5,'A (t=0)', 'FontSize', 12, 'FontWeight','bold');
%802
% scatter3(-5.50387993249042, -10.0748487177743, 29.9999752991876,50,'filled','k','HandleVisibility','off');
text(-3.80387993249042, -10.0748487177743, 29.9999752991876+1.5,'B (t=40)', 'FontSize', 12, 'FontWeight','bold');
%1069
% scatter3(0, 0, 30,50,'filled','k','HandleVisibility','off');
text(0, 0, 30+1.5,'C (t=60)', 'FontSize', 12, 'FontWeight','bold');
% 
% scatter3(-4.5, -10, 20,50,'filled','k','HandleVisibility','off');
text(-2.5, -10, 20+2.5,'D (t=80)', 'FontSize', 12, 'FontWeight','bold');
% 
% scatter3(-4.5, -10, 0,10,'filled','k','HandleVisibility','off');
text(-4.5+1, -10, 0 +1.5,'E (t=130)', 'FontSize', 12, 'FontWeight','bold');

% distance marker to buildings
point = [-10.01111, -14.3772, 26.8256;
    -10.2943, -14.2077, 12.0802;
    -10.0461, -5.59579, 4.37372;
    -9.99212, -5.82076, 19.7259];
i = 1;
% plot3(gca, [point(i,1),point(i,1)], [point(i,2),-5],[point(i,3),point(i,3)],'--','Color',color4,'LineWidth', linewidth2,'DisplayName','Distance to Building');
% for i = 2:4
%     plot3(gca, [point(i,1),point(i,1)], [point(i,2),-5],[point(i,3),point(i,3)],'--','Color',color4,'LineWidth', linewidth2,'HandleVisibility','off');
% end

% shading interp
% r=1;
% teta=-pi:0.01:pi;
% X1=r*cos(teta);
% Y1=r*sin(teta);
% plot3(gca, X1-10,Y1+0,30*ones(1,numel(X1)),'Color',color2, 'LineWidth', linewidth2,'DisplayName','Delivery Location 1');
% plot3(gca, X1-10,zeros(1,numel(X1)),Y1+30,'Color',color2, 'LineWidth', linewidth2,'HandleVisibility','off');
% plot3(gca, (-10)*ones(1,numel(X1)),X1,Y1+30,'Color',color2, 'LineWidth', linewidth2,'HandleVisibility','off');


% b=1;height=0;
% plot3(gca, [building_center(b,1)-x,building_center(b,1)+x],[building_center(b,2)-y,building_center(b,2)-y],[height,height],'Color',color, 'LineWidth', linewidth,'DisplayName','Building');
% for b = 1:2
%     if b == 1
%         building_height = 28;
%     else
%         building_height = 18;
%     end
%     for height = [0,building_height]
%         plot3(gca, [building_center(b,1)-x,building_center(b,1)+x],[building_center(b,2)-y,building_center(b,2)-y],[height,height],'Color',color, 'LineWidth', linewidth,'HandleVisibility','off');
%         plot3(gca, [building_center(b,1)+x,building_center(b,1)+x],[building_center(b,2)-y,building_center(b,2)+y],[height,height], 'Color',color,'LineWidth', linewidth,'HandleVisibility','off');
%         plot3(gca, [building_center(b,1)+x,building_center(b,1)-x],[building_center(b,2)+y,building_center(b,2)+y],[height,height], 'Color',color,'LineWidth', linewidth,'HandleVisibility','off');
%         plot3(gca, [building_center(b,1)-x,building_center(b,1)-x],[building_center(b,2)+y,building_center(b,2)-y],[height,height], 'Color',color,'LineWidth', linewidth,'HandleVisibility','off');
%     end
%     for i = [-x,x]
%         for j = [-y,y]
%             plot3(gca, [building_center(b,1)+i,building_center(b,1)+i],[building_center(b,2)+j,building_center(b,2)+j],...
%                 [0,height],'Color',color, 'LineWidth', linewidth,'HandleVisibility','off');
%         end
%     end
% end

colormap parula;
c = [1;1;0.3; 0.3];
c2 = [0.33;0.33;0.33;0.33];
linewidth = 1;
for b = 1:2
    if b == 1
        building_height = 28;
    else
        building_height = 18;
    end
    if b == 1
    fill3(gca, [building_center(b,1)-x,building_center(b,1)+x,building_center(b,1)+x,building_center(b,1)-x],...
        [building_center(b,2)-y,building_center(b,2)-y,building_center(b,2)-y,building_center(b,2)-y],...
        [0,0, building_height,building_height],	c, 'FaceColor','interp', 'EdgeColor', 'none', 'LineWidth', linewidth,'DisplayName','Building');
    else
    fill3(gca, [building_center(b,1)-x,building_center(b,1)+x,building_center(b,1)+x,building_center(b,1)-x],...
        [building_center(b,2)-y,building_center(b,2)-y,building_center(b,2)-y,building_center(b,2)-y],...
        [0,0, building_height,building_height],	c,  'EdgeColor', 'none', 'LineWidth', linewidth,'HandleVisibility','off');        
    end
    fill3(gca, [building_center(b,1)+x,building_center(b,1)+x,building_center(b,1)+x,building_center(b,1)+x],...
        [building_center(b,2)-y,building_center(b,2)+y,building_center(b,2)+y,building_center(b,2)-y],...
        [0,0,building_height,building_height],	c, 'EdgeColor', 'none', 'LineWidth', linewidth,'HandleVisibility','off');
    fill3(gca, [building_center(b,1)+x,building_center(b,1)-x,building_center(b,1)-x,building_center(b,1)+x],...
        [building_center(b,2)+y,building_center(b,2)+y,building_center(b,2)+y,building_center(b,2)+y],...
        [0,0,building_height,building_height], c, 'EdgeColor', 'none', 'LineWidth', linewidth,'HandleVisibility','off');
    fill3(gca, [building_center(b,1)-x,building_center(b,1)-x,building_center(b,1)-x,building_center(b,1)-x],...
        [building_center(b,2)+y,building_center(b,2)-y,building_center(b,2)-y,building_center(b,2)+y],...
        [0,0,building_height,building_height], c, 'EdgeColor', 'none', 'LineWidth', linewidth,'HandleVisibility','off');
    %
    fill3(gca, [building_center(b,1)-x,building_center(b,1)-x,building_center(b,1)+x,building_center(b,1)+x],...
        [building_center(b,2)+y,building_center(b,2)-y,building_center(b,2)-y,building_center(b,2)+y],...
        [building_height,building_height,building_height,building_height], c2, 'EdgeColor', 'none', 'LineWidth', linewidth,'HandleVisibility','off');
end
% 
% imageIn = imread('window.png');
% % upperLeftPoint3 = [-14, -5, 28];
% normal = [0, -1, 0];
% imXDirVec = [1,0,0];
% scale = 0.04;
% for i = -14:4:-10
%     for j = 28:-4:4
%         upperLeftPoint3 = [i, -5, j];
%         h=imsurf(imageIn,upperLeftPoint3,normal,imXDirVec,scale);
%     end
% end

end

