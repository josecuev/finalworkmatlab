clear
clc

%Mesh the problem
inputfilename=Mesher(3);

%Solve the meshed problem for linear interpolation functions:
FEM_2Dor3D_linelast_standard(inputfilename);

%Solve the meshed problem for cuadratic interpolation functions:
FEM_2Dor3D_linelast_standard(inputfilename);




 
 