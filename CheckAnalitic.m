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
            [sigmart, sigmathetat, sigmarthetat]=analytic(R(i,j),THETA(i,j));
            sigmar(i,j)=sigmart;
            sigmatheta(i,j)=sigmathetat;
            sigmartheta(i,j)=sigmarthetat;

    end
end

figure(1)
contourf(X,Y,sigmar)
figure(2)
contourf(X,Y,sigmatheta)
figure(3)
contourf(X,Y,sigmartheta)



