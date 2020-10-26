N=100;
r = linspace(0.2,0.4,N);
theta = linspace(0,pi/2,N);
[R,THETA]=meshgrid(r,theta);

X=R.*cos(THETA);
Y=R.*sin(THETA);


sigmar=zeros(N,N);
sigmatheta=zeros(N,N);
sigmartheta=zeros(N,N);



for i = 1 : N
    for j = 1 : N
            [sigma]=analytic([X(i,j);Y(i,j)]);
            sigmar(i,j)=sigma(1,1);
            sigmatheta(i,j)=sigma(2,2);
            sigmartheta(i,j)=sigma(1,2);
    end
end

figure(1)
contourf(X,Y,sigmar)
figure(2)
contourf(X,Y,sigmatheta)
figure(3)
contourf(X,Y,sigmartheta)



