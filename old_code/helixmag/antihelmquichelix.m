%a program to calculate the field for a 
%QUIC trap. The trap comprises two sets of anti-helmholtz coils
% offset from each other
% This is an extended coil model
% this program rectifies the 'z' extended error i.e. factor of two!!!!!
% also includes the extra 1/3 turns
% Same as antihelmquicmodified2 accept it uses helixes instead of loops
%%also includes all the input and output wires


%%%%These are the current set of Magnetic and MOT coils at the ANU
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
intsteps=500;

alpha=17e-6; % linear thermal expansion coefficient/ degree, for copper
dT=0;%ten degree change!!
dx=alpha*dT*(0.5/1000);
%%%%%%%%%%%%%%%%%First coil set %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%z-dist. = 4.5mm (dist from centre to glass face)+ 2.6 (glass thickness)+
%           0.8 (thickness of metal former) +.25( thickness of rim)
%           +0.2(gap between glass and former)
zdd=7.3+0.8+.25;%5+2.6+0.75+0.25+.2;
z1=2*zdd/1000; % distance just before the first wire i.e. ->|o
R1=.75/100;%4.6228
I1=30*(1-0); %20 -> tight, 15 -> high bias for experiment
N1=10;%23.5
thick1=0.56/1000+0/1000; % wire thickness 
numz1s=10;
numr1s=1;
%%%%%%%%%%%%%%%%%Second coil set %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
z2=2*zdd/1000;
R2=0.70/100;%4.6228
I2=-30*(1+0); %20 -> tight, 30 -> high bias for experiment
N2=20  ;%23.5
x2=1.9/100; % use 1.95 for higher trap!
thick2=0.56/1000+0/1000;
numz2s=20;
numr2s=1; 

%assume the wire coating is around 50 microns thick

%%%%%%%%%%%%%%%%%%%%%%%Work out power consumed
rho=1.75e-8; %ohms m
wthick1=(thick1/2)-50e-6;
a1=pi*wthick1^2;
l1=2*N1*2*pi*R1;

wthick2=(thick2/2)-50e-6;
a2=pi*wthick2^2;
l2=2*N2*2*pi*R2;

Res1=rho*l1/a1
Res2=rho*l2/a2

Res=Res1+Res2
V=I1*Res


%%%% Note 1T = 10^4 G %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%First CL calc  .%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% over what range? corrdinates in mm
range=15;
xmax=1*range;
xmin=-1*range;
ymax=1*range;
ymin=-1*range;
zmax=1*range;
zmin=-1*range;
steps=80;
[xvec,yvec,zvec]=setupcoords(xmin,xmax,ymin,ymax,zmin,zmax,steps);
counter=0;
wirecount=0;
B=zeros(21,6);
addwires=1;

testpoint=0/100;%0.5/100 -> tight 0.23/100 -> high bias experiment
onlyx=0;
addedbias=0e-4;

if onlyx ==0
% first calculate for z-axis
for ttt=1:steps+1

    wirecount1=0;
    wirecount2=0;
% assign test points
    Axx=testpoint;
    Ayy=0;
    Azz=zvec(ttt);
    counter=counter+1;

B(counter,1)=Axx;
B(counter,2)=Ayy;
B(counter,3)=Azz;
B(counter,(4:6))=zeros(1,3);

