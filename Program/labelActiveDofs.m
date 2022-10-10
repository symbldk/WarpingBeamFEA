function [E,NumEq] = labelActiveDofs(NumNode,NumSupport,S)
%labelActiveDofs 
%   Creates matrix "E" storing equation numbers(active dofs)
%   and also returns "NumEq" which is the total #of eqns(dofs) in the structure
%   S = (node, Tx, Ty, Tz, Rx, Ry, Rz, W) for restrained nodes
%   E = (Tx_dof, Ty_dof, Tz_dof, Rx_dof, Ry_dof, Rz_dof, W_dof) for nodes
%   C = (startNode, endNode, property ID, Type, Warping, Lb)

E = zeros(NumNode,7);

% mark the restrained (inactive) degrees of freedom locations in E using S
for i = 1:NumSupport
    if S(i,2) == 1, E(S(i,1),1) = 1; end
    if S(i,3) == 1, E(S(i,1),2) = 1; end
    if S(i,4) == 1, E(S(i,1),3) = 1; end
    if S(i,5) == 1, E(S(i,1),4) = 1; end
    if S(i,6) == 1, E(S(i,1),5) = 1; end
    if S(i,7) == 1, E(S(i,1),6) = 1; end
    if S(i,8) == 1, E(S(i,1),7) = 1; end
end

%number active d.o.fs
NumEq = 0;
Erows = size(E,1); Ecolumns = size(E,2);
for i = 1:Erows
    for j = 1:Ecolumns
        if E(i,j) == 0
            NumEq = NumEq + 1;
            E(i,j) = NumEq;
        else
            E(i,j) = 0;
        end
    end
end

end

