function resv = set_timestamp(resv,options)
arguments
    resv (1,1) ReSV
    options.Target (1,:) {mustBeVector} = [];
    options.Increment (1,1) {mustBeNumeric} = 0;
end
num_ele = numel(resv.element);
if ~isempty(options.Target)
    assert(numele(options.Target)==num_ele);
    for i = 1:num_ele
        resv.element{i}.t = options.Target(i) + options.Increment;
        resv.element{i}.t = round(resv.element{i}.t,3);
    end
else
    for i = 1:num_ele
        resv.element{i}.t = resv.element{i}.t + options.Increment;
        resv.element{i}.t = round(resv.element{i}.t,3);
    end
end

end

