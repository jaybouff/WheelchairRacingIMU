function [TA, baseline2, cycleID, BASELINE1end, BASELINE2end, RMSburstTA, MEANburstTA, debutbouffee, finbouffee, peakTA]=BaselineTA(Cycle_Table,data)
% %% Enligner par rapport au crossing du ginput
% clear GroupData
% [filename,pathname]=uigetfile('*.mat','Sélectionnez votre fichier de groupe ENCO')

load('SyncData.mat');
load('CyclesCritiques.mat');

[filename,pathname]=uigetfile('*.mat','Sélectionnez votre fichier AnalTA')
load([pathname,filename],'TA','BASELINE2end','cycleID', 'baseline2', 'debutbouffee', 'finbouffee', 'peakTA')



n=find(isnan(Cycle_Table(1,1,:))==1);
if n>0
    n=n(1)-1;
else
    n=30
end



baseline1(1:1000,1:30)=nan;

TA.baseline1(1:1000,1:848,1:30)=nan;
 RMSburstTA.baseline1(1:848,1:30)=nan;
  MEANburstTA.baseline1(1:848,1:30)=nan;
  dureeswing.baseline1(1:848,1:30)=nan;
for i=1:n
    
    k=0;
    
    for j=1:fin(i)-1
        k=k+1;
        if Cycle_Table(3,j,i)==1 & SyncTiming(i,j)<1000 & SyncTiming(i,j)>500
            
            temp=data(SyncTiming(i,j)-150:end,j,i);
            peakTA.baseline1(k,i)=max(data(:,j,i));
            
            if size(temp,1)>1000
                TA.baseline1(:,k,i)=temp(1:1000,1);
                
            else
                
                TA.baseline1(1:size(temp,1),k,i)=temp;
                
            end
            
            tempstop=find(isnan(TA.baseline1(:,k,i))==1);
            if tempstop>0
                tempstop=tempstop(1);
            else
                tempstop=1000;
            end
            
            dureeswing.baseline1(k,i)=tempstop-150;
            
        else
                 
            TA.baseline1(:,k,i)=nan;
            dureeswing.baseline1(k,i)=nan;
            
            
        end   
            
            cycleID.baseline1(k,i)=j;
    end
        
    
        
BASELINE1end(i)=k;
% temp=find(isnan(TA.baseline1(1,:,i)')==0);
% temp=find(isnan(TA.baseline1(1,:,i)')==0 & dureeswing.baseline1(:,i)>mean(dureeswing.baseline1(temp,i))-std(dureeswing.baseline1(temp,i)));
%     baseline1(:,i)=mean(TA.baseline1(1:1000,temp(end-99:end),i),2);
clear temp
end


figure(1)

for i=1:n
%     clf
%      plot(baseline2(:,i),'b')
%     hold on
%      plot(baseline1(:,i),'c')
%     
%     
%     temp=ginput(1);
%     debutbouffee(i)=round(temp(1))
%     temp=ginput(1);
%     finbouffee(i)=round(temp(1))
    
    for j=1:BASELINE1end(i)
   
    
    RMSburstTA.baseline1(j,i)=sqrt(sum(TA.baseline1(debutbouffee(i):finbouffee(i),j,i).^2));
        
    MEANburstTA.baseline1(j,i)=mean(abs(TA.baseline1(debutbouffee(i):finbouffee(i),j,i)));
    end
     
%      temp=find(isnan(RMSburstTA.baseline1(:,i)')==0);
%      norRMS=mean(RMSburstTA.baseline1(temp(end-9:end),i));
%      norMEAN=mean(MEANburstTA.baseline1(temp(end-9:end),i)); 
    
%     for j=1:BASELINE2end(i)
%    
%     
%     RMSburstTA.baseline2(j,i)=sqrt(sum(TA.baseline2(debutbouffee(i):finbouffee(i),j,i).^2));
% %     normRMSburstTA.baseline2(j,i)=RMSburstTA.baseline2(j,i)/norRMS*100;   
%         
%     MEANburstTA.baseline2(j,i)=mean(TA.baseline2(debutbouffee(i):finbouffee(i),j,i));
% %     normMEANburstTA.baseline2(j,i)=MEANburstTA.baseline2(j,i)/norRMS*100; 
%      end
%      
     
end   

    
    clear ENCO.CHAMP ENCO.POST cycleID.CHAMP cycleID.POST

