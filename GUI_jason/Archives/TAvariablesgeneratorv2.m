
function [TA, baseline2, cycleID, CHAMPend, BASELINE2end, POSTend, RMSburstTA, normRMSburstTA, MEANburstTA, normMEANburstTA, dureeswing, normTAbefore, normTAafter, debutbouffee, finbouffee, peakTA ]= TAvariablesgenerator(Cycle_Table,data)
%% Baseline 2 TA enligné

n=find(isnan(Cycle_Table(1,1,:))==1);
if n>0
    n=n(1)-1;
else
    n=30
end

load('SyncData.mat');
load('CyclesCritiques.mat');

TA.baseline2(1:1000,1:588,1:30)=nan;
TA.CHAMP(1:1000,1:397,1:30)=nan;
TA.POST(1:1000,1:290,1:30)=nan;

dureeswing.baseline2(1:588,1:30)=nan;
dureeswing.CHAMP(1:397,1:30)=nan;
dureeswing.POST(1:290,1:30)=nan;

peakTA.baseline2(1:588,1:30)=nan;
peakTA.CHAMP(1:397,1:30)=nan;
peakTA.POST(1:290,1:30)=nan;

RMSburstTA.baseline2(1:588,1:30)=nan;
RMSburstTA.CHAMP(1:397,1:30)=nan;
RMSburstTA.POST(1:290,1:30)=nan;

normTAbefore.CHAMP(1:397,1:30)=nan;
normTAafter.CHAMP(1:397,1:30)=nan;

normRMSburstTA.baseline2(1:588,1:30)=nan;
normRMSburstTA.CHAMP(1:397,1:30)=nan;
normRMSburstTA.POST(1:290,1:30)=nan;

MEANburstTA.baseline2(1:588,1:30)=nan;
MEANburstTA.CHAMP(1:397,1:30)=nan;
MEANburstTA.POST(1:290,1:30)=nan;

normMEANburstTA.baseline2(1:588,1:30)=nan;
normMEANburstTA.CHAMP(1:397,1:30)=nan;
normMEANburstTA.POST(1:290,1:30)=nan;

cycleID.baseline2(1:588,1:30)=nan;
cycleID.CHAMP(1:397,1:30)=nan;
cycleID.POST(1:290,1:30)=nan;

baseline2(1:1000,1:30)=nan;
BASELINE2end(1:30)=nan;
CHAMPend(1:30)=nan;
POSTend(1:30)=nan;

