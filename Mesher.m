function [InmputFileName]=Mesher(Lc,Q)



[a, b, F, E, v] = ProblemParameters();

%Determines G from E and v
G=E/(2*(1+v));

%Defines a ratio of the elements based on the geometry
er=round((pi*(a+b)/4)/(b-a));

%Number of elements in r and theta direction
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



%Generate mesh conectivity info

con1=zeros(L,1);
con2=zeros(L,1);
con3=zeros(L,1);
con4=zeros(L,1);
con5=zeros(L,1);
con6=zeros(L,1);
con7=zeros(L,1);
con8=zeros(L,1);
con9=zeros(L,1);


%If the element is cuadratic, inicialize some variables
Nm=0;
if Q==8
    Nm=Lr*Ntheta+Ltheta*Nr;
    midPointMap=containers.Map;
    l=N+1;
end



k=1;
for i = 1 : Lr
    for j = 1 : Ltheta
        
        con1(k)=k;
        con2(k)=Ntheta*(i-1)+j;
        con3(k)=Ntheta*(i-1)+j+1;
        con4(k)=Ntheta*(i)+j+1;
        con5(k)=Ntheta*(i)+j;
        
        %If Q=8 add midpoints nodes
        if Q==8
            
            key1=append(string(con3(k)),"-",string(con2(k)));
            key2=append(string(con4(k)),"-",string(con3(k)));
            key3=append(string(con5(k)),"-",string(con4(k)));
            key4=append(string(con2(k)),"-",string(con5(k)));
            
            %Check if the midpoint was previously added, otherwhise, create
            %a new entry in the mapping
            
            %new node in face 1
            if isKey(midPointMap,key1)
                %uses the previously created node and create the
                %conectitivity info
                con6(k)=midPointMap(key1);
            else
                
                %create the entry key
                newkey=append(string(con2(k)),"-",string(con3(k)));
                
                %calculate the midpoint in polar
                R(l)=(R(con2(k))+R(con3(k)))/2;
                THETA(l)=(THETA(con2(k))+THETA(con3(k)))/2;
                %transoform into rectangular
                X(l)=R(l).*cos(THETA(l));
                Y(l)=R(l).*sin(THETA(l));
                
                %Store in the container
                midPointMap(newkey)=l;
                
                %create the conectivity info
                con6(k)=midPointMap(newkey);
                l=l+1;
            end
            
            %new node in face 2
            if isKey(midPointMap,key2)
                %uses the previously created node and create the
                %conectitivity info
                con7(k)=midPointMap(key2);
            else
                %create the entry key
                newkey=append(string(con3(k)),"-",string(con4(k)));
                
                %calculate the midpoint in polar
                R(l)=(R(con3(k))+R(con4(k)))/2;
                THETA(l)=(THETA(con3(k))+THETA(con4(k)))/2;
                %transoform into rectangular
                X(l)=R(l).*cos(THETA(l));
                Y(l)=R(l).*sin(THETA(l));
                
                %Store in the container
                midPointMap(newkey)=l;
                
                %create the conectivity info
                con7(k)=midPointMap(newkey);
                l=l+1;
            end
            
            %new node in face 3
            if isKey(midPointMap,key3)
                %uses the previously created node and create the
                %conectitivity info
                con8(k)=midPointMap(key3);
            else
                %create the entry key
                newkey=append(string(con4(k)),"-",string(con5(k)));
                
                %calculate the midpoint in polar
                R(l)=(R(con4(k))+R(con5(k)))/2;
                THETA(l)=(THETA(con4(k))+THETA(con5(k)))/2;
                %transoform into rectangular
                X(l)=R(l).*cos(THETA(l));
                Y(l)=R(l).*sin(THETA(l));
                
                %Store in the container
                midPointMap(newkey)=l;
                
                %create the conectivity info
                con8(k)=midPointMap(newkey);
                l=l+1;
            end
            
            %new node in face 4
            if isKey(midPointMap,key4)
                %uses the previously created node and create the
                %conectitivity info
                con9(k)=midPointMap(key4);
            else
                %create the entry key
                newkey=append(string(con5(k)),"-",string(con2(k)));
                
                %calculate the midpoint in polar
                R(l)=(R(con5(k))+R(con2(k)))/2;
                THETA(l)=(THETA(con5(k))+THETA(con2(k)))/2;
                %transoform into rectangular
                X(l)=R(l).*cos(THETA(l));
                Y(l)=R(l).*sin(THETA(l));
                
                %Store in the container
                midPointMap(newkey)=l;
                
                %create the conectivity info
                con9(k)=midPointMap(newkey);
                l=l+1;
            end
        end
      
        k=k+1;
    end
end


COORDS=[X,Y];

%Plot the nodes
scatter(X,Y)


InmputFileName=sprintf('CurvedCantilever_Lc=%d_Q=%d.txt',Lc, Q)
fileID = fopen(InmputFileName,'w');
fprintf(fileID,'No._material_props:    3\n');
fprintf(fileID,'    Shear_modulus:   %0.2f\n', G);
fprintf(fileID,'    Poissons_ratio:  %0.2f\n', v);
fprintf(fileID,'    Plane_strain/stress: 0\n'); %zero for plane stress
fprintf(fileID,'No._coords_per_node:   2\n');
fprintf(fileID,'No._DOF_per_node:      2\n');
fprintf(fileID,'No._nodes:             %d\n', N+Nm);
fprintf(fileID,'Nodal_coords:\n');

[m,n] = size(COORDS);
for i= 1 : m
    fprintf(fileID,'%0.4f\t%0.4f\n',COORDS(i,1),COORDS(i,2));
end
fprintf(fileID,'No._elements:                       %d\n', L);
fprintf(fileID,'Max_no._nodes_on_any_one_element:   %d\n', Q);
fprintf(fileID,'element_identifier; no._nodes_on_element; connectivity:\n');

%conectivity depends on Q
if Q==8
    for i= 1 : L
        fprintf(fileID,'%d\t8\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n',con1(i),con2(i),con3(i),con4(i),con5(i),con6(i),con7(i),con8(i),con9(i));
    end
else
    for i= 1 : L
        fprintf(fileID,'%d\t4\t%d\t%d\t%d\t%d\n',con1(i),con2(i),con3(i),con4(i),con5(i));
    end
end



fprintf(fileID,'No._nodes_with_prescribed_DOFs:  %d\n', 2*(Nr+Lr));
fprintf(fileID,'Node_#, DOF#, Value:\n');


%locate the target nodes (all of them has a 0 x coorinate)
for i=1 : N+Nm
    if COORDS(i,1)==0
        fprintf(fileID,'%d\t3\t0.0\n',Ntheta*(i-1)+1);
        fprintf(fileID,'%d\t4\t0.0\n',Ntheta*(i-1)+1);
    end
end
fprintf(fileID,'No._elements_with_prescribed_loads: %d\n', Lr);
fprintf(fileID,'Element_#, Face_#, Traction_components\n');
for i= 1 : Lr
    fprintf(fileID,'%d\t2\t%0.4f\t%0.4f\n',i*Ltheta,-F,0);
end

fclose(fileID);

end