%%%%%%%%Do wires first%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
beta=atan(1.1/.5);
wxstart = (R1+(1.5*thick1))*cos(beta); wxstop=wxstart;
wystart = (R1+(1.5*thick1))*sin(beta); wystop=wystart;
wzstart = z1/2+12.5/1000; wzstop = z1/2 +thick1/2;
%%starting with Quad wires%%%%%%%%%%%%%%%%
%%quad wire in starting from pos x,y and z
if addwires ==1
B(counter,(4:6))=B(counter,(4:6))+(I1*linemag(k,wxstart,wxstop,wystart,wystop,wzstart,wzstop,Axx,Ayy,Azz,intsteps)); 
%%quad wire out starting from neg x,y and pos z
B(counter,(4:6))=B(counter,(4:6))+(I1*linemag(k,wxstart,wxstop,-wystart,-wystop,wzstop,wzstart,Axx,Ayy,Azz,intsteps)); 
%%quad wire in starting from neg x,y and neg z
B(counter,(4:6))=B(counter,(4:6))+(I1*linemag(k,wxstart,wxstop,-wystart,-wystop,-wzstart,-wzstop,Axx,Ayy,Azz,intsteps)); 
%%quad wire out starting from pos x,y and neg z
B(counter,(4:6))=B(counter,(4:6))+(I1*linemag(k,wxstart,wxstop,wystart,wystop,-wzstop,-wzstart,Axx,Ayy,Azz,intsteps)); 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Extended integration for on-axis coil%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for ss=1:numz1s
    if (wirecount1==N1)
    break
    end
    z1temp=z1/2+(thick1/2)+(thick1*(ss-1)); % distance to the centre of each wire 
for tt =1:numr1s
    R1temp=R1+(thick1/2)+(thick1*(tt-1));
%%break this into two lots one from theta =beta to theta =0 and then one
%%from 2*pi to beta %%%%%%%%%%%%%%%%%%%%%%%%%
   B(counter,(4:6))=B(counter,(4:6))+(I1*ahmaghelixextra(k,R1temp,beta,0,2*z1temp,thick1,Axx,Ayy,Azz,intsteps));
   B(counter,(4:6))=B(counter,(4:6))+(I1*ahmaghelixextra(k,R1temp,2*pi,beta,(2*z1temp)+(beta/(pi)*thick1),thick1,Axx,Ayy,Azz,intsteps));
    wirecount1=wirecount1+1;
        if (wirecount1==N1)
        break
        end
end
end

%%%%%%%%%Add in the extra bit for the wire to make it out%%%%%%%%%%%%%%%%%%%%%%
%%%do it in two bits, so we don't have theta changing sign%%%%%%%%
   B(counter,(4:6))=B(counter,(4:6))+(I1*ahmaghelixextra(k,R1temp,beta,0,2*(z1temp+thick1),thick1,Axx,Ayy,Azz,intsteps));
   B(counter,(4:6))=B(counter,(4:6))+(I1*ahmaghelixextra(k,R1temp,2*pi,((2*pi)-beta),(2*(z1temp+thick1))+(beta/(pi)*thick1),thick1,Axx,Ayy,Azz,intsteps));

%%%%Input Ioffe wires%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
wxstart = x2-((R2+(1.5*thick2))*cos(beta)); wxstop=wxstart;
wystart = (R2+(1.5*thick2))*sin(beta); wystop=wystart;
wzstart = z1/2+12.5/1000; wzstop = z1/2 +thick1/2;
%%Ioffe wire in starting from pos x,y and z
if addwires ==1
B(counter,(4:6))=B(counter,(4:6))+(I2*linemag(k,wxstart,wxstop,wystart,wystop,wzstart,wzstop,Axx,Ayy,Azz,intsteps)); 
%%quad wire out starting from neg x,y and pos z
B(counter,(4:6))=B(counter,(4:6))+(I2*linemag(k,wxstart,wxstop,-wystart,-wystop,wzstop,wzstart,Axx,Ayy,Azz,intsteps)); 
%%quad wire in starting from neg x,y and neg z
B(counter,(4:6))=B(counter,(4:6))+(I2*linemag(k,wxstart,wxstop,-wystart,-wystop,-wzstart,-wzstop,Axx,Ayy,Azz,intsteps)); 
%%quad wire out starting from pos x,y and neg z
B(counter,(4:6))=B(counter,(4:6))+(I2*linemag(k,wxstart,wxstop,wystart,wystop,-wzstop,-wzstart,Axx,Ayy,Azz,intsteps)); 
end
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%%%%Extended integration for off-axis coil%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for ss=1:numz2s
    if (wirecount2==N2)
    break
    end
    z2temp=z2/2+(thick2/2)+(thick2*(ss-1));   
    
    for tt =1:numr2s
    R2temp=R2+(thick2/2)+(thick2*(tt-1));  
   B(counter,(4:6))=B(counter,(4:6))+(I2*ahmagoffhelix(k,x2,R2temp,pi-beta,2*pi,2*z2temp,thick2,Axx,Ayy,Azz,intsteps));
   B(counter,(4:6))=B(counter,(4:6))+(I2*ahmagoffhelix(k,x2,R2temp,0,pi-beta,(2*z2temp)+((pi+beta)/pi*thick2),thick2,Axx,Ayy,Azz,intsteps));
   wirecount2=wirecount2+1;
        if (wirecount2==N2)
        break
        end
    end
