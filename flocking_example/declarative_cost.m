function J_array = declarative_cost(x, y, omega, radius)
% x, y: coordinates of boids
%  m-by-n: m is number of step, n is the number of boids
% omega: weight for separation term
% radius: spatial neighbors in an interactive radius

assert(isequal(size(x),size(y)));
[stepSize, boidSize] = size(x);

J_array = zeros(1,stepSize);
for step = 1:stepSize
    %cohesion term
    if step == 612
        step = step;
    end
    cohesion_sum = 0;
    separation_sum = 0;
    for i = 1:boidSize-1
        for j = i+1:boidSize
            distance_tmp = norm([x(step, i) - x(step, j), y(step, i) - y(step, j)])^2;
            if distance_tmp < 1
                distance_tmp = distance_tmp;
            end
            cohesion_sum = cohesion_sum + distance_tmp;
            if distance_tmp <= radius^2
                separation_sum = separation_sum + 1/distance_tmp;
            end
        end
    end
cohesion_term = 2/(boidSize*(boidSize-1)) * cohesion_sum;
separation_term = omega * separation_sum;
J_array(step) = cohesion_term + separation_term;
end

end

