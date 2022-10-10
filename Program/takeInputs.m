function [XYZ, M, C, S, NL, ML] = takeInputs()
%takeInputs 
%   Reads data from "Inputs.xlsx" file

% XYZ stores nodal point coordinates in global coordinate system (X,Y,Z)
XYZ = xlsread('Inputs.xlsx','Nodes','B2:D1000');

% M stores material properties (E,G,A,Iz,Iy,As_y, As_z,J,Cw)
M = xlsread('Inputs.xlsx','Properties','B2:J1000');

% C stores connectivity and special properties of elements (startNode, endNode, property ID, Type, Warping, Lb)
C = xlsread('Inputs.xlsx','Elements','J2:O1000');

% S stores restraints data (node, Tx, Ty, Tz, Rx, Ry, Rz, W)
S = xlsread('Inputs.xlsx','Restraints','L2:S1000');

% NL stores applied nodal loads (node, Fx, Fy, Fz, Mx, My, Mz, B)
NL = xlsread('Inputs.xlsx','NodalLoads','B2:I1000');

% ML stores applied member loads (member, Fz, Mx)
ML = xlsread('Inputs.xlsx','MemberLoads','B2:D1000');

end

