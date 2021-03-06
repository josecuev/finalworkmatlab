function[stress, strain ]=analytic(Xr)



%Transformation matrix between cartesian and polar coordinates
theta=atan(Xr(2)/Xr(1));
Cpr=[cos(theta), -sin(theta); sin(theta), cos(theta) ];

%Transorm into polar coordinates

r=sqrt(Xr(1)^2+Xr(2)^2);
theta=atan(Xr(2)/Xr(1));


%Reading problem parameters
[a, b, F, E, v] = ProblemParameters();

%Analitic solution in polar coordinates

%Stress distribution
N1=(a^2-b^2)+(a^2+b^2)*log(b/a);%ok

A=F/(2*N1);%ok
B=-(F*a^2*b^2)/(2*N1);%ok
C=-(F*(a^2+b^2))/N1;%ok
D=0;%ok

sigmar=(2*A*r-2*B*r^-3+C*r^-1-2*D*r^-1)*sin(theta);%ok
sigmartheta=(-2*A*r+2*B*r^-3-C*r^-1)*cos(theta);%ok
sigmatheta=(6*A*r+2*B*r^-3+C*r^-1)*sin(theta); %ok

sigmapolar=[sigmar, sigmartheta; sigmartheta, sigmatheta];

%Strain distribution
ConstPolarVoig=(1/E)*[1, -v, 0; -v, 1, 0;0, 0,2*(1+v)];
SigmaPolarVoig=[sigmar; sigmatheta; sigmartheta];
StrainPolarVoig=ConstPolarVoig*SigmaPolarVoig;


StrainPolar=[StrainPolarVoig(1), StrainPolarVoig(3); StrainPolarVoig(3), StrainPolarVoig(2)];

%Transformation in cartesian coordinates
stress=Cpr*sigmapolar*transpose(Cpr);
strain=Cpr*StrainPolar*transpose(Cpr);

end