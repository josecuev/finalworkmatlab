clc;
clear;
[a, b, F, E, v] = ProblemParameters();

%Defines a ratio of the elements based on the geometry
er=round((pi*(a+b)/4)/(b-a));

%Number of elements in r and theta direction.
Lr=3;
Ltheta=round(Lr*er);
L=Lr*Ltheta;

%Number of nodes in r and theta direction.
Nr=Lr+1;
Ntheta=Ltheta+1;
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
fprintf(fileID,'No._coords_per_node:   2\n');
fprintf(fileID,'No._nodes:             %d\n', L);
fprintf(fileID,'Nodal_coords:\n');
    for i= 1 : N
        fprintf(fileID,'    %0.4f   %0.4f\n',COORDS(i,1),COORDS(i,2));
    end

fclose(fileID);




