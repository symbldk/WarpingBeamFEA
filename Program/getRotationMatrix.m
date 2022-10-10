function [R,Le] = getRotationMatrix(el,C,XYZ)
%getRotationMatrix
%   It calculates the rotation matrix of the corresponding
%   element in the for loop (which is el)
%   C =(startNode, endNode, property ID, Type, Warping, Lb) for elements
%   XYZ = (X coor,Y coor, Z coor) for nodes

startNode = C(el,1);
endNode = C(el,2);

startNodeX = XYZ(startNode,1);
endNodeX = XYZ(endNode,1);

startNodeY = XYZ(startNode,2);
endNodeY = XYZ(endNode,2);

startNodeZ = XYZ(startNode,3);
endNodeZ = XYZ(endNode,3);

%element length
Le = sqrt((endNodeX-startNodeX)^2 + (endNodeY-startNodeY)^2 + (endNodeZ-startNodeZ)^2);

%direction cosines
lx = (endNodeX - startNodeX) / Le;
mx = (endNodeY - startNodeY) / Le;
nx = (endNodeZ - startNodeZ) / Le;

Lxy = sqrt(lx^2+mx^2);

tolerance = sqrt(lx^2+mx^2)/sqrt(lx^2+mx^2+nx^2);
if tolerance < 0.001
    r = [0 0 nx;0 1 0;-nx 0 0];
else
    ly = -mx/Lxy;
    my = lx/Lxy;
    ny = 0;

    lz = -lx*nx/Lxy;
    mz = -mx*nx/Lxy;
    nz = Lxy;
    r = [lx mx nx;ly my ny;lz mz nz];
end

if (C(el,4) == 1)||(C(el,4) == 2) % Beam and Beam with Jeff
    R = blkdiag(r,r,r,r);
elseif C(el,4) == 3 % Warping Beam
    R = blkdiag(r,r,1,r,r,1);
elseif C(el,4) == 4 % Truss
    R = blkdiag(r,r);
end

end