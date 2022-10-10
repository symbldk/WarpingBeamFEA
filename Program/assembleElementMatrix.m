function [K] = assembleElementMatrix(k_global, K, el, C, E)
%assembleElementMatrix
%   This function assembles element stiffness in global coordinates, k_global
%   into structural stiffness matrix K, by finding the address in K for
%   each term of k_global 
%   C = (startNode, endNode, property ID, Type, Warping, Lb) for elements
%   E = (Tx_dof, Ty_dof, Tz_dof, Rx_dof, Ry_dof, Rz_dof, W_dof) for nodes

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

%assemble into K
for i = 1:NumDofs
	for j = 1:NumDofs
        %assemble only for active dofs (nonzero dofs)
		if elemDofs(i) ~= 0 && elemDofs(j) ~= 0 
			K(elemDofs(i),elemDofs(j)) = K(elemDofs(i),elemDofs(j)) + k_global(i,j);
		end
	end
end

end

