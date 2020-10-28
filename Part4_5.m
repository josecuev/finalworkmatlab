clear
clc

%Error study by size of element:
Lci=1;
Lcf=7;

 for i = Lci:Lcf
      inputfilename=Mesher(i);
      FEM_2Dor3D_linelast_standard(inputfilename);
 end
 
 Nii=3
 Nif=10