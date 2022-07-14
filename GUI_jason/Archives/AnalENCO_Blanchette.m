function [ENCO,Velocity,dureecycle,deltaENCO,deltaVelocity,meanSIGNEDError,meanABSError,MaxPlantError,MaxDorsiError,meanSIGNEDErrorVelocity,meanABSErrorVelocity,MaxPlantErrorVelocity,MaxDorsiErrorVelocity,MaxPlantErrortiming] = AnalENCO_Blanchette( data,Cycle_Table )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

load('SyncData.mat');
load('CyclesCritiques.mat');

n=find(isnan(Cycle_Table(1,1,:))==1);
if n>0
    n=n(1)-1;
else
    n=30;
end


ENCO.baseline2(1:50,1:588,1:30)=nan;
ENCO.CHAMP(1:50,1:397,1:30)=nan;
ENCO.POST(1:50,1:290,1:30)=nan;

Velocity.baseline2(1:49,1:588,1:30)=nan;
Velocity.CHAMP(1:49,1:397,1:30)=nan;
Velocity.POST(1:49,1:290,1:30)=nan;

dureecycle.baseline2(1:588,1:30)=nan;
dureecycle.CHAMP(1:397,1:30)=nan;
dureecycle.POST(1:290,1:30)=nan;


deltaENCO.baseline2(1:50,1:588,1:30)=nan;
deltaENCO.CHAMP(1:50,1:397,1:30)=nan;
deltaENCO.POST(1:50,1:290,1:30)=nan;

deltaVelocity.baseline2(1:49,1:588,1:30)=nan;
deltaVelocity.CHAMP(1:49,1:397,1:30)=nan;
deltaVelocity.POST(1:49,1:290,1:30)=nan;

meanSIGNEDError.CHAMP(1:397,1:30)=nan;
meanSIGNEDError.POST(1:290,1:30)=nan;

meanABSError.CHAMP(1:397,1:30)=nan;
meanABSError.POST(1:290,1:30)=nan;

MaxPlantError.CHAMP(1:397,1:30)=nan;

MaxDorsiError.POST(1:290,1:30)=nan;

meanSIGNEDErrorVelocity.CHAMP(1:397,1:30)=nan;

meanABSErrorVelocity.CHAMP(1:397,1:30)=nan;

MaxPlantErrorVelocity.CHAMP(1:397,1:30)=nan;

MaxDorsiErrorVelocity.POST(1:290,1:30)=nan;

baseline2(1:50,1:30)=nan;
BASELINE2end(1:30)=nan;
CHAMPend(1:30)=nan;
POSTend(1:30)=nan;

