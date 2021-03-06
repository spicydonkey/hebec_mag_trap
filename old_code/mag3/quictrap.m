%a program to calculate the field for a simple three coil
%QUIC trap.  The same configuration as Esslinger
% We assume that the coil is NOT extended
% the third coil is in the x-axis
clear all
%close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%Constants%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
Mu0 = 4*pi*1e-7;
k=(Mu0)/(4*pi);
intsteps=400;
dx=0e-6;
%%%%Define the two ahcoils%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Iah=200; %200
Nah=1;%22.5
zah=2*.8/100-dx;%*(31+(Nah*1.6))/1000;
Rah=.8/100+dx;%(1.4/2)*(25.4/1000); Mean radius + a little for heatshrink

%%%%%%%%Define Ioffe coil%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Io=-108; %-60
No=1;%22.5
xo=2*(1/100+dx);%*(31+(Nah*1.6))/1000;
Ro=.6/100-dx;%(1.4/2)*(25.4/1000)
%%%% Note 1T = 10^4 G %%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%First coil calc  .%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% over what range? corrdinates in mm
range=1;
xmax=1*range;
xmin=-1*range;
ymax=1*range;
ymin=-1*range;
zmax=1*range;
zmin=-1*range;
steps=100;
[xvec,yvec,zvec]=setupcoords(xmin,xmax,ymin,ymax,zmin,zmax,steps);
counter=0;
B=zeros(21,6);

tp=.35/100;

% first calculate for z-axis
for ttt=1:steps+1
   
   % assign test points
   Axx=tp;
   Ayy=0;
   Azz=zvec(ttt);
   
 counter=counter+1;
 B(counter,1)=Axx;
 B(counter,2)=Ayy;
 B(counter,3)=Azz;
 B(counter,(4:6))= (Iah*Nah*ahmag(k,Rah,zah,Axx,Ayy,Azz,intsteps))+(Io*No*Qmag(k,Ro,xo,Axx,Ayy,Azz,intsteps));

end
Bmag=plotline(B,steps,3);
hold on

counter=0;
% now calculate for y-axis
for ttt=1:steps+1
   
   % assign test points
   Axx=tp;
   Ayy=yvec(ttt);
   Azz=0;
   
 counter=counter+1;
 B(counter,1)=Axx;
 B(counter,2)=Ayy;
 B(counter,3)=Azz;
 B(counter,(4:6))= (Iah*Nah*ahmag(k,Rah,zah,Axx,Ayy,Azz,intsteps))+(Io*No*Qmag(k,Ro,xo,Axx,Ayy,Azz,intsteps));

end
Bmag=plotline(B,steps,2);
counter=0;

% now calculate for x-axis
for ttt=1:steps+1
   
   % assign test points
   Axx=xvec(ttt)+tp;
   Ayy=0;
   Azz=0;
   
 counter=counter+1;
 B(counter,1)=Axx-tp; % we reset the axis for plotting, note that we are really at (tp,0,0)
 B(counter,2)=Ayy;
 B(counter,3)=Azz;
 B(counter,(4:6))= (Iah*Nah*ahmag(k,Rah,zah,Axx,Ayy,Azz,intsteps))+(Io*No*Qmag(k,Ro,xo,Axx,Ayy,Azz,intsteps));

end
Bmag=plotline(B,steps,1);
counter=0;
AA=B;

% now calculate for xy-axis
for ttt=1:steps+1   
   % assign test points
  Axx=xvec(ttt)+tp;
   Ayy=yvec(ttt);
   Azz=0;
   
 counter=counter+1;
 B(counter,1)=Axx-tp;% we reset the axis for plotting, note that we are really at (tp,0,0)
 B(counter,2)=Ayy;
 B(counter,3)=Azz;
 B(counter,(4:6))= (Iah*Nah*ahmag(k,Rah,zah,Axx,Ayy,Azz,intsteps))+(Io*No*Qmag(k,Ro,xo,Axx,Ayy,Azz,intsteps));
end   

Bmag=plotline(B,steps,4);
key
grid on
%hold off
%plot(x(:,1),x(:,5),'kh',xy(:,1),xy(:,5),'yo',z(:,1),z(:,5),'c.',y(:,1),y(:,5),'rs')
hold off

toc