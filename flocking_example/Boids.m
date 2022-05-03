% Project - Boid Simulation
% Author: Jin Woo Ahn
InitReSV
clear all;
% close all;

numBoids = 30;  %70; %30      % Number of boids to be simulated.
numPreds = 0;      % Number of predators to be simulated.
height = 300;       % Height of the world.
width = 300;        % Width of the world.
iteration = 5001;    % Number of simulation times.
b_max_speed = 2;      % Maximum speed of boids.
p_max_speed = 1.8;      % Maximum speed of predators.

WRITE_VIDEO = 0;

% Create a World object.
world = World(height, width);

% Create an array of Boid objects.
for i = 1: numBoids
    boids(i)= Boid;
end

% boids(numBoids) = Boid;

% Create an array of Predator objects.
if numPreds == 0
    preds = 0;
else
    preds(numPreds) = Predator;
end

rng(51);
% Initialize the boids with random color, coordinate, and velocity.
for i = 1 : numBoids
    boids(i).color_r = rand;
    boids(i).color_g = rand;
    boids(i).color_b = rand;
    boids(i).velocity = [rand * (b_max_speed * 2) - (b_max_speed / 2), rand * (b_max_speed * 2) - (b_max_speed / 2)];
    boids(i).coord = [(rand * height - 1) + 1, (rand * width - 1) + 1];
    boids(i).set_height_and_width(height, width);
    boids(i).set_max_speed(b_max_speed);
end

% Initialize the preds with random coordinate and velocity.
if numPreds ~= 0
    for i = 1 : numel(preds)
        preds(i).coord = [(rand * height - 1) + 1, (rand * width - 1) + 1];
        preds(i).set_max_speed(b_max_speed);
        preds(i).set_height_and_width(height, width);
        preds(i).velocity = [rand * (p_max_speed * 2) - (p_max_speed / 2), rand * (p_max_speed * 2) - (p_max_speed / 2)];
    end
end

if WRITE_VIDEO == 1
% Create video writer object.
video = VideoWriter('Boids.avi', 'Motion JPEG AVI');
% Set the frame rate.
video.FrameRate = 20;
% Open the video file.
open(video);
end

% Start the simulation.

x_boid = zeros(iteration, numBoids);
y_boid = zeros(iteration, numBoids);
x_dot_boid = zeros(iteration, numBoids);
y_dot_boid = zeros(iteration, numBoids);

% rng(10);
boids_all = [];
for t = 1 : iteration
    % Simulation of boids.
%     boids_tmp(numBoids) = Boid;
    for i = 1:numBoids
        boids_tmp(i) = Boid;
        boids_tmp(i).coord = boids(i).coord;
        boids_tmp(i).velocity = boids(i).velocity;
    end
%     boids_all = cat(1, boids_all, boids);
    for i = 1:numBoids
        x_boid(t,i) = boids(i).coord(1);
        y_boid(t,i) = boids(i).coord(2);
        x_dot_boid(t,i) = boids(i).velocity(1);
        y_dot_boid(t,i) = boids(i).velocity(2);
    end
    bool = rand(1,numBoids); % uniformaly random displacement
    [~,idx] = sort(bool);
    displace_numBoids = 20;
    picked = idx(1:displace_numBoids);
    for i = 1 : numBoids
        boids(i).move(boids_tmp, preds);
        % location disturbance
        if ismember(i, picked)
            if (t > 1000 && t <1500)
                boids(i).offset(20);
            elseif (t>2500 && t<3000)
                boids(i).offset(20);
            elseif (t>4000 && t<4500)
                boids(i).offset(20);
            end
        end
        world.draw_boids(boids(i));
    end


    % Simulation of predators.
    if numPreds ~= 0
        for j = 1 : numel(preds)
            preds(j).move(boids_tmp);
            world.draw_predator(preds(j));
        end
    end
    if WRITE_VIDEO == 1
        writeVideo(video, imresize(world.outputWorld, [height, width]));
    end
end

if WRITE_VIDEO == 1
% Close video.
close(video);
end


