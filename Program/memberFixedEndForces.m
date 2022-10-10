function [ff] = memberFixedEndForces(el, Le, ML_structure, C)
%memberFixedEndForces 
%   This function constructs 
%   ML = (member, Uniform Load in local-y, Uniform Torsion in local-x) for loaded members

w = ML_structure(el,1);
t = ML_structure(el,2);
    
% numDofs: number of dofs at each node of the element
if (C(el,4) == 1)||(C(el,4) == 2) % Beam and Beam with Jeff
    numDofs = 6;
    ff = zeros(12,1);
elseif C(el,4) == 3 % Warping Beam
    numDofs = 7;
    ff = zeros(14,1);
elseif C(el,4) == 4 % Truss
    numDofs = 3;
    ff = zeros(6,1);
end

if C(el,4) ~= 4 % Other than Truss elements
    %form fixed-end force vector in member local coordinates
    ff(4,1)           = -t*Le/2;
    ff(numDofs+4,1)   = -t*Le/2;

    ff(3,1)           = -w*Le/2;
    ff(5,1)           = w*Le^2/12;
    ff(numDofs+3,1)   = -w*Le/2;
    ff(numDofs+5,1)   = -w*Le^2/12;
end
end

