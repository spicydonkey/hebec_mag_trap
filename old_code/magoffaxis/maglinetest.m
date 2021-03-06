clear all
close all

Mu0 = 4*pi*1e-7;
k=(Mu0)/(4*pi);
intsteps=500;


% over what range? corrdinates in mm
range=5;
xmax=1*range;
xmin=-1*range;
ymax=1*range;
ymin=-1*range;
zmax=1*range;
zmin=-1*range;
steps=80;
[xvec,yvec,zvec]=setupcoords(xmin,xmax,ymin,ymax,zmin,zmax,steps);

B=zeros(21,6);

testpointx=0/100;%0.5/100 -> tight 0.23/100 -> high bias experiment
testpointz=1/100;
counter=0;

%%%%%wire coordinates%%%%%
x1=-10/100; x2=10/100;
y1=0;
z1=0/100;

for ttt=1:steps+1


% assign test points
    Axx=testpointx;
    Ayy=0;
    Azz=zvec(ttt)+testpointz;
    counter=counter+1;

B(counter,1)=Axx-testpointx;
B(counter,2)=Ayy;
B(counter,3)=Azz-testpointz;
B(counter,(4:6))=zeros(1,3);

B(counter,(4:6))=B(counter,(4:6))+(1*linemag(k,x2,x1,y1,y1,z1,z1,Axx,Ayy,Azz,intsteps)); 


end
Bmag=plotline(B,steps,3);
hold on
counter=0;
zz=0:1/5000:.5/100;
Bth=Mu0./(2*pi*zz);
plot(zz*100,Bth*1e4,'*b')
hold off
