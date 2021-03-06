%Calculates the magnetic field for an extended Anti Helmholtz coil setup
% Uses an extended coil
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
intsteps=500;

thick1=1.7/1000; % wire thickness 

z1=62/1000;
R1=55/1000;%4.6228
I1=1; %116.8
N1=13+(6*15);%23.5
numz1s=7;
numr1s=15;

dist1=R1+(numr1s*thick1)

%%%% Note 1T = 10^4 G %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%First CL calc  .%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% over what range? corrdinates in mm
range=40;
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

testpoint=0.0/100;
onlyx=0;

if onlyx==0
% first calculate for z-axis
for ttt=1:steps+1

    wirecount1=0;
% assign test points
    Axx=testpoint;
    Ayy=0;
    Azz=zvec(ttt);
    counter=counter+1;

B(counter,1)=Axx;
B(counter,2)=Ayy;
B(counter,3)=Azz;
B(counter,(4:6))=zeros(1,3);

for ss=1:numz1s
    if (wirecount1==N1)
    break
    end
    z1temp=z1+(thick1/2)+(thick1*(ss-1));  
for tt =1:numr1s
    R1temp=R1+(thick1/2)+(thick1*(tt-1));

    B(counter,(4:6))=B(counter,(4:6))+(I1*ahmag(k,R1temp,z1temp,Axx,Ayy,Azz,intsteps));
    wirecount1=wirecount1+1;
        if (wirecount1==N1)
        break
        end
end
end
end
end

Bmag=plotline(B,steps,3);
hold on
counter=0;
% now calculate for y-axis

for ttt=1:steps+1

    wirecount1=0;

    % assign test points
    Axx=testpoint;
    Ayy=yvec(ttt);
    Azz=0;

    counter=counter+1;
    B(counter,1)=Axx;
    B(counter,2)=Ayy;
    B(counter,3)=Azz;
    B(counter,(4:6))=zeros(1,3);

for ss=1:numz1s
    if (wirecount1==N1)
    break
    end
    z1temp=z1+(thick1/2)+(thick1*(ss-1));  
for tt =1:numr1s
    R1temp=R1+(thick1/2)+(thick1*(tt-1));

    B(counter,(4:6))=B(counter,(4:6))+(I1*ahmag(k,R1temp,z1temp,Axx,Ayy,Azz,intsteps));
    wirecount1=wirecount1+1;
    if (wirecount1==N1)
    break
    end
end
end
end


Bmag=plotline(B,steps,2);
counter=0;

% now calculate for x-axis
for ttt=1:steps+1

wirecount1=0;

% assign test points
    Axx=xvec(ttt)+testpoint;
    Ayy=0;
    Azz=0;
    counter=counter+1;

B(counter,1)=Axx-testpoint;
B(counter,2)=Ayy;
B(counter,3)=Azz;
B(counter,(4:6))=zeros(1,3);

for ss=1:numz1s
    if (wirecount1==N1)
    break
    end
    z1temp=z1+(thick1/2)+(thick1*(ss-1));  
for tt =1:numr1s
    R1temp=R1+(thick1/2)+(thick1*(tt-1));

        B(counter,(4:6))=B(counter,(4:6))+(I1*ahmag(k,R1temp,z1temp,Axx,Ayy,Azz,intsteps));
    wirecount1=wirecount1+1;
    if (wirecount1==N1)
    break
    end
end
end
end

Bmag=plotline(B,steps,1);
counter=0;

if onlyx==0
% now calculate for xy-axis
for ttt=1:steps+1   
    wirecount1=0;

% assign test points
    Axx=xvec(ttt)+testpoint;
    Ayy=yvec(ttt);
    Azz=0;
    counter=counter+1;
    B(counter,1)=Axx-testpoint;
    B(counter,2)=Ayy;
    B(counter,3)=Azz;
    B(counter,(4:6))=zeros(1,3);
for ss=1:numz1s
    if (wirecount1==N1)
    break
    end
    z1temp=z1+(thick1/2)+(thick1*(ss-1));  
    for tt =1:numr1s
    R1temp=R1+(thick1/2)+(thick1*(tt-1));

    B(counter,(4:6))=B(counter,(4:6))+(I1*ahmag(k,R1temp,z1temp,Axx,Ayy,Azz,intsteps));
    wirecount1=wirecount1+1;
    if (wirecount1==N1)
    break
    end
end
end
end
end   


Bmag=plotline(B,steps,4);
hold off
toc