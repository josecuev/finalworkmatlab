clc;
clear;
[a, b, F, E, v] = ProblemParameters();

%Defines a ratio of the elements based on the geometry
er=round((pi*(a+b)/4)/(b-a));

%Number of elements in r and theta direction.
Lr=4;
Ltheta=round(Lr*er);
Ltheta=7;
L=Lr*Ltheta;

%Number of nodes in r and theta direction.
Nr=Lr+1;
Ntheta=Ltheta+1;
N=Nr*Ntheta;

%Grid of polar coordinates
r = linspace(a,b,Nr);
theta = linspace(0,pi/2,Ntheta);
[THETA, R]=meshgrid(theta,r);

R=reshape(R,[],1); % convert matrix to column vector
THETA=reshape(THETA,[],1); % convert matrix to column vector

%Transform into rectangular coordinates
X=R.*cos(THETA);
Y=R.*sin(THETA);

COORDS=[X,Y];

%Plot the nodes
scatter(X,Y)


%Generate mesh conectivity info

con1=zeros(L,1);
con2=zeros(L,1);
con3=zeros(L,1);
con4=zeros(L,1);
con5=zeros(L,1);

k=1;
for i = 1 : Ltheta
    for j = 1 : Lr
        con1(k)=k;
        con2(k)=Nr*(i-1)+j;
        con3(k)=Nr*(i-1)+j+1;
        con4(k)=Nr*(i)+j+1;
        con5(k)=Nr*(i)+j;
        k=k+1;
    end
end

fileID = fopen('ProblemFormulation.txt','w');
fprintf(fileID,'No._material_props:    3\n');
fprintf(fileID,'    Shear_modulus:   10.\n');
fprintf(fileID,'    Poissons_ratio:  0.3\n');
fprintf(fileID,'    Plane_strain/stress: 1\n');
fprintf(fileID,'No._coords_per_node:   2\n');
fprintf(fileID,'No._DOF_per_node:      2\n');
fprintf(fileID,'No._nodes:             %d\n', N);
fprintf(fileID,'Nodal_coords:\n');
for i= 1 : N
    fprintf(fileID,'%0.4f\t%0.4f\n',COORDS(i,1),COORDS(i,2));
end
fprintf(fileID,'No._elements:                       %d\n', L);
fprintf(fileID,'Max_no._nodes_on_any_one_element:   4\n');
fprintf(fileID,'element_identifier; no._nodes_on_element; connectivity:\n');
for i= 1 : L
    fprintf(fileID,'%d\t4\t%d\t%d\t%d\t%d\n',con1(i),con2(i),con3(i),con4(i),con5(i));
end
fprintf(fileID,'No._nodes_with_prescribed_DOFs:  %d\n', Lr);
fprintf(fileID,'Node_#, DOF#, Value:\n');
for i= Lr*(Ltheta-1)+1 : L
    fprintf(fileID,'%d\t1\t0.0\n',i);
    fprintf(fileID,'%d\t2\t0.0\n',i);
end
fprintf(fileID,'No._elements_with_prescribed_loads: %d\n', Lr);
fprintf(fileID,'Element_#, Face_#, Traction_components\n');
for i= 1 : Lr
    fprintf(fileID,'%d\t1\t%0.4f\t%0.4f\n',i,-F,0);
end

fclose(fileID);




