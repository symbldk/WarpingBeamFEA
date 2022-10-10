function [d] = getElementEndDisplacements(el, C, E, D)
%getElementEndDisplacements
%   This function forms the vector {d} of element end displacements
%   in global coordinates by using the structural displacement matrix D
%   which is solved for active dofs (others will be zero in d)


%start node ID end end node ID of the element 
startNode = C(el,1);
endNode = C(el,2);

% get elemDofs: array of element dofs' corresponding structural dofs
% NumDofs: number of element dofs
if (C(el,4) == 1)||(C(el,4) == 2) % Beam and Beam with Jeff
    elemDofs = [E(startNode,1:6),E(endNode,1:6)]';
    NumDofs = 12;
elseif C(el,4) == 3 % Warping Beam
    elemDofs = [E(startNode,:),E(endNode,:)]';
    NumDofs = 14;
elseif C(el,4) == 4 % Truss
    elemDofs = [E(startNode,1:3),E(endNode,1:3)]';
    NumDofs = 6;
end

d = zeros(NumDofs,1);
for i = 1:NumDofs %for each dof of element
    if elemDofs(i,1) ~= 0 %for active (solved) dofs (in D)
        d(i,1) = D(elemDofs(i,1),1);
    end
end

end