for i=1:n
    
    k=0;
    
    for j=1:FF1(i)-1
         k=k+1;
        if Cycle_Table(3,j,i)==1 & SyncTiming(i,j)<1000 & SyncTiming(i,j)>500
           
            temp=data(SyncTiming(i,j)-150:end,j,i);
            peakTA.baseline2(k,i)=max(data(:,j,i));
            
            if size(temp,1)>1000
                TA.baseline2(:,k,i)=temp(1:1000,1);
                
                
            else
                
                TA.baseline2(1:size(temp,1),k,i)=temp;
                
            end
            
            tempstop=find(isnan(TA.baseline2(:,k,i))==1);
            if tempstop>0
                tempstop=tempstop(1);
            else
                tempstop=1000;
            end
            
            dureeswing.baseline2(k,i)=tempstop-150;
            
             else
            TA.baseline2(:,k,i)=nan;
            dureeswing.baseline2(k,i)=nan;
            
            
        end   
        
        cycleID.baseline2(k,i)=j;
        
    end
    BASELINE2end(i)=k;
    temp=find(isnan(TA.baseline2(1,:,i)')==0);
    temp=find(isnan(TA.baseline2(1,:,i)')==0 & dureeswing.baseline2(:,i)>mean(dureeswing.baseline2(temp,i))-std(dureeswing.baseline2(temp,i)));
    baseline2(:,i)=mean(abs(TA.baseline2(1:1000,temp(end-99:end),i)),2);
    clear temp


 k=0;
    
    for j=FF1(i):POST1(i)-1
           k=k+1;
        if Cycle_Table(3,j,i)==1 & SyncTiming(i,j)<1000 & SyncTiming(i,j)>500
         
            peakTA.CHAMP(k,i)=max(data(:,j,i));
            temp=data(SyncTiming(i,j)-150:end,j,i);
            
            if size(temp,1)>1000
                TA.CHAMP(:,k,i)=temp(1:1000,1);
                
            else
                
                TA.CHAMP(1:size(temp,1),k,i)=temp;
                
            end
            
            tempstop=find(isnan(TA.CHAMP(:,k,i))==1);
            if tempstop>0
                tempstop=tempstop(1);
            else
                tempstop=1000;
            end
            
            dureeswing.CHAMP(k,i)=tempstop-150;
            
        else
            TA.CHAMP(:,k,i)=nan;
            dureeswing.CHAMP(k,i)=nan;
        end
        
     cycleID.CHAMP(k,i)=j;       
    end
        
    
        
        
    
    
    CHAMPend(i)=k;
    
    k=0;
    for j=POST1(i):fin(i)-1
         k=k+1;
        if Cycle_Table(3,j,i)==1 & SyncTiming(i,j)<1000 & SyncTiming(i,j)>500
            peakTA.POST(k,i)=max(data(:,j,i));
            temp=data(SyncTiming(i,j)-150:end,j,i);
            
            if size(temp,1)>1000
                TA.POST(:,k,i)=temp(1:1000,1);
                
            else
                
                TA.POST(1:size(temp,1),k,i)=temp;
                
            end
            
            tempstop=find(isnan(TA.POST(:,k,i))==1);
            
            if tempstop>0
                tempstop=tempstop(1);
            else
                tempstop=1000;
            end
            dureeswing.POST(k,i)=tempstop-150;
            
        else
            TA.POST(:,k,i)=nan;
            dureeswing.POST(k,i)=nan;
            
%             
            
        end
        
        cycleID.POST(k,i)=j;
        
       
        
    end
    
     POSTend(i)=k;
     
end






%% TA activation levels

for i=1:n
    
    figure(1)
    clf
    plot(baseline2(:,i),'b')
    hold on
     temp=find(isnan(TA.CHAMP(1,:,i)')==0);
    plot(mean(abs(TA.CHAMP(:,temp(end-9:end),i)),2),'m')
    plot(mean(abs(TA.CHAMP(:,temp(2:11),i)),2),'r')
    
    temp=find(isnan(TA.POST(1,:,i)')==0);
    if length(temp)>11
    plot(mean(abs(TA.POST(:,temp(2:11),i)),2),'g')
    end
    
    temp=ginput(1);
    debutbouffee(i)=round(temp(1))
    temp=ginput(1);
    finbouffee(i)=round(temp(1))
    
     for j=1:BASELINE2end(i)
   
    
    RMSburstTA.baseline2(j,i)=sqrt(sum(TA.baseline2(debutbouffee(i):finbouffee(i),j,i).^2));
        
    MEANburstTA.baseline2(j,i)=mean(abs(TA.baseline2(debutbouffee(i):finbouffee(i),j,i)),1);
     end
     
     temp=find(isnan(RMSburstTA.baseline2(:,i)')==0);
     norRMS=mean(RMSburstTA.baseline2(temp(end-99:end),i));
     norMEAN=mean(MEANburstTA.baseline2(temp(end-99:end),i));
     
     for j=1:CHAMPend(i)
         
   if isnan(TA.CHAMP(1,j,i))==0
    
    RMSburstTA.CHAMP(j,i)=sqrt(sum(TA.CHAMP(debutbouffee(i):finbouffee(i),j,i).^2));
    
    normRMSburstTA.CHAMP(j,i)=RMSburstTA.CHAMP(j,i)/norRMS*100;   
    
    MEANburstTA.CHAMP(j,i)=mean(abs(TA.CHAMP(debutbouffee(i):finbouffee(i),j,i)),1);
    normMEANburstTA.CHAMP(j,i)=MEANburstTA.CHAMP(j,i)/norMEAN*100; 
    
    normTAbefore.CHAMP(j,i)=mean(abs(TA.CHAMP(debutbouffee(i):stimtiming(j,i)+150,j,i)),1)/mean(abs(baseline2(debutbouffee(i):stimtiming(j,i)+150,i)),1)*100;
    normTAafter.CHAMP(j,i)=mean(abs(TA.CHAMP(stimtiming(j,i)+150:finbouffee(i),j,i)),1)/mean(abs(baseline2(stimtiming(j,i)+150:finbouffee(i),i)),1)*100;
   end
     end
     
     for j=1:POSTend(i)
       
    
    RMSburstTA.POST(j,i)=sqrt(sum(TA.POST(debutbouffee(i):finbouffee(i),j,i).^2));
    normRMSburstTA.POST(j,i)=RMSburstTA.POST(j,i)/norRMS*100;   
        
    MEANburstTA.POST(j,i)=mean(abs(TA.POST(debutbouffee(i):finbouffee(i),j,i)),1);
    normMEANburstTA.POST(j,i)=MEANburstTA.POST(j,i)/norMEAN*100;   
     end
    
end