for i=1:n
    i
    k=0;
    
    for j=1:FF1(i)-1
        k=k+1;
        
        if Cycle_Table(3,j,i)==1
            
            ENCO.baseline2(:,k,i)=data(:,j,i);
            dureecycle.baseline2(k,i)=Cycle_Table(2,j,i)-Cycle_Table(1,j,i);
            Velocity.baseline2(:,k,i)=diff(ENCO.baseline2(:,k,i));
            
        else
            ENCO.baseline2(:,k,i)=nan;
            dureecycle.baseline2(k,i)=nan;
            Velocity.baseline2(:,k,i)=nan;
            
        end
        cycleID.baseline2(k,i)=j;
        
        
    end
    BASELINE2end(i)=k;
    temp=find(isnan(ENCO.baseline2(1,:,i)')==0);
    baseline2(:,i)=mean(ENCO.baseline2(:,temp(end-99:end),i),2);
    velocitybaseline2(:,i)=mean(Velocity.baseline2(:,temp(end-99:end),i),2);
    clear temp
    
    k=0;
    
    for j=FF1(i):POST1(i)-1
        k=k+1;
        
        if Cycle_Table(3,j,i)==1
            
            ENCO.CHAMP(:,k,i)=data(:,j,i);
            dureecycle.CHAMP(k,i)=Cycle_Table(2,j,i)-Cycle_Table(1,j,i);
            Velocity.CHAMP(:,k,i)=diff(ENCO.baseline2(:,k,i));
            
        else
            ENCO.CHAMP(:,k,i)=nan;
            dureecycle.CHAMP(k,i)=nan;
            Velocity.CHAMP(:,k,i)=nan;
            
        end
        cycleID.CHAMP(k,i)=j;
        
        
    end
    
    CHAMPend(i)=k;
    
    k=0;
    
    for j=POST1(i):fin(i)-1
        k=k+1;
        
        if Cycle_Table(3,j,i)==1
            
            ENCO.POST(:,k,i)=data(:,j,i);
            dureecycle.POST(k,i)=Cycle_Table(2,j,i)-Cycle_Table(1,j,i);
            Velocity.POST(:,k,i)=diff(ENCO.baseline2(:,k,i));
            
        else
            ENCO.POST(:,k,i)=nan;
            dureecycle.POST(k,i)=nan;
            Velocity.POST(:,k,i)=nan;
            
        end
        cycleID.POST(k,i)=j;
        
        
    end
    
    POSTend(i)=k;
    
     
    
end

clear data GroupData

for i=1:n
    
    for j=1:size(ENCO.baseline2(:,:,i),2)
        
        deltaENCO.baseline2(:,j,i)=ENCO.baseline2(:,j,i)-baseline2(:,i);
        deltaVelocity.baseline2(:,j,i)=Velocity.baseline2(:,j,i)-velocitybaseline2(:,i);
    end
    
    for j=1:size(ENCO.CHAMP(:,:,i),2)
        deltaENCO.CHAMP(:,j,i)=ENCO.CHAMP(:,j,i)-baseline2(:,i);
        deltaVelocity.CHAMP(:,j,i)=Velocity.CHAMP(:,j,i)-velocitybaseline2(:,i);
    end
    
    for j=1:size(ENCO.POST(:,:,i),2)
        deltaENCO.POST(:,j,i)=ENCO.POST(:,j,i)-baseline2(:,i);
        deltaVelocity.POST(:,j,i)=Velocity.POST(:,j,i)-velocitybaseline2(:,i);
    end
end

for i=1:n
figure(1)
clf
plot(ENCO.baseline2(:,:,i),'b')
hold on
plot(ENCO.CHAMP(:,:,i),'r')
plot(ENCO.POST(:,:,i),'g')

title('Place cursor just before peak pushoff')
debut=ginput(1);
debut=round(debut(1));

for j=1:BASELINE2end(i)
    
    if isnan(deltaENCO.baseline2(1,j,i))==0
        
        
        peakDorsi.baseline2(j,i)=max(ENCO.baseline2(debut:end,j,i));
        peakPlant.baseline2(j,i)=min(ENCO.baseline2(debut:40,j,i));
        
        peakDorsiVelocity.baseline2(j,i)=max(Velocity.baseline2(30:end,j,i));
        peakPlantVelocity.baseline2(j,i)=min(Velocity.baseline2(20:40,j,i));
        
        
    else
        
        
        peakDorsi.baseline2(j,i)=nan;
        peakPlant.baseline2(j,i)=nan;
        
        peakDorsiVelocity.baseline2(j,i)=nan;
        peakPlantVelocity.baseline2(j,i)=nan;
        
        
    end
end

for j=1:CHAMPend(i)
    
    if isnan(deltaENCO.CHAMP(1,j,i))==0
        
        MaxPlantErrorVelocity.CHAMP(j,i)=min(deltaVelocity.CHAMP(30:end,j,i));
        
        MaxPlantError.CHAMP(j,i)=min(deltaENCO.CHAMP(30:end,j,i));
        
        temp=find(deltaENCO.CHAMP(30:end,j,i)==min(deltaENCO.CHAMP(30:end,j,i)));
        MaxPlantErrortiming.CHAMP(j,i)=temp(1)+29;
        
        
        meanABSError.CHAMP(j,i)=mean(abs(deltaENCO.CHAMP(30:end,j,i)));
        meanSIGNEDError.CHAMP(j,i)=mean(deltaENCO.CHAMP(30:end,j,i));
        
        meanABSErrorVelocity.CHAMP(j,i)=mean(abs(deltaVelocity.CHAMP(30:end,j,i)));
        meanSIGNEDErrorVelocity.CHAMP(j,i)=mean(deltaVelocity.CHAMP(30:end,j,i));
        
        
    else
        
        MaxPlantError.CHAMP(j,i)=nan;
        meanABSError.CHAMP(j,i)=nan;
        meanSIGNEDError.CHAMP(j,i)=nan;
        MaxPlantErrortiming.CHAMP(j,i)=nan;
        
        MaxPlantErrorVelocity.CHAMP(j,i)=nan;
        meanABSErrorVelocity.CHAMP(j,i)=nan;
        meanSIGNEDErrorVelocity.CHAMP(j,i)=nan;
    end
    
end

for j=1:POSTend(i)
    
    if isnan(deltaENCO.POST(1,j,i))==0
        
        MaxDorsiError.POST(j,i)=max(deltaENCO.POST(30:end,j,i));
        MaxDorsiErrorVelocity.POST(j,i)=max(deltaVelocity.POST(30:end,j,i));
        
        peakDorsi.POST(j,i)=max(ENCO.POST(debut:end,j,i));
        peakPlant.POST(j,i)=min(ENCO.POST(debut:40,j,i));
        
        peakDorsiVelocity.POST(j,i)=max(Velocity.POST(30:end,j,i));
        peakPlantVelocity.POST(j,i)=min(Velocity.POST(20:40,j,i));
        
    else
        
        peakDorsi.POST(j,i)=nan;
        peakPlant.POST(j,i)=nan;
        
        MaxDorsiError.POST(j,i)=nan;
        MaxDorsiErrorVelocity.POST(j,i)=nan;
        
        peakDorsiVelocity.POST(j,i)=nan;
        peakPlantVelocity.POST(j,i)=nan;
        
    end
end
end



