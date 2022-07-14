% %% Enligner par rapport au crossing du ginput
% clear GroupData
% [filename,pathname]=uigetfile('*.mat','Sélectionnez votre fichier de groupe COUPLE')
function [COUPLE, baseline2, cycleID, BASELINE2end, CHAMPend, POSTend,deltaCOUPLE,meanabsCOUPLE, PeakCOUPLE]=COUPLEvariablesgenerator(Cycle_Table,data)

n=find(isnan(Cycle_Table(1,1,:))==1);
if n>0
    n=n(1)-1;
else
    n=30
end

load('SyncData.mat');
load('CyclesCritiques.mat');



%% Generate deltaCOUPLE curves
COUPLE.baseline2(1:1000,1:588,1:30)=nan;
COUPLE.CHAMP(1:1000,1:397,1:30)=nan;
COUPLE.POST(1:1000,1:290,1:30)=nan;

dureeswing.baseline2(1:588,1:30)=nan;
dureeswing.CHAMP(1:397,1:30)=nan;
dureeswing.POST(1:290,1:30)=nan;

deltaCOUPLE.baseline2(1:1000,1:588,1:30)=nan;
deltaCOUPLE.CHAMP(1:1000,1:397,1:30)=nan;
deltaCOUPLE.POST(1:1000,1:290,1:30)=nan;

cycleID.baseline2(1:588,1:30)=nan;
cycleID.CHAMP(1:397,1:30)=nan;
cycleID.POST(1:290,1:30)=nan;

baseline2(1:1000,1:30)=nan;
BASELINE2end(1:30)=nan;
CHAMPend(1:30)=nan;
POSTend(1:30)=nan;

