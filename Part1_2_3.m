clear
clc


inputfilename=Mesher(3,8);

%Solve the meshed problem for linear interpolation functions:
FEM_2Dor3D_linelast_standard(inputfilename);

%Solve the meshed problem for cuadratic interpolation functions:
%FEM_2Dor3D_linelast_standard(inputfilename);




 
 