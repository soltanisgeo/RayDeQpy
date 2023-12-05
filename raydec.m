function [V,W]=raydec(vert, north, east, time, fmin, fmax, fsteps, cycles, dfpar)

% [fl,el]=RAYDEC(vert, north, east, time, fmin, fmax, fsteps, cycles, dfpar) 
%    calculates the ellipticity of Rayleigh waves for the
%    input data vert, north, east and time for fsteps 
%    frequencies (on a logarithmic scale) between fmin 
%    and fmax, using cycles periods for the stacked signal 
%    and dfpar as the relative bandwidth for the filtering.
%
%    vert, north, east and time have to be data matrices 
%    (single or multiple stations) of equal sizes
%    proposed values: cycles = 10
%                     dfpar  = 0.2
%
%    Code developped by M. Hobiger, 
%    Laboratoire de Géophysique Interne et Tectonophysique,
%    Grenoble, France, 2008-10

v1=vert;n1=north;e1=east;t1=time;
if size(v1,2)>size(v1,1)
   v1=transpose(v1);
   n1=transpose(n1);
   e1=transpose(e1);
   t1=transpose(t1);
end

K=size(v1,1);
tau=t1(2)-t1(1);
DTmax=30;
fnyq=1/(2*tau);
fstart=max(fmin,1/DTmax);
fend=min(fmax,fnyq);
flist=zeros(fsteps,1);
constlog=(fend/fstart)^(1/(fsteps-1));
fl=fstart*constlog.^(cumsum(ones(fsteps,size(v1,2)))-1);
el=zeros(fsteps,size(v1,2));

for ind1=1:size(v1,2)
    vert=v1(:,ind1);
    north=n1(:,ind1);
    east=e1(:,ind1);
    time=t1(:,ind1);
    
    horizontalamp=zeros(fsteps,1);
    verticalamp=zeros(fsteps,1);
    horizontallist=zeros(fsteps,1);
    verticallist=zeros(fsteps,1);
    Tmax=max(time);
    thetas=zeros(fsteps,ceil(Tmax*fend));
    corr=zeros(fsteps,ceil(Tmax*fend));
    ampl=zeros(fsteps,ceil(Tmax*fend));
    dvmax=zeros(fsteps,1);

    for findex=1:1:fsteps
        f=fl(findex,ind1);
  
        df=dfpar*f;
        fmin=max(fstart,f-df/2);
        fmax=min(fnyq,f+df/2);
        flist(findex)=f;
        DT=cycles/f;
        wl=round(DT/tau);

        [na,wn]=cheb1ord([fmin+(fmax-fmin)/20,fmax-(fmax-fmin)/20]/fnyq,[fmin-(fmax-fmin)/20,fmax+(fmax-fmin)/20]/fnyq,1,5);
        [ch1,ch2]=cheby1(na,0.5,wn);

        norths=filter(ch1,ch2,north);
        easts=filter(ch1,ch2,east);
        verts=filter(ch1,ch2,vert);
        hsurv(findex)=sqrt((sum(norths.^2)+sum(easts.^2))/sum(verts.^2));

        derive=(sign(verts(2:K))-sign(verts(1:(K-1))))/2;

        vertsum=zeros(wl,1);
        horsum=zeros(wl,1);
        dvindex=0;

        for index=ceil(1/(4*f*tau)):1:length(derive)-wl
            if derive(index)==1
               dvindex=dvindex+1;
               vsig=verts(index:(index+wl-1));
               esig=easts(index-floor(1/(4*f*tau)):(index-floor(1/(4*f*tau))+wl-1));
               nsig=norths(index-floor(1/(4*f*tau)):(index-floor(1/(4*f*tau))+wl-1));
               integral1=sum(vsig.*esig);
               integral2=sum(vsig.*nsig);
               theta=atan(integral1/integral2);    
               if integral2<0
                  theta=theta+pi;
               end
               theta=mod(theta+pi,2*pi);  % The azimuth is well estimated
               hsig=sin(theta)*esig+cos(theta)*nsig; % In this way, the horizontal signal is projected in the azimuth direction, the correlation is always negative!
               correlation=sum(vsig.*hsig)/sqrt(sum(vsig.*vsig)*sum(hsig.*hsig));
               if correlation>=-1
                  vertsum=vertsum+correlation^2*vsig;
                  horsum=horsum+correlation^2*hsig;
               end
               thetas(findex,dvindex)=theta;
               correlationlist(index)=correlation;
               corr(findex,dvindex)=correlation;
               dvmax(findex)=dvindex;
               ampl(findex,dvindex)=sum(vsig.^2+hsig.^2);
            end
        end

        klimit=round(DT/tau);
        verticalamp(findex)=sqrt(sum(vertsum(1:klimit).^2));
        horizontalamp(findex)=sqrt(sum(horsum(1:klimit).^2));

    end
    ellist=horizontalamp./verticalamp;

    fl(:,ind1)=flist;
    el(:,ind1)=ellist;

end
V=fl;
W=el;
