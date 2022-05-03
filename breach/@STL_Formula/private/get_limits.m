function [a, b] = get_limits(psi)
%GET_ID provides the recoverability and durability limits of the base case 
%  STL-based resilience specification psi
% 
% Synopsis: [a, b] = get_limits(psi)
%
assert(psi.is_base==true,'not a base case STL-based resilience specification.');
a=psi.limits(1);
b=psi.limits(2);
end
