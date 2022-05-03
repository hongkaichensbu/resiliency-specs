function resv = set_durability(resv, options)

arguments
    resv (1,1) ReSV
    options.Target (1,:) {mustBeVector} = [];
    options.Increment (1,1) {mustBeNumeric} = 0;
end
num_ele = numel(resv.element);
if ~isempty(options.Target)
    assert(numel(options.Target)==num_ele);
    for i = 1:num_ele
        resv.element{i}.values{1,2} = options.Target(i) + options.Increment;
        resv.element{i}.values{1,2} = round(resv.element{i}.values{1,2},3);
    end
else
    for i = 1:num_ele
        resv.element{i}.values{1,2} = resv.element{i}.values{1,2} + options.Increment;
        resv.element{i}.values{1,2} = round(resv.element{i}.values{1,2},3);
    end
end

end