end  
%%%%%%%%%Add in the extra bit for the wire to make it%%%%%%%%%%%%%%%%%%%%%%
 B(counter,(4:6))=B(counter,(4:6))+(I2*ahmagoffhelix(k,x2,R2temp,pi-beta,pi+beta,2*(z2temp+thick2),thick2,Axx,Ayy,Azz,intsteps));
   
B(counter,(4:6))=B(counter,(4:6))+[addedbias 0 0];
end
Bmag=plotline(B,steps,3);
hold on
counter=0;
break
% now calculate for y-axis
for ttt=1:steps+1

    wirecount1=0;
    wirecount2=0;

    % assign test points
    Axx=testpoint;
    Ayy=yvec(ttt);
    Azz=0;

    counter=counter+1;
    B(counter,1)=Axx;
    B(counter,2)=Ayy;
    B(counter,3)=Azz;
    B(counter,(4:6))=zeros(1,3);
%%%%%%%%Do wires first%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
beta=atan(1.1/.5);
wxstart = (R1+(1.5*thick1))*cos(beta); wxstop=wxstart;
wystart = (R1+(1.5*thick1))*sin(beta); wystop=wystart;
wzstart = z1/2+12.5/1000; wzstop = z1/2 +thick1/2;
%%starting with Quad wires%%%%%%%%%%%%%%%%
%%quad wire in starting from pos x,y and z
if addwires==1
B(counter,(4:6))=B(counter,(4:6))+(I1*linemag(k,wxstart,wxstop,wystart,wystop,wzstart,wzstop,Axx,Ayy,Azz,intsteps)); 
%%quad wire out starting from neg x,y and pos z
B(counter,(4:6))=B(counter,(4:6))+(I1*linemag(k,wxstart,wxstop,-wystart,-wystop,wzstop,wzstart,Axx,Ayy,Azz,intsteps)); 
%%quad wire in starting from neg x,y and neg z
B(counter,(4:6))=B(counter,(4:6))+(I1*linemag(k,wxstart,wxstop,-wystart,-wystop,-wzstart,-wzstop,Axx,Ayy,Azz,intsteps)); 
%%quad wire out starting from pos x,y and neg z
B(counter,(4:6))=B(counter,(4:6))+(I1*linemag(k,wxstart,wxstop,wystart,wystop,-wzstop,-wzstart,Axx,Ayy,Azz,intsteps)); 
end
for ss=1:numz1s
    if (wirecount1==N1)
    break
    end
    z1temp=z1/2+(thick1/2)+(thick1*(ss-1));  
for tt =1:numr1s
    R1temp=R1+(thick1/2)+(thick1*(tt-1));
%%break this into two lots one from theta =beta to theta =0 and then one
%%from 2*pi to beta %%%%%%%%%%%%%%%%%%%%%%%%%
   B(counter,(4:6))=B(counter,(4:6))+(I1*ahmaghelixextra(k,R1temp,beta,0,2*z1temp,thick1,Axx,Ayy,Azz,intsteps));
   B(counter,(4:6))=B(counter,(4:6))+(I1*ahmaghelixextra(k,R1temp,2*pi,beta,(2*z1temp)+(beta/(pi)*thick1),thick1,Axx,Ayy,Azz,intsteps));
    wirecount1=wirecount1+1;
    if (wirecount1==N1)
    break
    end
