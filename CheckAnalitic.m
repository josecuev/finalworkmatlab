N=100;

[a, b, F, E, v] = ProblemParameters();

r = linspace(a,b,N);
theta = linspace(0,pi/2,N);
[R,THETA]=meshgrid(r,theta);

X=R.*cos(THETA);
Y=R.*sin(THETA);


sigmax=zeros(N,N);
sigmay=zeros(N,N);
sigmaxy=zeros(N,N);

strainx=zeros(N,N);
strainy=zeros(N,N);
strainxy=zeros(N,N);



for i = 1 : N
    for j = 1 : N
            [stress, strain]=analytic([X(i,j);Y(i,j)]);
            sigmax(i,j)=stress(1,1);
            sigmay(i,j)=stress(2,2);
            sigmaxy(i,j)=stress(1,2);
            
            strainx(i,j)=strain(1,1);
            strainy(i,j)=strain(2,2);
            strainxy(i,j)=strain(1,2);
    end
end

figure('Name','Stress X');
contourf(X,Y,sigmax)
figure('Name','Stress Y');
contourf(X,Y,sigmay)
figure('Name','Stress XY');
contourf(X,Y,sigmaxy)

figure('Name','Strain X');
contourf(X,Y,strainx)
figure('Name','Strain Y');
contourf(X,Y,strainy)
figure('Name','Strain XY');
contourf(X,Y,strainxy)



