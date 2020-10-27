[a, b, F, E, v] = ProblemParameters();

%Defines a ratio of the elements based on the geometry
er=round((pi*(a+b)/4)/(b-a));

%Number of elements in r and theta direction.
Lr=3;
Ltheta=round(Nr*er);

%Number of nodes in r and theta direction.
Nr=Lr+1;
Ntheta=Ltheta+1;

%Grid of polar coordinates
r = linspace(a,b,Nr);
theta = linspace(0,pi/2,Ntheta);
[R,THETA]=meshgrid(r,theta);

%Transform into rectangular coordinates
X=R.*cos(THETA);
Y=R.*sin(THETA);

%Create a list of vectors of Nodes coordinates
X=X(:);
Y=Y(:);

%Plot the nodes
scatter(X,Y)

%Generate mesh conectivity info



