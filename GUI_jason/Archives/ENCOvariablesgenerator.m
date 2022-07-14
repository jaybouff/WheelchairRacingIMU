function [ENCO, baseline2, cycleID, BASELINE2end, CHAMPend, POSTend,deltaENCO,MaxDorsiError, MaxPlantError, meanABSError, meanSIGNEDError, meanUndershoot, percentUndershoot meanOvershoot, percentOvershoot, dureeswing, peakDorsi, peakPlant, MaxDorsiErrortiming, MaxPlantErrortiming, peakDorsitiming, peakPlanttiming, dureecycle, Velocity, deltaVelocity, velocitybaseline2, peakDorsiVelocity, peakPlantVelocity,MaxDorsiErrorVelocity, MaxPlantErrorVelocity, meanABSErrorVelocity, meanSIGNEDErrorVelocity]=ENCOvariablesgenerator(Cycle_Table,data)

n=find(isnan(Cycle_Table(1,1,:))==1);
if n>0
    n=n(1)-1;
else
    n=30
end

load('SyncData.mat');
load('CyclesCritiques.mat');

question=menu('Avez-vous déjà un fichier AnalENCO?','oui','non');

if question==2

figure(1)
ENCO.baseline2(1:1000,1:588,1:30)=nan;
ENCO.CHAMP(1:1000,1:397,1:30)=nan;
ENCO.POST(1:1000,1:290,1:30)=nan;

Velocity.baseline2(1:1000,1:588,1:30)=nan;
Velocity.CHAMP(1:1000,1:397,1:30)=nan;
Velocity.POST(1:1000,1:290,1:30)=nan;

dureeswing.baseline2(1:588,1:30)=nan;
dureeswing.CHAMP(1:397,1:30)=nan;
dureeswing.POST(1:290,1:30)=nan;

dureecycle.baseline2(1:588,1:30)=nan;
dureecycle.CHAMP(1:397,1:30)=nan;
dureecycle.POST(1:290,1:30)=nan;

deltaENCO.baseline2(1:1000,1:588,1:30)=nan;
deltaENCO.CHAMP(1:1000,1:397,1:30)=nan;
deltaENCO.POST(1:1000,1:290,1:30)=nan;

deltaVelocity.baseline2(1:1000,1:588,1:30)=nan;
deltaVelocity.CHAMP(1:1000,1:397,1:30)=nan;
deltaVelocity.POST(1:1000,1:290,1:30)=nan;

cycleID.baseline2(1:588,1:30)=nan;
cycleID.CHAMP(1:397,1:30)=nan;
cycleID.POST(1:290,1:30)=nan;

baseline2(1:1000,1:30)=nan;
BASELINE2end(1:30)=nan;
CHAMPend(1:30)=nan;
POSTend(1:30)=nan;

meanUndershoot.baseline2(1:588,1:30)=nan;
meanUndershoot.CHAMP(1:397,1:30)=nan;
meanUndershoot.POST(1:290,1:30)=nan;

percentUndershoot.baseline2(1:588,1:30)=nan;
percentUndershoot.CHAMP(1:397,1:30)=nan;
percentUndershoot.POST(1:290,1:30)=nan;

meanOvershoot.baseline2(1:588,1:30)=nan;
meanOvershoot.CHAMP(1:397,1:30)=nan;
meanOvershoot.POST(1:290,1:30)=nan;

percentOvershoot.baseline2(1:588,1:30)=nan;
percentOvershoot.CHAMP(1:397,1:30)=nan;
percentOvershoot.POST(1:290,1:30)=nan;

meanSIGNEDError.baseline2(1:588,1:30)=nan;
meanSIGNEDError.CHAMP(1:397,1:30)=nan;
meanSIGNEDError.POST(1:290,1:30)=nan;

meanABSError.baseline2(1:588,1:30)=nan;
meanABSError.CHAMP(1:397,1:30)=nan;
meanABSError.POST(1:290,1:30)=nan;

MaxPlantError.baseline2(1:588,1:30)=nan;
MaxPlantError.CHAMP(1:397,1:30)=nan;

