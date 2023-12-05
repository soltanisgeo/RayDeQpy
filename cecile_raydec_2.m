% Read file
close all; clear all;

% [X1,I1]=rdmseed('/media/cornouc/SAMSUNG/CALCUL_ARGOSTOLI/VALIDATED_DATA/2011/KES01/4C.KES01.00.HHZ.D.2011.264');
% [X2,I2]=rdmseed('/media/cornouc/SAMSUNG/CALCUL_ARGOSTOLI/VALIDATED_DATA/2011/KES01/4C.KES01.00.HHN.D.2011.264');
% [X3,I3]=rdmseed('/media/cornouc/SAMSUNG/CALCUL_ARGOSTOLI/VALIDATED_DATA/2011/KES01/4C.KES01.00.HHE.D.2011.264');
% k = I(1).XBlockIndex;
% east1 = cat(1,X(k).d);
% dt=1/cat(1,X(1).SampleRate);
% t0 = cat(1,X(k).t);
% k = I(2).XBlockIndex;
% north1 = cat(1,X(k).d);
% k = I(3).XBlockIndex;
% vertical1 = cat(1,X(k).d);
files = dir('E:\raydecC\FARtest\*1.sac');
for k=1:length(files)
    f1 = readsac(files(k).name(1:20) + "1.sac");
    vertical1=f1.trace;
    f2 = readsac(files(k).name(1:20) + "2.sac");
    north1=f2.trace;
    f3 = readsac(files(k).name(1:20) + "3.sac");
    east1=f3.trace;
    dt=f1.tau;



%site=readsac('4C.KES01.00.HHZ.D.2011.264.sac.50Hz_filt');
%site=readsac('FAR.02.064.21.22.45.1.sac');
%site=readsac('4C.KES01.00.HHN.D.2011.264.sac.50Hz_filt');
%site=readsac('FAR.02.064.21.22.45.1.sac');
%site=readsac('4C.KES01.00.HHE.D.2011.264.sac.50Hz_filt');
%site=readsac('FAR.02.064.21.22.45.1.sac');
load begintime.txt
t1 =0:dt:dt*length(vertical1)-dt;
1/dt

% figure(1);
% plot(t,vertical1./max(vertical1),'k');hold on;
% plot(t,north1./max(north1)-1,'k');
% plot(t,east1./max(east1)-2,'k');

% Loop over time windows
% duration=60;  % 60 seconds windows
% nduration=floor(60/dt);
%figure(2);hold on;


for i=1:length(begintime);
        ntime1=floor(begintime(i)/dt+1);
        ntime2=floor((begintime(i)+50)/dt+1); 
        vertical=vertical1(ntime1:ntime2);  % to cut into the selected time window
        vertical=vertical-mean(vertical); % to remove the offset
        vertical=detrend(vertical);
        north=north1(ntime1:ntime2);  % to cut into the selected time window
        north=north-mean(north); % to remove the offset
        north=detrend(north);
        east=east1(ntime1:ntime2);  % to cut into the selected time window
        east=east-mean(east); % to remove the offset
        east=detrend(east);
        t=t1(ntime1:ntime2);   
        
        
end




% [tt1,tt2]=ginput;
% ntime1=floor(tt1(1)/dt);
% ntime2=floor(tt1(2)/dt);
% 
% close all;

% vertical=vertical1(ntime1:ntime2);  % to cut into the selected time window
% vertical=vertical-mean(vertical); % to remove the offset
% vertical=detrend(vertical);
% north=north1(ntime1:ntime2);  % to cut into the selected time window
% north=north-mean(north); % to remove the offset
% north=detrend(north);
% east=east1(ntime1:ntime2);  % to cut into the selected time window
% east=east-mean(east); % to remove the offset
% east=detrend(east);
% t=t(ntime1:ntime2);

% decimation
%vertical=decimate(vertical,2);
%north=decimate(north,2);
%east=decimate(east,2);
%dt=dt*2;
%t=0:dt:dt*length(vertical)-dt;

% [V,W]=raydec(vertical, north, east, t, 1, 10, 50, 10, 0.2)
% 
% plot(V,W,'r');

% tab=[V, W];
[V,W]=raydec(vertical, north, east, t, 0.2, 2, 50, 10, 0.2);
loglog(V,W);
hold on
tab=[V, W];
basename=files(k).name(1:20)+".ell";
fileID=fopen(basename,'w');
fprintf(fileID,'%f %f \n',tab');
fclose(fileID);

end

