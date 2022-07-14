function [ENCO, baseline1, cycleID, BASELINE1end, BASELINE2end, deltaBaseline, absBaseError]=BaselineAnkle(Cycle_Table,data)
% %% Enligner par rapport au crossing du ginput
% clear GroupData
% [filename,pathname]=uigetfile('*.mat','Sélectionnez votre fichier de groupe ENCO')


[filename,pathname]=uigetfile('*.mat','Sélectionnez votre fichier AnalENCO')
load([pathname,filename],'ENCO','BASELINE2end','cycleID')

load('SyncData.mat');
load('CyclesCritiques.mat');

n=find(isnan(Cycle_Table(1,1,:))==1);
if n>0
    n=n(1)-1;
else
    n=30
end


deltaBaseline(1:1000,1:580,1:30)=nan;
baseline1(1:1000,1:30)=nan;
absBaseError(1:580,1:30)=nan;
ENCO.baseline1(1:1000,1:580,1:30)=nan;
 dureeswing.baseline1(1:580,1:30)=nan;

for i=1:n
    
    k=0;
    
    for j=1:fin(i)-1
         k=k+1;
        if Cycle_Table(3,j,i)==1 & SyncTiming(i,j)<1000 & SyncTiming(i,j)>500
           
            temp=data(SyncTiming(i,j)-150:end,j,i);
            
            if size(temp,1)>1000
                ENCO.baseline1(:,k,i)=temp(1:1000,1);
                
            else
                
                ENCO.baseline1(1:size(temp,1),k,i)=temp;
                
            end
            
             tempstop=find(isnan(ENCO.baseline1(:,k,i))==1);
            if tempstop>0
                tempstop=tempstop(1);
            else
                tempstop=1000;
            end
            
            dureeswing.baseline1(k,i)=tempstop-150;
        else
            
            ENCO.baseline1(:,k,i)=nan;
            dureeswing.baseline1(k,i)=nan;
            
        end
            
            cycleID.baseline1(k,i)=j;
        end
        
    



BASELINE1end(i)=k;

temp=find(isnan(ENCO.baseline1(1,:,i)')==0);
    temp=find(isnan(ENCO.baseline1(1,:,i)')==0 & dureeswing.baseline1(:,i)>mean(dureeswing.baseline1(temp,i))-std(dureeswing.baseline1(temp,i)));
    baseline1(:,i)=mean(ENCO.baseline1(1:1000,temp(end-99:end),i),2);
clear temp

end

for i=1:n
    
    for j=1:size(ENCO.baseline2(:,:,i),2)
        
        deltaBaseline(:,j,i)=ENCO.baseline2(:,j,i)-baseline1(:,i);
    end
    
    
end


for i=1:n
    
    for j=1:BASELINE2end(i)
        ID=cycleID.baseline2(j,i);
        
        tempstop=find(isnan(deltaBaseline(:,j,i))==1);
        tempstop=tempstop(1);
        absBaseError(j,i)=mean(abs(deltaBaseline(150:tempstop(1)-1,j,i)));
        
    end
    
    clear ENCO.CHAMP ENCO.POST cycleID.CHAMP cycleID.POST
end
