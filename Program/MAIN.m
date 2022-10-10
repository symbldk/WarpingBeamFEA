clc
clear
format short

% 3D FRAME ANALYSIS PROGRAM

% Take Inputs from the Inputs.xlsx file

[XYZ, M, C, S, NL, ML] = takeInputs();

NumNode = size(XYZ,1);
NumElem = size(C,1);
NumSupport = size(S,1);
NumLoadJoint = size(NL,1);

% Label Active D.O.F
[E, NumEq] = labelActiveDofs(NumNode,NumSupport,S);

% Global Stiffness Matrix [K]
K = zeros(NumEq,NumEq);
for el = 1:NumElem
    %form rotation matrix of the element
    [R,Le] = getRotationMatrix(el,C,XYZ);
    
    %form element stiffness matrix in element's local coordinates
    [k_local] = getElementStiffnessMatrix(el,C,M,Le);
    
    %obtain element stiffness matrix in global coordinates
    k_global = transpose(R) * k_local * R;
    
    %assemble element stiffness in global coordinates, k_global 
    %into structural stiffness
    [K] = assembleElementMatrix(k_global, K, el, C, E);
end

% Global Load Vector [F]
%construct nodal load vector
[Fn] = constructLoadVector(NumEq, NumLoadJoint, E, NL);
%get fixed end forces
[Ff] = getFixedEndForceMatrix(NumEq, E, C, XYZ, ML);

F = Fn + Ff;

% Structural Displacements {D}
%D = linsolve(K,F);
D = K\F;
[JD] = getJointDisplacementMatrix(NumNode,E,D);
% Member End Forces
memberEndForcesLocal = cell(1,NumElem);
memberEndDispLocal = cell(1,NumElem);
memberEndForcesGlobal = cell(1,NumElem);

ML_structure = zeros(NumElem,2);
NumLoadMember = size(ML,1);
for i = 1:NumLoadMember
    ML_structure(ML(i,1),1) = ML(i,2);
    ML_structure(ML(i,1),2) = ML(i,3);
end

Reactions = zeros(NumNode,8);
for el = 1:NumElem
    %form rotation matrix of the element
    [R,Le] = getRotationMatrix(el,C,XYZ);
    
    %form element stiffness matrix in element's local coordinates
    [k_local] = getElementStiffnessMatrix(el,C,M,Le);
    
    %obtain element stiffness matrix in global coordinates
    k_global = transpose(R) * k_local * R;
    
    %form the vector of element end displacements in global coordinates
    [d_global] = getElementEndDisplacements(el, C, E, D);
    
    %obtain the vector of element end displacements in local coordinates
    [d_local] = R * d_global;
    
    %calculate element end forces in local coordinates
    [ff] = memberFixedEndForces(el, Le, ML_structure, C);
    f_local = k_local * d_local + ff;
    
    %calculate element end forces in global coordinates
    f_global = transpose(R) * f_local;
    
    %store results in the cell array
    if (C(el,4) == 1)||(C(el,4) == 2) % Beam and Beam with Jeff
        d_local = [d_local(1:6);0;d_local(7:12);0];
        f_local = [f_local(1:6);0;f_local(7:12);0];
        f_global = [f_global(1:6);0;f_global(7:12);0];
    elseif C(el,4) == 4 % Truss
        d_local = [d_local(1:3);zeros(4,1);d_local(4:6);zeros(4,1)];
        f_local = [f_local(1:3);zeros(4,1);f_local(4:6);zeros(4,1)];
        f_global = [f_global(1:3);zeros(4,1);f_global(4:6);zeros(4,1)];
    end
    memberEndDispLocal{1,el} = d_local;
    memberEndForcesLocal{1,el} = f_local; 
    memberEndForcesGlobal{1,el} = f_global;
    
    %store member global forces going to supports.
    [Reactions] = memberForcesToSupports(el, f_global, Reactions, E, C);
    
end

% Create a member end forces table

MemberLocal = transpose(cell2mat( memberEndForcesLocal ));
MemberGlobal = transpose(cell2mat( memberEndForcesGlobal ));

% Create a member end local displacements table
MemberLocalD = transpose(cell2mat( memberEndDispLocal ));

% Support Reactions
SR = zeros(NumSupport,8);
for i = 1:NumSupport
    SR(i,:) = Reactions(S(i,1),:);
end

% Update 'Outputs.xlsx' file
[num,txt,raw] = xlsread('Inputs.xlsx','Guide','B4');
outputFileName = [char(txt),'.xlsx'];
copyfile('OutputsTemplate.xlsx',outputFileName);
xlswrite(outputFileName,K,1,'A2');
xlswrite(outputFileName,F,2,'B2');
xlswrite(outputFileName,JD,3,'A2');
xlswrite(outputFileName,MemberLocalD,4,'A3');
xlswrite(outputFileName,MemberLocal,5,'A3');
xlswrite(outputFileName,MemberGlobal,6,'A3');
xlswrite(outputFileName,SR,7,'A2');

% End of Program

msgbox('All done.');
