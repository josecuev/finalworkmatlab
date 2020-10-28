function [InmputFileName]=Mesher(Lc)

[a, b, F, E, v] = ProblemParameters();

%Determines G from E and v
G=E/(2*(1+v));

%Defines a ratio of the elements based on the geometry
er=round((pi*(a+b)/4)/(b-a));

%Number of elements in r and theta direction.
Lr=Lc;
Ltheta=round(Lr*er);
L=Lr*Ltheta;

%Number of nodes in r and theta direction.
Nr=Lr+1;
Ntheta=Ltheta+1;
N=Nr*Ntheta;

%Grid of polar coordinates
r = linspace(a,b,Nr);
theta = linspace(pi/2,0,Ntheta);
[R, THETA]=meshgrid(r,theta);

R=reshape(R,[],1); % convert matrix to column vector
THETA=reshape(THETA,[],1); % convert matrix to column vector

%Transform into rectangular coordinates
X=R.*cos(THETA);
Y=R.*sin(THETA);

COORDS=[X,Y];

%Plot the nodes
%scatter(X,Y)


%Generate mesh conectivity info

con1=zeros(L,1);
con2=zeros(L,1);
con3=zeros(L,1);
con4=zeros(L,1);
con5=zeros(L,1);

k=1;
for i = 1 : Lr
    for j = 1 : Ltheta
        con1(k)=k;
        con2(k)=Ntheta*(i-1)+j;
        con3(k)=Ntheta*(i-1)+j+1;
        con4(k)=Ntheta*(i)+j+1;
        con5(k)=Ntheta*(i)+j;
        k=k+1;
    end
end

InmputFileName=sprintf('CurvedCantilever_Lc=%d.txt',Lc)
fileID = fopen(InmputFileName,'w');
fprintf(fileID,'No._material_props:    3\n');
fprintf(fileID,'    Shear_modulus:   %0.2f\n', G);
fprintf(fileID,'    Poissons_ratio:  %0.2f\n', v);
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
fprintf(fileID,'No._nodes_with_prescribed_DOFs:  %d\n', 2*Nr);
fprintf(fileID,'Node_#, DOF#, Value:\n');
for i=1 : Nr
    fprintf(fileID,'%d\t3\t0.0\n',Ntheta*(i-1)+1);
    fprintf(fileID,'%d\t4\t0.0\n',Ntheta*(i-1)+1);
end
fprintf(fileID,'No._elements_with_prescribed_loads: %d\n', Lr);
fprintf(fileID,'Element_#, Face_#, Traction_components\n');
for i= 1 : Lr
    fprintf(fileID,'%d\t2\t%0.4f\t%0.4f\n',i*Ltheta,-F,0);
end

fclose(fileID);

end




