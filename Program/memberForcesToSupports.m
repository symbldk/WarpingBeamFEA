function [R] = memberForcesToSupports(el, f_global, R, E, C)
%memberForcesToSupports 
%   This function stores member forces going to supports.
%   E = (Tx_dof, Ty_dof, Tz_dof, Rx_dof, Ry_dof, Rz_dof, W_dof) for nodes
%   C = (startNode, endNode, property ID, Type, Warping, Lb) for elements

for i = 1:2
    node = C(el,i);
    R(node,1) = node;
    for j = 1:7
        if E(node,j)== 0
            R(node,j+1) = R(node,j+1) + f_global(j+7*(i-1),1);
        end
    end
end

end

