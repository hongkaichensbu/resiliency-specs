function initBoolean = eval_bool(formula,trace_param, time, trace, t_idx)

Rphi_tmp = BreachRequirement(formula);

shifted_trace = trace(:, t_idx:end);
shifted_time = time(1:end-t_idx+1);
Bdata_tmp = BreachTraceSystem(trace_param);
Bdata_tmp.AddTrace([shifted_time', shifted_trace']);

initBoolean = Rphi_tmp.evalAllTraces(Bdata_tmp);

Rphi_tmp.ResetEval(); % BreachRequirement need to reset in order to eval again
Bdata_tmp.ResetSampling(); % remove all traces

end

