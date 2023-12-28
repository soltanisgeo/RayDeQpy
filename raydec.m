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
end                      %to check that dataformat is correct

K=size(v1,1);            %length component verticaL (TIME STEP)
tau=t1(2)-t1(1);         % dt 
DTmax=30;
fnyq=1/(2*tau);
fstart=max(fmin,1/DTmax);   % to check the fmin and fmax is correct value ir not
fend=min(fmax,fnyq);
flist=zeros(fsteps,1);      % vector fstep , mohasebat dar har frequncy 
constlog=(fend/fstart)^(1/(fsteps-1));   % tarif adad logarithmi ke dar fstart zarb mishe va nahayatan dar khate baadi soton frequency ellipticity ro misaze
fl=fstart*constlog.^(cumsum(ones(fsteps,size(v1,2)))-1);  %create the frequncy vector
el=zeros(fsteps,size(v1,2));                              %create the ellipticity value vector (empty for the moment)

for ind1=1:size(v1,2)           % halghe roye kole size v1
    vert=v1(:,ind1);            % vert = v1 be nazaram faghat copy karde va hamone
    north=n1(:,ind1);
    east=e1(:,ind1);
    time=t1(:,ind1);
    
    horizontalamp=zeros(fsteps,1);    %vector khali ke gharar hast maghadir mokhtalef hamp theta va gheire toosh save beshe
    verticalamp=zeros(fsteps,1);
    horizontallist=zeros(fsteps,1);
    verticallist=zeros(fsteps,1);
    Tmax=max(time);
    thetas=zeros(fsteps,ceil(Tmax*fend));
    corr=zeros(fsteps,ceil(Tmax*fend));
    ampl=zeros(fsteps,ceil(Tmax*fend));
    dvmax=zeros(fsteps,1);

    for findex=1:1:fsteps      % shoro mohasebat , halghe roye fstep (=50) yani 50 bar anjam mide baraye har central frequncy 
        f=fl(findex,ind1);     % f = central frequency ke mohasebe roosh anjam mishe 
  
        df=dfpar*f;            % bandwitdth filtering data
        fmin=max(fstart,f-df/2);  % AZ ro mesal behet migham
        fmax=min(fnyq,f+df/2);    % AZ ro mesal behet migham
        flist(findex)=f;          % AZ ro mesal behet migham
        DT=cycles/f;              % AZ ro mesal behet migham
        wl=round(DT/tau);         % AZ ro mesal behet migham

        [na,wn]=cheb1ord([fmin+(fmax-fmin)/20,fmax-(fmax-fmin)/20]/fnyq,[fmin-(fmax-fmin)/20,fmax+(fmax-fmin)/20]/fnyq,1,5);
        [ch1,ch2]=cheby1(na,0.5,wn);     % taabe filter

        norths=filter(ch1,ch2,north);     % emal filter
        easts=filter(ch1,ch2,east);        % emal filter
        verts=filter(ch1,ch2,vert);        % emal filter
        hsurv(findex)=sqrt((sum(norths.^2)+sum(easts.^2))/sum(verts.^2));   ???????

        derive=(sign(verts(2:K))-sign(verts(1:(K-1))))/2;       % peyda kardan taghir alamatha

        vertsum=zeros(wl,1);               % define vectori ke sample segment haye shenasaei shode ro barhasb wl ke khodesh as DT ke khodesh az cycle bedast omade zakhire mikone  
        horsum=zeros(wl,1);
        dvindex=0;

        for index=ceil(1/(4*f*tau)):1:length(derive)-wl  % be nazaram miad pi dovvom ekhtelaf faz ro hesab mikone
            if derive(index)==1                          % be nazaram bad inja mige noghte taghir bod boro ye index jelotar
               dvindex=dvindex+1;
               vsig=verts(index:(index+wl-1))                                            % sakht signal ha
               esig=easts(index-floor(1/(4*f*tau)):(index-floor(1/(4*f*tau))+wl-1));    % sakht signal ha
               nsig=norths(index-floor(1/(4*f*tau)):(index-floor(1/(4*f*tau))+wl-1));    % sakht signal ha (formule 1 paper)
               integral1=sum(vsig.*esig);
               integral2=sum(vsig.*nsig);
               theta=atan(integral1/integral2);                % sakht formule 4 paper, zaveye ke corr ro maximize mikone
               if integral2<0
                  theta=theta+pi;
               end
               theta=mod(theta+pi,2*pi);  % The azimuth is well estimated
               hsig=sin(theta)*esig+cos(theta)*nsig;   % sakht signal H az e va n, formule 2 paper
               correlation=sum(vsig.*hsig)/sqrt(sum(vsig.*vsig)*sum(hsig.*hsig));     % sakht formule 5
               if correlation>=-1
                  vertsum=vertsum+correlation^2*vsig;       % sakht formule 6
                  horsum=horsum+correlation^2*hsig;         % sakht formule 6
               end
               thetas(findex,dvindex)=theta;         % theta nahaei
               correlationlist(index)=correlation;   % correlation nahaei
               corr(findex,dvindex)=correlation;
               dvmax(findex)=dvindex;      ??
               ampl(findex,dvindex)=sum(vsig.^2+hsig.^2);   ???
            end
        end

        klimit=round(DT/tau);    %sampling
        verticalamp(findex)=sqrt(sum(vertsum(1:klimit).^2));       %moalefe amodi
        horizontalamp(findex)=sqrt(sum(horsum(1:klimit).^2));       %moalefe ofoghi

    end
    ellist=horizontalamp./verticalamp;        % sakht formule 7

    fl(:,ind1)=flist;
    el(:,ind1)=ellist;

end
V=fl;
W=el;
