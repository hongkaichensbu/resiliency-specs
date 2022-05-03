function [b, phi] = STL_Resilience_CheckID(id)
% a modified version of STL_CheckID function in Breach.
% https://github.com/decyphir/breach
% 0 doesn't exist, 1 predicate, 2 formula, 3 explicit predicate (generated id)
b=0; 
phi = [];
InitReSV
global ReSVGlobOpt;

if isfield(ReSVGlobOpt, 'STLDB')
    if ReSVGlobOpt.STLDB.isKey(id)
       if strcmp(get_type(ReSVGlobOpt.STLDB(id)),'predicate')
           if ~isempty(regexp(id,'.+__$', 'once'))
               b=3;
           else
               b=1;
           end
       else
           b=2;
       end
        phi = ReSVGlobOpt.STLDB(id);
    end
end
    
    