end
end

%%%%%%%%%Add in the extra bit for the wire to make it%%%%%%%%%%%%%%%%%%%%%%
%%%do it in two bits, so we don't have theta changing sign%%%%%%%%
  B(counter,(4:6))=B(counter,(4:6))+(I1*ahmaghelixextra(k,R1temp,beta,0,2*(z1temp+thick1),thick1,Axx,Ayy,Azz,intsteps));
   B(counter,(4:6))=B(counter,(4:6))+(I1*ahmaghelixextra(k,R1temp,2*pi,((2*pi)-beta),(2*(z1temp+thick1))+(beta/(pi)*thick1),thick1,Axx,Ayy,Azz,intsteps));
    
%%%%Input Ioffe wires%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
wxstart = x2-((R2+(1.5*thick2))*cos(beta)); wxstop=wxstart;
wystart = (R2+(1.5*thick2))*sin(beta); wystop=wystart;
wzstart = z1/2+12.5/1000; wzstop = z1/2 +thick1/2;
%%Ioffe wire in starting from pos x,y and z
if addwires ==1
B(counter,(4:6))=B(counter,(4:6))+(I2*linemag(k,wxstart,wxstop,wystart,wystop,wzstart,wzstop,Axx,Ayy,Azz,intsteps)); 
%%quad wire out starting from neg x,y and pos z
B(counter,(4:6))=B(counter,(4:6))+(I2*linemag(k,wxstart,wxstop,-wystart,-wystop,wzstop,wzstart,Axx,Ayy,Azz,intsteps)); 
%%quad wire in starting from neg x,y and neg z
B(counter,(4:6))=B(counter,(4:6))+(I2*linemag(k,wxstart,wxstop,-wystart,-wystop,-wzstart,-wzstop,Axx,Ayy,Azz,intsteps)); 
%%quad wire out starting from pos x,y and neg z
B(counter,(4:6))=B(counter,(4:6))+(I2*linemag(k,wxstart,wxstop,wystart,wystop,-wzstop,-wzstart,Axx,Ayy,Azz,intsteps)); 
end   
for ss=1:numz2s
    if (wirecount2==N2)
    break
    end
    z2temp=z2/2+(thick2/2)+(thick2*(ss-1));   
    for tt =1:numr2s
    R2temp=R2+(thick2/2)+(thick2*(tt-1));  
   B(counter,(4:6))=B(counter,(4:6))+(I2*ahmagoffhelix(k,x2,R2temp,pi-beta,2*pi,2*z2temp,thick2,Axx,Ayy,Azz,intsteps));
   B(counter,(4:6))=B(counter,(4:6))+(I2*ahmagoffhelix(k,x2,R2temp,0,pi-beta,(2*z2temp)+((pi+beta)/pi*thick2),thick2,Axx,Ayy,Azz,intsteps));
    wirecount2=wirecount2+1;
    if (wirecount2==N2)
    break
    end
    end
end
%%%%%%%%%Add in the extra bit for the wire to make it%%%%%%%%%%%%%%%%%%%%%%
  B(counter,(4:6))=B(counter,(4:6))+(I2*ahmagoffhelix(k,x2,R2temp,pi-beta,pi+beta,2*(z2temp+thick2),thick2,Axx,Ayy,Azz,intsteps));
end
Bmag=plotline(B,steps,2);
counter=0;

end

% now calculate for x-axis
for ttt=1:steps+1

wirecount1=0;
wirecount2=0;
% assign test points
    Axx=xvec(ttt)+testpoint;
    Ayy=0;
    Azz=0;
    counter=counter+1;

