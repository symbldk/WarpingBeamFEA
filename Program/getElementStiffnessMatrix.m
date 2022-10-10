function [K] = getElementStiffnessMatrix(el,C,M,L)
%getElementStiffnessMatrix
%   It calculates the stiffness matrix of the corresponding
%   element in the for loop (which is el) in element's local coordinates
%   Conventional Beam element and Beam with Jeff have 6 DOFs at each node
%   Warping Beam elements have 7 DOFs at each node
%   it includes warping DOF formulated using polynomial Hermitian shape functions
%   Truss elements have 3 DOFs at each node
%   Flexural shear deformations are considered for beam elements
%   C =(startNode, endNode, property ID, Type, Warping, Lb) for elements
%   M = (E,G,A,Iz,Iy,J,Cw) for properties


%L: element length
E = M(C(el,3),1); %ksi
A = M(C(el,3),3); %in2
G = M(C(el,3),2); %ksi
    
Iz = M(C(el,3),4); %in4
Iy = M(C(el,3),5); %in4
J = M(C(el,3),8); %in4
Cw = M(C(el,3),9); %in6

As_y = M(C(el,3),6); %in2 shear area in y
As_z = M(C(el,3),7); % in2 shear area in z

py = 12*E*Iz/(G*As_y*L^2); %shear deformation-parasitic shear
pz = 12*E*Iy/(G*As_z*L^2); %shear deformation-parasitic shear

if C(el,4) == 1 % Conventional Beam
    K = E/L^3 .* [A*L^2     0                   0           0           0                   0               -A*L^2    0                 0           0           0                   0
                       0      12*Iz/(1+py)          0           0           0               6*L*Iz/(1+py)           0   -12*Iz/(1+py)       0           0           0           6*L*Iz/(1+py)
                       0        0               12*Iy/(1+pz)    0      -6*L*Iy/(1+pz)           0                   0      0        -12*Iy/(1+pz)       0      -6*L*Iy/(1+pz)           0
                       0        0                   0       G*J*L^2/E       0                   0                   0      0                0      -G*J*L^2/E       0                   0
                       0        0           -6*L*Iy/(1+pz)      0       (4+pz)*L^2*Iy/(1+pz)    0                   0      0        6*L*Iy/(1+pz)       0      (2-pz)*L^2*Iy/(1+pz)     0
                       0      6*L*Iz/(1+py)         0           0           0               (4+py)*L^2*Iz/(1+py)    0   -6*L*Iz/(1+py)      0           0           0           (2-py)*L^2*Iz/(1+py)
                      -A*L^2    0                   0           0           0                   0                A*L^2    0                 0           0           0                   0
                       0      -12*Iz/(1+py)         0           0           0               -6*L*Iz/(1+py)          0    12*Iz/(1+py)       0           0           0           -6*L*Iz/(1+py)
                       0        0           -12*Iy/(1+pz)       0        6*L*Iy/(1+pz)          0                   0      0        12*Iy/(1+pz)        0       6*L*Iy/(1+pz)           0
                       0        0                   0       -G*J*L^2/E      0                   0                   0      0                0       G*J*L^2/E       0                   0
                       0        0           -6*L*Iy/(1+pz)      0        (2-pz)*L^2*Iy/(1+pz)   0                   0      0        6*L*Iy/(1+pz)       0       (4+pz)*L^2*Iy/(1+pz)    0
                       0      6*L*Iz/(1+py)         0           0           0               (2-py)*L^2*Iz/(1+py)    0    -6*L*Iz/(1+py)     0           0           0           (4+py)*L^2*Iz/(1+py)];
