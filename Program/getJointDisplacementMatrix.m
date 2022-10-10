function [JD] = getJointDisplacementMatrix(NumNode,E,D)
%getJointDisplacementMatrix 
%   Creates joint displacement matrix "JD"
%   JD = (node, Tx, Ty, Tz, Rx, Ry, Rz, W) for nodes
%   E = (Tx_dof, Ty_dof, Tz_dof, Rx_dof, Ry_dof, Rz_dof, W_dof) for nodes
%   D = array of nodal displacements

JD = zeros(NumNode,8); 

%number active d.o.fs
Erows = size(E,1); Ecolumns = size(E,2);
for i = 1:Erows
    JD(i,1) = i;
    for j = 1:Ecolumns
        if E(i,j) ~= 0
            JD(i,j+1) = D(E(i,j),1);
        end
    end
end

end