MaxDorsiError.baseline2(1:588,1:30)=nan;
MaxDorsiError.POST(1:290,1:30)=nan;



meanSIGNEDErrorVelocity.baseline2(1:588,1:30)=nan;
meanSIGNEDErrorVelocity.CHAMP(1:397,1:30)=nan;
meanSIGNEDErrorVelocity.POST(1:290,1:30)=nan;

meanABSErrorVelocity.baseline2(1:588,1:30)=nan;
meanABSErrorVelocity.CHAMP(1:397,1:30)=nan;
meanABSErrorVelocity.POST(1:290,1:30)=nan;

MaxPlantErrorVelocity.baseline2(1:588,1:30)=nan;
MaxPlantErrorVelocity.CHAMP(1:397,1:30)=nan;

MaxDorsiErrorVelocity.baseline2(1:588,1:30)=nan;
MaxDorsiErrorVelocity.POST(1:290,1:30)=nan;

x=1;

elseif question==1
    load('AnalENCO.mat')
    temp=find(isnan(BASELINE2end)==1);
    x=temp(1);
end

for i=x:n
    i
    k=0;
    
    for j=1:FF1(i)-1
        k=k+1;
        if Cycle_Table(3,j,i)==1 & SyncTiming(i,j)<1000 & Cycle_Table(4,j,i)==0 & SyncTiming(i,j)>500
            
            temp=data(SyncTiming(i,j)-150:end,j,i);
            
            if size(temp,1)>1000
                ENCO.baseline2(:,k,i)=temp(1:1000,1);
               
            else
                
                ENCO.baseline2(1:size(temp,1),k,i)=temp;
                
                
            end
            
            tempstop=find(isnan(ENCO.baseline2(:,k,i))==1);
            if tempstop>0
                tempstop=tempstop(1);
            else
                tempstop=1000;
            end
            dureecycle.baseline2(k,i)=Cycle_Table(2,j,i)-Cycle_Table(1,j,i);
            dureeswing.baseline2(k,i)=tempstop-150;
            
            Velocity.baseline2(1:tempstop-1,k,i)=diff(ENCO.baseline2(1:tempstop,k,i))*1000;
        else
            ENCO.baseline2(:,k,i)=nan;
            dureeswing.baseline2(k,i)=nan;
            dureecycle.baseline2(k,i)=nan;
            Velocity.baseline2(:,k,i)=nan;
            
        end
        cycleID.baseline2(k,i)=j;
        
        
    end
    BASELINE2end(i)=k;
    temp=find(isnan(ENCO.baseline2(1,:,i)')==0);
    temp=find(isnan(ENCO.baseline2(1,:,i)')==0 & dureeswing.baseline2(:,i)>mean(dureeswing.baseline2(temp,i))-std(dureeswing.baseline2(temp,i)));
    baseline2(:,i)=mean(ENCO.baseline2(1:1000,temp(end-99:end),i),2);
    velocitybaseline2(:,i)=mean(Velocity.baseline2(1:1000,temp(end-99:end),i),2);
    clear temp
    
    
    
    
    
    k=0;
    
    for j=FF1(i):POST1(i)-1
        
        k=k+1;
        if Cycle_Table(3,j,i)==1 & SyncTiming(i,j)<1000 & Cycle_Table(4,j,i)==0 & SyncTiming(i,j)>500
            
            temp=data(SyncTiming(i,j)-150:end,j,i);
            
            if size(temp,1)>1000
                ENCO.CHAMP(:,k,i)=temp(1:1000,1);
                
            else
                
                ENCO.CHAMP(1:size(temp,1),k,i)=temp;
                
            end
            
            tempstop=find(isnan(ENCO.CHAMP(:,k,i))==1);
            if tempstop>0
                tempstop=tempstop(1);
            else
                tempstop=1000;
            end
            
            dureecycle.CHAMP(k,i)=Cycle_Table(2,j,i)-Cycle_Table(1,j,i);
            dureeswing.CHAMP(k,i)=tempstop-150;
            
            Velocity.CHAMP(1:1:tempstop-1,k,i)=diff(ENCO.CHAMP(1:tempstop,k,i))*1000;
            
        else
            ENCO.CHAMP(:,k,i)=nan;
            dureeswing.CHAMP(k,i)=nan;
            dureecycle.CHAMP(k,i)=nan;
            
            Velocity.CHAMP(:,k,i)=nan;
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
                ENCO.POST(:,k,i)=temp(1:1000,1);
                
            else
                
                ENCO.POST(1:size(temp,1),k,i)=temp;
                
            end
            
            tempstop=find(isnan(ENCO.POST(:,k,i))==1);
            
            if tempstop>0
                tempstop=tempstop(1);
            else
                tempstop=1000;
            end
            
            dureecycle.POST(k,i)=Cycle_Table(2,j,i)-Cycle_Table(1,j,i);
            dureeswing.POST(k,i)=tempstop-150;
            
            Velocity.POST(1:tempstop-1,k,i)=diff(ENCO.POST(1:tempstop,k,i))*1000;
            
        else
            ENCO.POST(:,k,i)=nan;
            dureeswing.POST(k,i)=nan;
            dureecycle.POST(k,i)=nan;
            
            Velocity.POST(:,k,i)=nan;
            %
            
        end
        
        cycleID.POST(k,i)=j;
        
        
        
    end
    
    POSTend(i)=k;
    
end

clear data GroupData Cycle_Table
for i=x:n
    
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

for i=x:n
%     clf
%     plot(baseline2(:,i),'b')
%     temp=ginput(1);
%     debut(i)=round(temp(1));
%     
%     tempstop=find(isnan(baseline2(:,i))==1);
%     tempstop=tempstop(1);
%     ROMswing(i)=max(baseline2(debut(i):tempstop-1,i))-min(baseline2(debut(i):tempstop-1,i));
    
    for j=1:BASELINE2end(i)
        
        if isnan(deltaENCO.baseline2(1,j,i))==0
            
            tempstop=find(isnan(deltaENCO.baseline2(:,j,i))==1);
            tempstop=tempstop(1);
            MaxDorsiError.baseline2(j,i)=max(deltaENCO.baseline2(250:tempstop(1)-1,j,i));
            MaxPlantError.baseline2(j,i)=min(deltaENCO.baseline2(150:tempstop(1)-1,j,i));
            peakDorsi.baseline2(j,i)=max(ENCO.baseline2(250:tempstop(1)-1,j,i));
            peakPlant.baseline2(j,i)=min(ENCO.baseline2(150:tempstop(1)-100,j,i));
            
            MaxDorsiErrorVelocity.baseline2(j,i)=max(deltaVelocity.baseline2(250:tempstop(1)-2,j,i));
            MaxPlantErrorVelocity.baseline2(j,i)=min(deltaVelocity.baseline2(150:tempstop(1)-2,j,i));
            peakDorsiVelocity.baseline2(j,i)=max(Velocity.baseline2(250:tempstop(1)-2,j,i));
            peakPlantVelocity.baseline2(j,i)=min(Velocity.baseline2(150:tempstop(1)-101,j,i));
            
            temp=find(deltaENCO.baseline2(250:tempstop(1)-1,j,i)==max(deltaENCO.baseline2(250:tempstop(1)-1,j,i)));
            MaxDorsiErrortiming.baseline2(j,i)=temp(1)+249;
            
            temp=find(deltaENCO.baseline2(150:tempstop(1)-1,j,i)==min(deltaENCO.baseline2(150:tempstop(1)-1,j,i)));
            MaxPlantErrortiming.baseline2(j,i)=temp(1)+149;
            
            temp=find(ENCO.baseline2(250:tempstop(1)-1,j,i)==max(ENCO.baseline2(250:tempstop(1)-1,j,i)));
            peakDorsitiming.baseline2(j,i)=temp(1)+249;
            
            temp=find(ENCO.baseline2(150:tempstop(1)-1,j,i)==min(ENCO.baseline2(150:tempstop(1)-1,j,i)));
            peakPlanttiming.baseline2(j,i)=temp(1)+149;
            
            meanABSError.baseline2(j,i)=mean(abs(deltaENCO.baseline2(150:tempstop(1)-1,j,i)));
            meanSIGNEDError.baseline2(j,i)=mean(deltaENCO.baseline2(150:tempstop(1)-1,j,i));
            
            meanABSErrorVelocity.baseline2(j,i)=mean(abs(deltaVelocity.baseline2(150:tempstop(1)-2,j,i)));
            meanSIGNEDErrorVelocity.baseline2(j,i)=mean(deltaVelocity.baseline2(150:tempstop(1)-2,j,i));
            
            u=0;
            o=0;
            tempUNDER=[];
            tempOVER=[];
            
            for k=150:tempstop
                if deltaENCO.baseline2(k,j,i)<0;
                    u=u+1;
                    tempUNDER(u)=k;
                    
                elseif deltaENCO.baseline2(k,j,i)>0;
                    o=o+1;
                    tempOVER(o)=k;
                end
                
            end
            
            if length(tempUNDER)>0
                meanUndershoot.baseline2(j,i)=sum(abs(deltaENCO.baseline2(tempUNDER,j,i)))/(tempstop-150);
            else
                meanUndershoot.baseline2(j,i)=0;
            end
            
            if length(tempOVER)>0
                meanOvershoot.baseline2(j,i)=sum(abs(deltaENCO.baseline2(tempOVER,j,i)))/(tempstop-150);
            else
                meanOvershoot.baseline2(j,i)=0;
            end
            
            percentOvershoot.baseline2(j,i)=meanOvershoot.baseline2(j,i)/meanABSError.baseline2(j,i)*100;
            percentUndershoot.baseline2(j,i)=meanUndershoot.baseline2(j,i)/meanABSError.baseline2(j,i)*100;
            
            
            tempUNDER=[];
            tempOVER=[];
            
        else
            
            MaxDorsiError.baseline2(j,i)=nan;
            MaxPlantError.baseline2(j,i)=nan;
            peakDorsi.baseline2(j,i)=nan;
            peakPlant.baseline2(j,i)=nan;
            MaxDorsiErrortiming.baseline2(j,i)=nan;
            MaxPlantErrortiming.baseline2(j,i)=nan;
            peakDorsitiming.baseline2(j,i)=nan;
            peakPlanttiming.baseline2(j,i)=nan;
            meanABSError.baseline2(j,i)=nan;
            meanSIGNEDError.baseline2(j,i)=nan;
            meanUndershoot.baseline2(j,i)=nan;
            meanOvershoot.baseline2(j,i)=nan;
            percentOvershoot.baseline2(j,i)=nan;
            percentUndershoot.baseline2(j,i)=nan;
            MaxDorsiErrorVelocity.baseline2(j,i)=nan;
            MaxPlantErrorVelocity.baseline2(j,i)=nan;
            peakDorsiVelocity.baseline2(j,i)=nan;
            peakPlantVelocity.baseline2(j,i)=nan;
            meanABSErrorVelocity.baseline2(j,i)=nan;
            meanSIGNEDErrorVelocity.baseline2(j,i)=nan;
            
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%CHAMP
    for j=1:CHAMPend(i)
        
        if isnan(deltaENCO.CHAMP(1,j,i))==0
            
            tempstop=find(isnan(deltaENCO.CHAMP(:,j,i))==1);
            tempstop=tempstop(1);
            MaxPlantErrorVelocity.CHAMP(j,i)=min(deltaVelocity.CHAMP(150:tempstop(1)-2,j,i));
            peakDorsiVelocity.CHAMP(j,i)=max(Velocity.CHAMP(250:tempstop(1)-2,j,i));
            peakPlantVelocity.CHAMP(j,i)=min(Velocity.CHAMP(150:tempstop(1)-101,j,i));
            
            MaxPlantError.CHAMP(j,i)=min(deltaENCO.CHAMP(150:tempstop(1)-1,j,i));
            peakDorsi.CHAMP(j,i)=max(ENCO.CHAMP(250:tempstop(1)-1,j,i));
            peakPlant.CHAMP(j,i)=min(ENCO.CHAMP(150:tempstop(1)-100,j,i));
            
            temp=find(deltaENCO.CHAMP(150:tempstop(1)-1,j,i)==min(deltaENCO.CHAMP(150:tempstop(1)-1,j,i)));
            MaxPlantErrortiming.CHAMP(j,i)=temp(1)+149;
            
            temp=find(ENCO.CHAMP(250:tempstop(1)-1,j,i)==max(ENCO.CHAMP(250:tempstop(1)-1,j,i)));
            peakDorsitiming.CHAMP(j,i)=temp(1)+249;
            
            temp=find(ENCO.CHAMP(150:tempstop(1)-1,j,i)==min(ENCO.CHAMP(150:tempstop(1)-1,j,i)));
            peakPlanttiming.CHAMP(j,i)=temp(1)+149;
            
            meanABSError.CHAMP(j,i)=mean(abs(deltaENCO.CHAMP(150:tempstop(1)-1,j,i)));
            meanSIGNEDError.CHAMP(j,i)=mean(deltaENCO.CHAMP(150:tempstop(1)-1,j,i));
            
            meanABSErrorVelocity.CHAMP(j,i)=mean(abs(deltaVelocity.CHAMP(150:tempstop(1)-2,j,i)));
            meanSIGNEDErrorVelocity.CHAMP(j,i)=mean(deltaVelocity.CHAMP(150:tempstop(1)-2,j,i));
            
            u=0;
            o=0;
            
            for k=150:tempstop
                if deltaENCO.CHAMP(k,j,i)<0;
                    u=u+1;
                    tempUNDER(u)=k;
                    
                elseif deltaENCO.CHAMP(k,j,i)>0;
                    o=o+1;
                    tempOVER(o)=k;
                end
                
            end
            
            if length(tempUNDER)>0
                meanUndershoot.CHAMP(j,i)=sum(abs(deltaENCO.CHAMP(tempUNDER,j,i)))/(tempstop-150);
            else
                meanUndershoot.CHAMP(j,i)=0;
            end
            
            if length(tempOVER)>0
                meanOvershoot.CHAMP(j,i)=sum(abs(deltaENCO.CHAMP(tempOVER,j,i)))/(tempstop-150);
            else
                meanOvershoot.CHAMP(j,i)=0;
            end
            
            percentOvershoot.CHAMP(j,i)=meanOvershoot.CHAMP(j,i)/meanABSError.CHAMP(j,i)*100;
            percentUndershoot.CHAMP(j,i)=meanUndershoot.CHAMP(j,i)/meanABSError.CHAMP(j,i)*100;
            
            tempUNDER=[];
            tempOVER=[];
            
        else
            
            MaxPlantError.CHAMP(j,i)=nan;
            meanABSError.CHAMP(j,i)=nan;
            meanSIGNEDError.CHAMP(j,i)=nan;
            meanUndershoot.CHAMP(j,i)=nan;
            meanOvershoot.CHAMP(j,i)=nan;
            percentOvershoot.CHAMP(j,i)=nan;
            percentUndershoot.CHAMP(j,i)=nan;
            peakDorsi.CHAMP(j,i)=nan;
            peakPlant.CHAMP(j,i)=nan;
            MaxPlantErrortiming.CHAMP(j,i)=nan; 
            peakDorsitiming.CHAMP(j,i)=nan;
            peakPlanttiming.CHAMP(j,i)=nan;
            MaxPlantErrorVelocity.CHAMP(j,i)=nan;
            peakDorsiVelocity.CHAMP(j,i)=nan;
            peakPlantVelocity.CHAMP(j,i)=nan;
            meanABSErrorVelocity.CHAMP(j,i)=nan;
            meanSIGNEDErrorVelocity.CHAMP(j,i)=nan;
        end
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%POST
    for j=1:POSTend(i)
        
        if isnan(deltaENCO.POST(1,j,i))==0
            
            tempstop=find(isnan(deltaENCO.POST(:,j,i))==1);
            tempstop=tempstop(1);
            MaxDorsiError.POST(j,i)=max(deltaENCO.POST(250:tempstop(1)-1,j,i));
            peakDorsi.POST(j,i)=max(ENCO.POST(250:tempstop(1)-1,j,i));
            peakPlant.POST(j,i)=min(ENCO.POST(150:tempstop(1)-100,j,i));
            
            MaxDorsiErrorVelocity.POST(j,i)=max(deltaVelocity.POST(250:tempstop(1)-2,j,i));
            peakDorsiVelocity.POST(j,i)=max(Velocity.POST(250:tempstop(1)-2,j,i));
            peakPlantVelocity.POST(j,i)=min(Velocity.POST(150:tempstop(1)-101,j,i));
            
            temp=find(deltaENCO.POST(250:tempstop(1)-1,j,i)==max(deltaENCO.POST(250:tempstop(1)-1,j,i)));
            MaxDorsiErrortiming.POST(j,i)=temp(1)+249;
            
            temp=find(ENCO.POST(250:tempstop(1)-1,j,i)==max(ENCO.POST(250:tempstop(1)-1,j,i)));
            peakDorsitiming.POST(j,i)=temp(1)+249;
            
            temp=find(ENCO.POST(150:tempstop(1)-1,j,i)==min(ENCO.POST(150:tempstop(1)-1,j,i)));
            peakPlanttiming.POST(j,i)=temp(1)+149;
            
            meanABSError.POST(j,i)=mean(abs(deltaENCO.POST(150:tempstop(1)-1,j,i)));
            meanSIGNEDError.POST(j,i)=mean(deltaENCO.POST(150:tempstop(1)-1,j,i));
            
            meanABSErrorVelocity.POST(j,i)=mean(abs(deltaVelocity.POST(150:tempstop(1)-2,j,i)));
            meanSIGNEDErrorVelocity.POST(j,i)=mean(deltaVelocity.POST(150:tempstop(1)-2,j,i));
            
            u=0;
            o=0;
            
            for k=150:tempstop
                if deltaENCO.POST(k,j,i)<0;
                    u=u+1;
                    tempUNDER(u)=k;
                    
                elseif deltaENCO.POST(k,j,i)>0;
                    o=o+1;
                    tempOVER(o)=k;
                end
                
            end
            
            if length(tempUNDER)>0
                meanUndershoot.POST(j,i)=sum(abs(deltaENCO.POST(tempUNDER,j,i)))/(tempstop-150);
            else
                meanUndershoot.POST(j,i)=0;
            end
            
            if length(tempOVER)>0
                meanOvershoot.POST(j,i)=sum(abs(deltaENCO.POST(tempOVER,j,i)))/(tempstop-150);
            else
                meanOvershoot.POST(j,i)=0;
            end
            
            percentOvershoot.POST(j,i)=meanOvershoot.POST(j,i)/meanABSError.POST(j,i)*100;
            percentUndershoot.POST(j,i)=meanUndershoot.POST(j,i)/meanABSError.POST(j,i)*100;
            
            tempUNDER=[];
            tempOVER=[];
            
        else
            
            MaxDorsiError.POST(j,i)=nan;
            meanABSError.POST(j,i)=nan;
            meanSIGNEDError.POST(j,i)=nan;
            meanUndershoot.POST(j,i)=nan;
            meanOvershoot.POST(j,i)=nan;
            percentOvershoot.POST(j,i)=nan;
            percentUndershoot.POST(j,i)=nan;
            peakDorsi.POST(j,i)=nan;
            peakPlant.POST(j,i)=nan;
            MaxDorsiErrortiming.POST(j,i)=nan;
            peakDorsitiming.POST(j,i)=nan;
            peakPlanttiming.POST(j,i)=nan;
            MaxDorsiErrorVelocity.POST(j,i)=nan;
            peakDorsiVelocity.POST(j,i)=nan;
            peakPlantVelocity.POST(j,i)=nan;
            meanABSErrorVelocity.POST(j,i)=nan;
            meanSIGNEDErrorVelocity.POST(j,i)=nan;
        end
        
    end
    
    
end
