%
% calculates the magnetic field using arcs and line segments
% uses two subroutines magarc.m - to calculate the magnetic field components
% for an arc of radius R ...
% magline.m - calculate magnetic field components for  line charge

clear all
close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%Constants%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
Mu0 = 4*pi*1e-7;
k=(Mu0)/(4*pi);
intsteps=400;

%%%%%%%%%%%%%%%%%%%%%%%For coils OD =1.8mm, ID =0.7 mm%%%%%%%%%%%%%
%%%%% R= 21/1000 Ohms/m
Iah=30; %-60
Nah=250;%22.5
zah=2*12/100;
Rah=12/100;%(1.4/2)*(25.4/1000); Mean radius + a little for heatshrink
l=2*pi*Rah*Nah*2;
RR=21*l/1000;
VV=Iah*RR
%%%% Note 1T = 10^4 G %%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%First CL calc  .%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% over what range? corrdinates in mm
range=5;
xmax=1*range;
xmin=-1*range;
ymax=1*range;
ymin=-1*range;
zmax=1*range;
zmin=-1*range;
steps=200;
[xvec,yvec,zvec]=setupcoords(xmin,xmax,ymin,ymax,zmin,zmax,steps);
counter=0;
B=zeros(21,6);

testpointx=8/100;%0.5/100 -> tight 0.23/100 -> high bias experiment
testpointy=0/100;
testpointz=0/100;

% first calculate for z-axis
for ttt=1:steps+1
  

   % assign test points
   Axx=testpointx;
   Ayy=testpointy;
   Azz=testpointz+zvec(ttt);
   
 counter=counter+1;
 B(counter,1)=Axx-testpointx;
 B(counter,2)=Ayy-testpointy;
 B(counter,3)=Azz-testpointz;
 B(counter,(4:6))= (Iah*Nah*ahmag(k,Rah,zah,Axx,Ayy,Azz,intsteps))+[0,0,0];

end

Bmag=plotline(B,steps,3);
hold on


counter=0;
% now calculate for y-axis
for ttt=1:steps+1
   
   % assign test points
    Axx=testpointx;
   Ayy=testpointy+yvec(ttt);
   Azz=testpointz;
   
 counter=counter+1;
 B(counter,1)=Axx-testpointx;
 B(counter,2)=Ayy-testpointy;
 B(counter,3)=Azz-testpointz;
 B(counter,(4:6))= (Iah*Nah*ahmag(k,Rah,zah,Axx,Ayy,Azz,intsteps))+[0,0,0];

end
Bmag=plotline(B,steps,2);
counter=0;

% now calculate for x-axis
for ttt=1:steps+1
   
   % assign test points
   Axx=testpointx+xvec(ttt);
   Ayy=testpointy;
   Azz=testpointz;
   
 counter=counter+1;
 B(counter,1)=Axx-testpointx;
 B(counter,2)=Ayy-testpointy;
 B(counter,3)=Azz-testpointz;
 B(counter,(4:6))= (Iah*Nah*ahmag(k,Rah,zah,Axx,Ayy,Azz,intsteps))+[0,0,0];

end
Bmag=plotline(B,steps,1);
counter=0;
AA=B;

% now calculate for xy-axis
for ttt=1:steps+1   
   % assign test points
  Axx=xvec(ttt)+testpointx;
   Ayy=yvec(ttt)+testpointy;
   Azz=testpointz;
   
 counter=counter+1;
 B(counter,1)=Axx-testpointx;
 B(counter,2)=Ayy-testpointy;
 B(counter,3)=Azz-testpointz;
 B(counter,(4:6))= (Iah*Nah*ahmag(k,Rah,zah,Axx,Ayy,Azz,intsteps))+[0,0,0];

end   

%Bmag=plotline(B,steps,4);
key
grid on
%hold off
%plot(x(:,1),x(:,5),'kh',xy(:,1),xy(:,5),'yo',z(:,1),z(:,5),'c.',y(:,1),y(:,5),'rs')
hold off

toc