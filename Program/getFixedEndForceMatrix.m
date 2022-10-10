function [Ff] = getFixedEndForceMatrix(NumEq, E, C, XYZ, ML)
%getFixedEndForceMatrix 
%   This function constructs the fixed end force matrix
%   E = (Tx_dof, Ty_dof, Tz_dof, Rx_dof, Ry_dof, Rz_dof, W_dof) for nodes
%   ML = (member, Uniform Load in local-y, Uniform Torsion in local-x) for loaded members

Ff = zeros(NumEq,1);
NumLoadMember = size(ML,1);

for i = 1:NumLoadMember
    el = ML(i,1); % element ID
    w = ML(i,2); % uniform load in local-y
    t = ML(i,3); % uniform torsion in local-x
    
    startNode = C(el,1); %start node ID number
    endNode = C(el,2); %end node ID number
    
    % numDofs: number of dofs at each node of the element
    if (C(el,4) == 1)||(C(el,4) == 2) % Beam and Beam with Jeff
        numDofs = 6;
        ff_local = zeros(12,1);
    elseif C(el,4) == 3 % Warping Beam
        numDofs = 7;
        ff_local = zeros(14,1);
    elseif C(el,4) == 4 % Truss
        numDofs = 3;
        ff_local = zeros(6,1);
    end
    
    if C(el,4) ~= 4 % Other than Truss elements
        %get rotation matrix and element length
        [R,Le] = getRotationMatrix(el,C,XYZ);
        
        %form fixed-end force vector in member local coordinates
        ff_local(4,1)           = t*Le/2;
        ff_local(numDofs+4,1)   = t*Le/2;
    
        ff_local(3,1)           = w*Le/2;
        ff_local(5,1)           = -w*Le^2/12;
        ff_local(numDofs+3,1)   = w*Le/2;
        ff_local(numDofs+5,1)   = w*Le^2/12;
        
        %transform to global coordinates
        ff_global = transpose(R) * ff_local;
        
        for j = 1:numDofs
            dof1 = E(startNode,j); %for each dof at start node
            if dof1 ~= 0 %for active dofs
                Ff(dof1,1) = Ff(dof1,1) + ff_global(j,1);
            end
            dof2 = E(endNode,j);
            if dof2 ~= 0 %for active dofs
                Ff(dof2,1) = Ff(dof2,1) + ff_global(j+numDofs,1);
            end
        end
    end    
end

end