B(counter,1)=Axx-testpoint;
B(counter,2)=Ayy;
B(counter,3)=Azz;
B(counter,(4:6))=zeros(1,3);
%%%%%%%%Do wires first%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
beta=atan(1.1/.5);
wxstart = (R1+(1.5*thick1))*cos(beta); wxstop=wxstart;
wystart = (R1+(1.5*thick1))*sin(beta); wystop=wystart;
wzstart = z1/2+12.5/1000; wzstop = z1/2 +thick1/2;
%%starting with Quad wires%%%%%%%%%%%%%%%%
%%quad wire in starting from pos x,y and z
if addwires==1
B(counter,(4:6))=B(counter,(4:6))+(I1*linemag(k,wxstart,wxstop,wystart,wystop,wzstart,wzstop,Axx,Ayy,Azz,intsteps)); 
%%quad wire out starting from neg x,y and pos z
B(counter,(4:6))=B(counter,(4:6))+(I1*linemag(k,wxstart,wxstop,-wystart,-wystop,wzstop,wzstart,Axx,Ayy,Azz,intsteps)); 
%%quad wire in starting from neg x,y and neg z
B(counter,(4:6))=B(counter,(4:6))+(I1*linemag(k,wxstart,wxstop,-wystart,-wystop,-wzstart,-wzstop,Axx,Ayy,Azz,intsteps)); 
%%quad wire out starting from pos x,y and neg z
B(counter,(4:6))=B(counter,(4:6))+(I1*linemag(k,wxstart,wxstop,wystart,wystop,-wzstop,-wzstart,Axx,Ayy,Azz,intsteps)); 
end
for ss=1:numz1s
    if (wirecount1==N1)
    break
    end
    z1temp=z1/2+(thick1/2)+(thick1*(ss-1));  
for tt =1:numr1s
    R1temp=R1+(thick1/2)+(thick1*(tt-1));
%%break this into two lots one from theta =beta to theta =0 and then one
%%from 2*pi to beta %%%%%%%%%%%%%%%%%%%%%%%%%
   B(counter,(4:6))=B(counter,(4:6))+(I1*ahmaghelixextra(k,R1temp,beta,0,2*z1temp,thick1,Axx,Ayy,Azz,intsteps));
   B(counter,(4:6))=B(counter,(4:6))+(I1*ahmaghelixextra(k,R1temp,2*pi,beta,(2*z1temp)+(beta/(pi)*thick1),thick1,Axx,Ayy,Azz,intsteps));
    wirecount1=wirecount1+1;
    if (wirecount1==N1)
    break
    end
end
end

%%%%%%%%%Add in the extra bit for the wire to make it%%%%%%%%%%%%%%%%%%%%%%
%%%do it in two bits, so we don't have theta changing sign%%%%%%%%
    B(counter,(4:6))=B(counter,(4:6))+(I1*ahmaghelixextra(k,R1temp,beta,0,2*(z1temp+thick1),thick1,Axx,Ayy,Azz,intsteps));
   B(counter,(4:6))=B(counter,(4:6))+(I1*ahmaghelixextra(k,R1temp,2*pi,((2*pi)-beta),(2*(z1temp+thick1))+(beta/(pi)*thick1),thick1,Axx,Ayy,Azz,intsteps));

%%%%Input Ioffe wires%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
wxstart = x2-((R2+(1.5*thick2))*cos(beta)); wxstop=wxstart;
wystart = (R2+(1.5*thick2))*sin(beta); wystop=wystart;
wzstart = z1/2+12.5/1000; wzstop = z1/2 +thick1/2;
%%Ioffe wire in starting from pos x,y and z
if addwires ==1
B(counter,(4:6))=B(counter,(4:6))+(I2*linemag(k,wxstart,wxstop,wystart,wystop,wzstart,wzstop,Axx,Ayy,Azz,intsteps)); 
%%quad wire out starting from neg x,y and pos z
B(counter,(4:6))=B(counter,(4:6))+(I2*linemag(k,wxstart,wxstop,-wystart,-wystop,wzstop,wzstart,Axx,Ayy,Azz,intsteps)); 
%%quad wire in starting from neg x,y and neg z
B(counter,(4:6))=B(counter,(4:6))+(I2*linemag(k,wxstart,wxstop,-wystart,-wystop,-wzstart,-wzstop,Axx,Ayy,Azz,intsteps)); 
%%quad wire out starting from pos x,y and neg z
B(counter,(4:6))=B(counter,(4:6))+(I2*linemag(k,wxstart,wxstop,wystart,wystop,-wzstop,-wzstart,Axx,Ayy,Azz,intsteps)); 
end
for ss=1:numz2s
    if (wirecount2==N2)
    break
    end
    z2temp=z2/2+(thick2/2)+(thick2*(ss-1));   
