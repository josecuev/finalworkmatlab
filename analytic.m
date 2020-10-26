function[sigma]=analytic(Xr)



%Transformation matrix between cartesian and polar coordinates
theta=atan(Xr(2)/Xr(1));
Cpr=[cos(theta), -sin(theta); sin(theta), cos(theta) ];

%Transorm into polar coordinates

r=sqrt(Xr(1)^2+Xr(2)^2);
theta=atan(Xr(2)/Xr(1));

%Analitic solution in polar coordinates

%problem data definition
a=0.2;
b=0.4;
F=1;
N1=(a^2-b^2)+(a^2+b^2)*log(b/a);%ok
% 

A=F/(2*N1);%ok
B=-(F*a^2*b^2)/(2*N1);%ok
C=-(F*(a^2+b^2))/N1;%ok
D=0;%ok

sigmar=(2*A*r-2*B*r^-3+C*r^-1-2*D*r^-1)*sin(theta);%ok
sigmartheta=(-2*A*r+2*B*r^-3-C*r^-1)*cos(theta);%ok
sigmatheta=(6*A*r+2*B*r^-3+C*r^-1)*sin(theta); %ok

sigmapolar=[sigmar, sigmartheta; sigmartheta, sigmatheta];

%Transformation in cartesian coordinates
sigma=Cpr*sigmapolar*transpose(Cpr);


end