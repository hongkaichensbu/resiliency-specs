function resv = set_recoverability(resv, options)

% want to make an ReS of two elements with recoverability 10 and 15.
% resv = set_recoverability(resv, Target = [10, 15], Increment = 0);
arguments
    resv (1,1) ReSV
    options.Target (1,:) {mustBeVector} = [];
    options.Increment (1,1) {mustBeNumeric} = 0;
end
num_ele = numel(resv.element);
if ~isempty(options.Target)
    assert(numel(options.Target)==num_ele);
    for i = 1:num_ele
        resv.element{i}.values{1,1} = options.Target(i) + options.Increment;
        resv.element{i}.values{1,1} = round(resv.element{i}.values{1,1},3);
    end
else
    for i = 1:num_ele
        resv.element{i}.values{1,1} = resv.element{i}.values{1,1} + options.Increment;
        resv.element{i}.values{1,1} = round(resv.element{i}.values{1,1},3);
    end
end

end

