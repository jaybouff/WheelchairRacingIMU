% %% Enligner par rapport au crossing du ginput
% clear GroupData
% [filename,pathname]=uigetfile('*.mat','Sélectionnez votre fichier de groupe COUPLE')
function [CONS_F, cycleID, BASELINE2end, CHAMPend, POSTend,PeakCONS_F]=CONS_Fvariablesgenerator(Cycle_Table,data)

n=find(isnan(Cycle_Table(1,1,:))==1);
if n>0
    n=n(1)-1;
else
    n=30
end

load('SyncData.mat');
load('CyclesCritiques.mat');



%% Generate deltaCOUPLE curves
CONS_F.baseline2(1:1000,1:588,1:30)=nan;
CONS_F.CHAMP(1:1000,1:397,1:30)=nan;
CONS_F.POST(1:1000,1:290,1:30)=nan;

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
                CONS_F.baseline2(:,k,i)=temp(1:1000,1);
                
            else
                
                CONS_F.baseline2(1:size(temp,1),k,i)=temp;
                
            end
            
            tempstop=find(isnan(CONS_F.baseline2(:,k,i))==1);
            if tempstop>0
                tempstop=tempstop(1);
            else
                tempstop=1000;
            end

        else
            CONS_F.baseline2(:,k,i)=nan;
          
        end
        
    end
    
    BASELINE2end(i)=k;
    
    clear temp
    
    
    
    
    
    k=0;
    
    for j=FF1(i):POST1(i)-1
        
        k=k+1;
        if Cycle_Table(3,j,i)==1 & SyncTiming(i,j)<1000 & Cycle_Table(4,j,i)==0 & SyncTiming(i,j)>500
            
            temp=data(SyncTiming(i,j)-150:end,j,i);
            
            if size(temp,1)>1000
                CONS_F.CHAMP(:,k,i)=temp(1:1000,1);
                
            else
                
                CONS_F.CHAMP(1:size(temp,1),k,i)=temp;
                
            end
            
            tempstop=find(isnan(CONS_F.CHAMP(:,k,i))==1);
            if tempstop>0
                tempstop=tempstop(1);
            else
                tempstop=1000;
            end
            
        else
            CONS_F.CHAMP(:,k,i)=nan;
        end
        
        cycleID.CHAMP(k,i)=j;

    end
    
    CHAMPend(i)=k;
    
    k=0;
    for j=POST1(i):fin(i)-1
        k=k+1;
        
        if Cycle_Table(3,j,i)==1 & SyncTiming(i,j)<1000 & Cycle_Table(4,j,i)==0 & SyncTiming(i,j)>500
            
            temp=data(SyncTiming(i,j)-150:end,j,i);
            
            if size(temp,1)>1000
                CONS_F.POST(:,k,i)=temp(1:1000,1);
                
            else
                
                CONS_F.POST(1:size(temp,1),k,i)=temp;
                
            end
            
            tempstop=find(isnan(CONS_F.POST(:,k,i))==1);
            
            if tempstop>0
                tempstop=tempstop(1);
            else
                tempstop=1000;
            end
            
        else
            CONS_F.POST(:,k,i)=nan;
                    
        end
        
        cycleID.POST(k,i)=j;

        
        
    end
    
    POSTend(i)=k;
    
end

    
clear data GroupData Cycle_Table


PeakCONS_F.CHAMP(1:340,1:30)=nan;
PeakCONS_Ftiming.CHAMP(1:340,1:30)=nan;

for i=1:n
    
    
      
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%CHAMP
    for j=1:CHAMPend(i)
        
        if isnan(CONS_F.CHAMP(1,j,i))==0
            
            tempstop=find(isnan(deltaCOUPLE.CHAMP(:,j,i))==1);
            tempstop=tempstop(1);
            PeakCONS_F.CHAMP(j,i)=min(CONS_F.CHAMP(150:tempstop(1)-1,j,i));
            %temptiming=find(deltaCOUPLE.CHAMP(150:tempstop(1)-1,j,i)==min(deltaCOUPLE.CHAMP(150:tempstop(1)-1,j,i)));
            %PeakCOUPLEtiming.CHAMP(j,i)=(temptiming(1)+SyncTiming(i,cycleID.CHAMP(j,i)))/dureecycle(i,cycleID.CHAMP(j,i))*100;   
            
                             
        end
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%POST
          
end