for tt =1:numr2s
    R2temp=R2+(thick2/2)+(thick2*(tt-1));  
   B(counter,(4:6))=B(counter,(4:6))+(I2*ahmagoffhelix(k,x2,R2temp,pi-beta,2*pi,2*z2temp,thick2,Axx,Ayy,Azz,intsteps));
   B(counter,(4:6))=B(counter,(4:6))+(I2*ahmagoffhelix(k,x2,R2temp,0,pi-beta,(2*z2temp)+((pi+beta)/pi*thick2),thick2,Axx,Ayy,Azz,intsteps));
    wirecount2=wirecount2+1;
    if (wirecount2==N2)
    break
    end
end
end
%%%%%%%%%Add in the extra bit for the wire to make it%%%%%%%%%%%%%%%%%%%%%%
  B(counter,(4:6))=B(counter,(4:6))+(I2*ahmagoffhelix(k,x2,R2temp,pi-beta,pi+beta,2*(z2temp+thick2),thick2,Axx,Ayy,Azz,intsteps));
  B(counter,(4:6))=B(counter,(4:6))+[addedbias 0 0];
end

Bmag=plotline(B,steps,1);
counter=0;


if onlyx==0
% now calculate for xy-axis
for ttt=1:steps+1   
    wirecount1=0;
    wirecount2=0;

% assign test points
    Axx=xvec(ttt)+testpoint;
    Ayy=yvec(ttt);
    Azz=0;
    counter=counter+1;
    B(counter,1)=Axx-testpoint;
    B(counter,2)=Ayy;
    B(counter,3)=Azz;
    B(counter,(4:6))=zeros(1,3);
    %%%%%%%%Do wires first%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
beta=atan(1.1/.5);
wxstart = (R1+(1.5*thick1))*cos(beta); wxstop=wxstart;
wystart = (R1+(1.5*thick1))*sin(beta); wystop=wystart;
wzstart = z1/2+12.5/1000; wzstop = z1/2 +thick1/2;
%%starting with Quad wires%%%%%%%%%%%%%%%%
%%quad wire in starting from pos x,y and z
if addwires==1
B(counter,(4:6))=B(counter,(4:6))+(I1*linemag(k,wxstart,wxstop,wystart,wystop,wzstart,wzstop,Axx,Ayy,Azz,intsteps)); 
%%quad wire out starting from neg x,y and pos z
B(counter,(4:6))=B(counter,(4:6))+(I1*linemag(k,wxstart,wxstop,-wystart,-wystop,wzstop,wzstart,Axx,Ayy,Azz,intsteps)); 
%%quad wire in starting from neg x,y and neg z
B(counter,(4:6))=B(counter,(4:6))+(I1*linemag(k,wxstart,wxstop,-wystart,-wystop,-wzstart,-wzstop,Axx,Ayy,Azz,intsteps)); 
%%quad wire out starting from pos x,y and neg z
B(counter,(4:6))=B(counter,(4:6))+(I1*linemag(k,wxstart,wxstop,wystart,wystop,-wzstop,-wzstart,Axx,Ayy,Azz,intsteps)); 
end
for ss=1:numz1s
    if (wirecount1==N1)
    break
    end
    z1temp=z1/2+(thick1/2)+(thick1*(ss-1));  
    for tt =1:numr1s
    R1temp=R1+(thick1/2)+(thick1*(tt-1));