for i=1:n
    i
    k=0;
    
    for j=1:FF1(i)-1
        k=k+1;
        if Cycle_Table(3,j,i)==1 & SyncTiming(i,j)<1000 & Cycle_Table(4,j,i)==0 & SyncTiming(i,j)>500
            
            temp=data(SyncTiming(i,j)-150:end,j,i);
            
            if size(temp,1)>1000
                COUPLE.baseline2(:,k,i)=temp(1:1000,1);
                
            else
                
                COUPLE.baseline2(1:size(temp,1),k,i)=temp;
                
            end
            
            tempstop=find(isnan(COUPLE.baseline2(:,k,i))==1);
            if tempstop>0
                tempstop=tempstop(1);
            else
                tempstop=1000;
            end
            
            dureeswing.baseline2(k,i)=tempstop-150;
        else
            COUPLE.baseline2(:,k,i)=nan;
            dureeswing.baseline2(k,i)=nan;
            
        end
        cycleID.baseline2(k,i)=j;
        dureecycle(j,i)=Cycle_Table(2,j,i)-Cycle_Table(1,j,i);
        
    end
    
    BASELINE2end(i)=k;
    temp=find(isnan(COUPLE.baseline2(1,:,i)')==0);
    temp=find(isnan(COUPLE.baseline2(1,:,i)')==0 & dureeswing.baseline2(:,i)>mean(dureeswing.baseline2(temp,i))-std(dureeswing.baseline2(temp,i)));
    baseline2(:,i)=mean(COUPLE.baseline2(1:1000,temp(end-99:end),i),2);
    clear temp
    
    
    
    
    
    k=0;
    
    for j=FF1(i):POST1(i)-1
        
        k=k+1;
        if Cycle_Table(3,j,i)==1 & SyncTiming(i,j)<1000 & Cycle_Table(4,j,i)==0 & SyncTiming(i,j)>500
            
            temp=data(SyncTiming(i,j)-150:end,j,i);
            
            if size(temp,1)>1000
                COUPLE.CHAMP(:,k,i)=temp(1:1000,1);
                
            else
                
                COUPLE.CHAMP(1:size(temp,1),k,i)=temp;
                
            end
            
            tempstop=find(isnan(COUPLE.CHAMP(:,k,i))==1);
            if tempstop>0
                tempstop=tempstop(1);
            else
                tempstop=1000;
            end
            
            dureeswing.CHAMP(k,i)=tempstop-150;
            
        else
            COUPLE.CHAMP(:,k,i)=nan;
            dureeswing.CHAMP(k,i)=nan;
        end
        
        
        cycleID.CHAMP(k,i)=j;
        dureecycle(j,i)=Cycle_Table(2,j,i)-Cycle_Table(1,j,i);
        
    end
    
    CHAMPend(i)=k;
    
    k=0;
    for j=POST1(i):fin(i)-1
        k=k+1;
        
        if Cycle_Table(3,j,i)==1 & SyncTiming(i,j)<1000 & Cycle_Table(4,j,i)==0 & SyncTiming(i,j)>500
            
            temp=data(SyncTiming(i,j)-150:end,j,i);
            
            if size(temp,1)>1000
                COUPLE.POST(:,k,i)=temp(1:1000,1);
                
            else
                
                COUPLE.POST(1:size(temp,1),k,i)=temp;
                
            end
            
            tempstop=find(isnan(COUPLE.POST(:,k,i))==1);
            
            if tempstop>0
                tempstop=tempstop(1);
            else
                tempstop=1000;
            end
            dureeswing.POST(k,i)=tempstop-150;
            
        else
            COUPLE.POST(:,k,i)=nan;
            dureeswing.POST(k,i)=nan;
            %
            
        end
        
        cycleID.POST(k,i)=j;
        dureecycle(j,i)=Cycle_Table(2,j,i)-Cycle_Table(1,j,i);
        
        
        
    end
    
    POSTend(i)=k;
    
end

    
clear data GroupData Cycle_Table
for i=1:n
    
    for j=1:size(COUPLE.baseline2(:,:,i),2)
        
        deltaCOUPLE.baseline2(:,j,i)=COUPLE.baseline2(:,j,i)-baseline2(:,i);
    end
    
    for j=1:size(COUPLE.CHAMP(:,:,i),2)
        deltaCOUPLE.CHAMP(:,j,i)=COUPLE.CHAMP(:,j,i)-baseline2(:,i);
    end
    
    for j=1:size(COUPLE.POST(:,:,i),2)
        deltaCOUPLE.POST(:,j,i)=COUPLE.POST(:,j,i)-baseline2(:,i);
    end
end


%% Kinematic errors


meanabsCOUPLE.baseline2(1:580,1:30)=nan;
meanabsCOUPLE.CHAMP(1:340,1:30)=nan;
meanabsCOUPLE.POST(1:290,1:30)=nan;

PeakCOUPLE.CHAMP(1:340,1:30)=nan;
PeakCOUPLEtiming.CHAMP(1:340,1:30)=nan;

for i=1:n
    
    
    for j=1:BASELINE2end(i)
        
        if isnan(deltaCOUPLE.baseline2(1,j,i))==0
            
            tempstop=find(isnan(deltaCOUPLE.baseline2(:,j,i))==1);
            tempstop=tempstop(1);
            meanabsCOUPLE.baseline2(j,i)=mean(abs(COUPLE.baseline2(150:tempstop(1)-1,j,i)));
            
           
            
        else
            
            meanabsCOUPLE.baseline2(j,i)=nan;
                        
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%CHAMP
    for j=1:CHAMPend(i)
        
        if isnan(deltaCOUPLE.CHAMP(1,j,i))==0
            
            tempstop=find(isnan(deltaCOUPLE.CHAMP(:,j,i))==1);
            tempstop=tempstop(1);
            meanabsCOUPLE.CHAMP(j,i)=mean(abs(COUPLE.CHAMP(150:tempstop(1)-1,j,i)));
            PeakCOUPLE.CHAMP(j,i)=min(deltaCOUPLE.CHAMP(150:tempstop(1)-1,j,i));
            %temptiming=find(deltaCOUPLE.CHAMP(150:tempstop(1)-1,j,i)==min(deltaCOUPLE.CHAMP(150:tempstop(1)-1,j,i)));
            %PeakCOUPLEtiming.CHAMP(j,i)=(temptiming(1)+SyncTiming(i,cycleID.CHAMP(j,i)))/dureecycle(i,cycleID.CHAMP(j,i))*100;   
            
        else
            
            meanabsCOUPLE.CHAMP(j,i)=nan;
            PeakCOUPLE.CHAMP(j,i)=nan;
            PeakCOUPLEtiming.CHAMP(j,i)=nan;
                        
        end
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%POST
    for j=1:POSTend(i)
        
        if isnan(deltaCOUPLE.POST(1,j,i))==0
            
            tempstop=find(isnan(deltaCOUPLE.POST(:,j,i))==1);
            tempstop=tempstop(1);
            meanabsCOUPLE.POST(j,i)=mean(abs(COUPLE.POST(150:tempstop(1)-1,j,i)));
            
           
            
        else
            
            meanabsCOUPLE.POST(j,i)=nan;
                        
        end
        
    end




    
end
