function [F] = constructLoadVector(NumEq, NumLoadJoint, E, L)
%constructLoadVector 
%   This function constructs the global load vector F
%   E = (Tx_dof, Ty_dof, Tz_dof, Rx_dof, Ry_dof, Rz_dof, W_dof) for nodes
%   L = (node, Fx, Fy, Fz, Mx, My, Mz, B) for loaded joints

F = zeros(NumEq,1);

for i = 1:NumLoadJoint
    node = L(i,1); %node ID number
    for j = 1:7
        dof = E(node,j); %for each dof at this node
        if dof ~= 0 %for active dofs
            F(dof,1) = L(i,j+1); %accumulate load vector
        end
    end
end

end