%%break this into two lots one from theta =beta to theta =0 and then one
%%from 2*pi to beta %%%%%%%%%%%%%%%%%%%%%%%%%
   B(counter,(4:6))=B(counter,(4:6))+(I1*ahmaghelixextra(k,R1temp,beta,0,2*z1temp,thick1,Axx,Ayy,Azz,intsteps));
   B(counter,(4:6))=B(counter,(4:6))+(I1*ahmaghelixextra(k,R1temp,2*pi,beta,(2*z1temp)+(beta/(pi)*thick1),thick1,Axx,Ayy,Azz,intsteps));
    wirecount1=wirecount1+1;
    if (wirecount1==N1)
    break
    end
    end
end
%%%%%%%%%Add in the extra bit for the wire to make it%%%%%%%%%%%%%%%%%%%%%%
%%%do it in two bits, so we don't have theta changing sign%%%%%%%%
  B(counter,(4:6))=B(counter,(4:6))+(I1*ahmaghelixextra(k,R1temp,beta,0,2*(z1temp+thick1),thick1,Axx,Ayy,Azz,intsteps));
   B(counter,(4:6))=B(counter,(4:6))+(I1*ahmaghelixextra(k,R1temp,2*pi,((2*pi)-beta),(2*(z1temp+thick1))+(beta/(pi)*thick1),thick1,Axx,Ayy,Azz,intsteps));

%%%%Input Ioffe wires%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
wxstart = x2-((R2+(1.5*thick2))*cos(beta)); wxstop=wxstart;
wystart = (R2+(1.5*thick2))*sin(beta); wystop=wystart;
wzstart = z1/2+12.5/1000; wzstop = z1/2 +thick1/2;
%%Ioffe wire in starting from pos x,y and z
if addwires ==1
B(counter,(4:6))=B(counter,(4:6))+(I2*linemag(k,wxstart,wxstop,wystart,wystop,wzstart,wzstop,Axx,Ayy,Azz,intsteps)); 
%%quad wire out starting from neg x,y and pos z
B(counter,(4:6))=B(counter,(4:6))+(I2*linemag(k,wxstart,wxstop,-wystart,-wystop,wzstop,wzstart,Axx,Ayy,Azz,intsteps)); 
%%quad wire in starting from neg x,y and neg z
B(counter,(4:6))=B(counter,(4:6))+(I2*linemag(k,wxstart,wxstop,-wystart,-wystop,-wzstart,-wzstop,Axx,Ayy,Azz,intsteps)); 
%%quad wire out starting from pos x,y and neg z
B(counter,(4:6))=B(counter,(4:6))+(I2*linemag(k,wxstart,wxstop,wystart,wystop,-wzstop,-wzstart,Axx,Ayy,Azz,intsteps)); 
end
for ss=1:numz2s
    if (wirecount2==N2)
    break
    end
    z2temp=z2/2+(thick2/2)+(thick2*(ss-1));   
    for tt =1:numr2s
    R2temp=R2+(thick2/2)+(thick2*(tt-1));  
   B(counter,(4:6))=B(counter,(4:6))+(I2*ahmagoffhelix(k,x2,R2temp,pi-beta,2*pi,2*z2temp,thick2,Axx,Ayy,Azz,intsteps));
   B(counter,(4:6))=B(counter,(4:6))+(I2*ahmagoffhelix(k,x2,R2temp,0,pi-beta,(2*z2temp)+((pi+beta)/pi*thick2),thick2,Axx,Ayy,Azz,intsteps));
    wirecount2=wirecount2+1;
    if (wirecount2==N2)
    break
    end
end
end
%%%%%%%%%Add in the extra bit for the wire to make it%%%%%%%%%%%%%%%%%%%%%%
  B(counter,(4:6))=B(counter,(4:6))+(I2*ahmagoffhelix(k,x2,R2temp,pi-beta,pi+beta,2*(z2temp+thick2),thick2,Axx,Ayy,Azz,intsteps));
  B(counter,(4:6))=B(counter,(4:6))+[addedbias 0 0];
end   
end

Bmag=plotline(B,steps,4);
grid on
hold off
toc

