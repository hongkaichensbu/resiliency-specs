function number_array = num_cc(x,y, radius)
% number of connected components
% x, y: coordinates of boids
%  m-by-n: m is number of step, n is the number of boids
% radius: spatial neighbors in an interactive radius

assert(isequal(size(x),size(y)));
[stepSize, boidSize] = size(x);

number_array = zeros(1,stepSize);
for step = 1:stepSize  % for each step
    components = cell(1);
    components{1} = [x(step, 1), y(step, 1)];
    for i = 2:boidSize   % for each boid
        for j = 1:numel(components)  % for each component
            in_component = 0;
            for k = 1:size(components{j},1)  % for each boid in that component
                components_coord = components{j};
                if norm([x(step, i), y(step, i)] - components_coord(k,:)) <= radius
                   components{j} = cat(1, components{j}, [x(step, i), y(step, i)]);
                   in_component = 1;
                   break
                end
            end
            if in_component == 1
                break
            end
        end
        if in_component == 0 % if boid i is not belong to any component j
            components = cat(2, components, [x(step, i), y(step, i)]);
        end
    end
    number_array(step) = numel(components);
end



end