elseif C(el,4) == 2 % Beam with Jeff
    p = sqrt(G*J/(E*Cw));

    Lb = C(el,6);
    if C(el,5) == 1 % warping fixed-free
        a3 = sinh(p*Lb)/(p*Lb*cosh(p*Lb));
        Jeff = J*(1/(1-a3));
    elseif C(el,5) == 2 % warping fixed-fixed
        a1 = sinh(p*Lb)/(p*Lb);
        a2 = (cosh(p*Lb)-1)^2/(p*Lb*sinh(p*Lb));
        Jeff = J*(1/(1-a1+a2));
    end
    
    K = E/L^3 .* [A*L^2     0                   0           0           0                   0               -A*L^2    0                 0           0           0                   0
                   0      12*Iz/(1+py)          0           0           0               6*L*Iz/(1+py)           0   -12*Iz/(1+py)       0           0           0           6*L*Iz/(1+py)
                   0        0               12*Iy/(1+pz)    0      -6*L*Iy/(1+pz)           0                   0      0        -12*Iy/(1+pz)       0      -6*L*Iy/(1+pz)           0
                   0        0                   0       G*Jeff*L^2/E       0                   0                   0      0                0      -G*Jeff*L^2/E       0                   0
                   0        0           -6*L*Iy/(1+pz)      0       (4+pz)*L^2*Iy/(1+pz)    0                   0      0        6*L*Iy/(1+pz)       0      (2-pz)*L^2*Iy/(1+pz)     0
                   0      6*L*Iz/(1+py)         0           0           0               (4+py)*L^2*Iz/(1+py)    0   -6*L*Iz/(1+py)      0           0           0           (2-py)*L^2*Iz/(1+py)
                  -A*L^2    0                   0           0           0                   0                A*L^2    0                 0           0           0                   0
                   0      -12*Iz/(1+py)         0           0           0               -6*L*Iz/(1+py)          0    12*Iz/(1+py)       0           0           0           -6*L*Iz/(1+py)
                   0        0           -12*Iy/(1+pz)       0        6*L*Iy/(1+pz)          0                   0      0        12*Iy/(1+pz)        0       6*L*Iy/(1+pz)           0
                   0        0                   0       -G*Jeff*L^2/E      0                   0                   0      0                0       G*Jeff*L^2/E       0                   0
                   0        0           -6*L*Iy/(1+pz)      0        (2-pz)*L^2*Iy/(1+pz)   0                   0      0        6*L*Iy/(1+pz)       0       (4+pz)*L^2*Iy/(1+pz)    0
                   0      6*L*Iz/(1+py)         0           0           0               (2-py)*L^2*Iz/(1+py)    0    -6*L*Iz/(1+py)     0           0           0           (4+py)*L^2*Iz/(1+py)];
elseif C(el,4) == 3 % Warping Beam
    j = 12*G*J*L^2/(10*E)+12*Cw;
    k = G*J*L^3/(10*E)+6*Cw*L;
    l = 4*G*J*L^4/(30*E)+4*Cw*L^2;
    m = -G*J*L^4/(30*E)+2*Cw*L^2;
    
    K = E/L^3 .* [A*L^2     0        0           0         0                    0               0   -A*L^2        0         0             0        0                  0             0
                   0  12*Iz/(1+py)   0           0         0            6*L*Iz/(1+py)           0      0    -12*Iz/(1+py)   0             0        0            6*L*Iz/(1+py)       0
                   0        0   12*Iy/(1+pz)     0   -6*L*Iy/(1+pz)             0               0      0          0  -12*Iy/(1+pz)        0   -6*L*Iy/(1+pz)           0            0
                   0        0        0           j         0                    0               k      0          0         0            -j        0                   0            k
                   0        0   -6*L*Iy/(1+pz)   0   (4+pz)*L^2*Iy/(1+pz)       0               0      0          0   6*L*Iy/(1+pz)       0   (2-pz)*L^2*Iy/(1+pz)     0            0
                   0  6*L*Iz/(1+py)  0           0         0           (4+py)*L^2*Iz/(1+py)     0      0   -6*L*Iz/(1+py)   0             0        0      (2-py)*L^2*Iz/(1+py)      0
                   0        0        0           k         0                    0               l      0          0         0            -k        0                   0            m
                  -A*L^2    0        0           0         0                    0               0    A*L^2        0         0             0        0                   0            0
                   0  -12*Iz/(1+py)  0           0         0            -6*L*Iz/(1+py)          0      0    12*Iz/(1+py)    0             0        0          -6*L*Iz/(1+py)        0
                   0        0   -12*Iy/(1+pz)    0    6*L*Iy/(1+pz)             0               0      0          0    12*Iy/(1+pz)       0   6*L*Iy/(1+pz)            0            0
                   0        0        0          -j         0                    0               -k     0          0         0             j        0                   0           -k
                   0        0   -6*L*Iy/(1+pz)   0    (2-pz)*L^2*Iy/(1+pz)      0               0      0          0    6*L*Iy/(1+pz)      0   (4+pz)*L^2*Iy/(1+pz)     0            0
                   0  6*L*Iz/(1+py)  0           0         0           (2-py)*L^2*Iz/(1+py)     0      0   -6*L*Iz/(1+py)   0             0        0         (4+py)*L^2*Iz/(1+py)   0
                   0        0        0           k         0                    0               m      0          0         0            -k        0                   0            l]; 
elseif C(el,4)== 4 %Truss
    K = E/L^3 .* [A*L^2     0        0      -A*L^2     0    0
                   0        0        0        0        0    0
                   0        0        0        0        0    0
                  -A*L^2    0        0       A*L^2     0	0
                   0        0        0        0        0    0
                   0        0        0        0        0    0];
end
end

