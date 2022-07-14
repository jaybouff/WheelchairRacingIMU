
function [AnalTA]= TAvariablesgenerator(Cycle_Table,data)
%% Baseline 2 TA enligné %MODIFICATION 30% au lieur de 20% du swing lignes 15:17, 50, 71, 170, 263

n=find(isnan(Cycle_Table(1,1,:))==1);
if n>0
    n=n(1)-1;
else
    n=30
end

load('SyncData.mat');
load('CyclesCritiques.mat');

AnalTA.TA.baseline2(1:1300,1:588,1:30)=nan;
AnalTA.TA.CHAMP(1:1300,1:397,1:30)=nan;
AnalTA.TA.POST(1:1300,1:290,1:30)=nan;

AnalTA.dureeswing.baseline2(1:588,1:30)=nan;
AnalTA.dureeswing.CHAMP(1:397,1:30)=nan;
AnalTA.dureeswing.POST(1:290,1:30)=nan;

AnalTA.peakTA.baseline2(1:588,1:30)=nan;
AnalTA.peakTA.CHAMP(1:397,1:30)=nan;
AnalTA.peakTA.POST(1:290,1:30)=nan;

% RMSburstTA.baseline2(1:588,1:30)=nan;
% RMSburstTA.CHAMP(1:397,1:30)=nan;
% RMSburstTA.POST(1:290,1:30)=nan;
% 
% normTAbefore.CHAMP(1:397,1:30)=nan;
% normTAafter.CHAMP(1:397,1:30)=nan;
% 
% normRMSburstTA.baseline2(1:588,1:30)=nan;
% normRMSburstTA.CHAMP(1:397,1:30)=nan;
% normRMSburstTA.POST(1:290,1:30)=nan;
% 
% MEANburstTA.baseline2(1:588,1:30)=nan;
% MEANburstTA.CHAMP(1:397,1:30)=nan;
% MEANburstTA.POST(1:290,1:30)=nan;
% 
% normMEANburstTA.baseline2(1:588,1:30)=nan;
% normMEANburstTA.CHAMP(1:397,1:30)=nan;
% normMEANburstTA.POST(1:290,1:30)=nan;
% 
AnalTA.cycleID.baseline2(1:588,1:30)=nan;
AnalTA.cycleID.CHAMP(1:397,1:30)=nan;
AnalTA.cycleID.POST(1:290,1:30)=nan;

AnalTA.baseline2(1:1300,1:30)=nan;
AnalTA.BASELINE2end(1:30)=nan;
AnalTA.CHAMPend(1:30)=nan;
AnalTA.POSTend(1:30)=nan;

for i=1:n
    
    k=0;
    
    if isnan(FF1(i))==0
        lastcycle=FF1(i)-1;
    else
        lastcycle=fin(i);
    end
    
    for j=1:lastcycle
         k=k+1;
        if Cycle_Table(3,j,i)==1 & SyncTiming(i,j)<1000 & SyncTiming(i,j)>500
            
            stop=find(isnan(data(:,j,i))==1);
            
            if stop>0;
            stop=stop(1)-1;
           
            
            AnalTA.dureeswing.baseline2(k,i)=stop-SyncTiming(i,j)+1;
            
            AnalTA.TA.baseline2(:,k,i)=interp1(1:round(AnalTA.dureeswing.baseline2(k,i)*1.3),data(SyncTiming(i,j)-round(AnalTA.dureeswing.baseline2(k,i)*0.3):stop,j,i),1:(round(AnalTA.dureeswing.baseline2(k,i)*1.3)-1)/(1299):round(AnalTA.dureeswing.baseline2(k,i)*1.3));
                     
            temp=data(SyncTiming(i,j)-150:end,j,i);
            AnalTA.peakTA.baseline2(k,i)=max(data(:,j,i));
            
            end
            
        end
              
        AnalTA.cycleID.baseline2(k,i)=j;
                
    end
    AnalTA.BASELINE2end(i)=k;
    
    clear h bad_cycles
    figure(1)
    clf
    subplot(2,1,1)
    for j=1:AnalTA.BASELINE2end(i)
    h(j,1)=plot(AnalTA.TA.baseline2(:,j,i));
    hold on
    end
    set(h(j,1),'color','b')
       
    subplot(2,1,2)
    for j=1:AnalTA.BASELINE2end(i)
        if isnan(AnalTA.TA.baseline2(1,j,i))==0
        s=['plot(j,mean(AnalTA.TA.baseline2(:,j,i)))'];
        h(j,2)=eval(s);
        hold on
        set(h(j,2),'color','b','marker','o');
        end
    end 
    
    xlabel('click in the white space when finished');
    
    bad_cycles=[];
    count=0;
    over=0;
    
    while not(over)
        
        waitforbuttonpress;
        hz=gco;
        [bad,channel]=find(h==hz);
        
        if not(isempty(bad))
            set(h(bad,1),'color','r','linewidth',2);
            ylabel(bad);
            set(h(bad,2),'color','r','marker','o')
                        
           for k=1:2
            uistack(h(bad,k),'top')
           end
            
            
            confirmation=menu('Non valide?','oui','non');
            
            switch confirmation
                case confirmation==1
                    
                    delete(h(bad,:))
                    count=count+1;
                    bad_cycles(count)=bad;
                    
                otherwise
                    
                    set(h(bad,1),'color','b','linewidth',0.5);
                    set(h(bad,2),'color','b','marker','o')
                    
            end %SWITCH
            
        else
            over=1;
        end; %if
    end; %while
        
Cycle_Table(3,AnalTA.cycleID.baseline2(bad_cycles,i),i)=-1;
AnalTA.TA.baseline2(:,bad_cycles,i)=nan;

temp=find(Cycle_Table(3,AnalTA.BASELINE2end(i)-49:AnalTA.BASELINE2end(i),i)==1);
countbase=length(temp);

    AnalTA.baseline2(:,i)=mean(AnalTA.TA.baseline2(:,temp+AnalTA.BASELINE2end(i)-50,i),2); %
%    velocitybaseline2(:,i)=mean(Velocity.baseline2(:,temp+BASELINE2end(i)-50,i),2);
    clear temp

 k=0;
    if isnan(FF1(i))==0
    for j=FF1(i):POST1(i)-1
           k=k+1;
        if Cycle_Table(3,j,i)==1 & SyncTiming(i,j)<1000 & SyncTiming(i,j)>500
            
            stop=find(isnan(data(:,j,i))==1);
            
            if stop>0;
            stop=stop(1)-1;
           
            
            AnalTA.dureeswing.CHAMP(k,i)=stop-SyncTiming(i,j)+1;
            
            AnalTA.TA.CHAMP(:,k,i)=interp1(1:round(AnalTA.dureeswing.CHAMP(k,i)*1.3),data(SyncTiming(i,j)-round(AnalTA.dureeswing.CHAMP(k,i)*0.3):stop,j,i),1:(round(AnalTA.dureeswing.CHAMP(k,i)*1.3)-1)/(1299):round(AnalTA.dureeswing.CHAMP(k,i)*1.3));
                     
            temp=data(SyncTiming(i,j)-150:end,j,i);
            AnalTA.peakTA.CHAMP(k,i)=max(data(:,j,i));
            
            end
            
        end
              
        
     AnalTA.cycleID.CHAMP(k,i)=j;       
    end    
    AnalTA.CHAMPend(i)=k;
    
    
    clear h bad_cycles
    figure(1)
    clf
    subplot(2,1,1)
    for j=1:AnalTA.CHAMPend(i)
    h(j,1)=plot(AnalTA.TA.CHAMP(:,j,i));
    hold on
    end
    set(h(j,1),'color','b')
       
    subplot(2,1,2)
    for j=1:AnalTA.CHAMPend(i)
        if isnan(AnalTA.TA.CHAMP(1,j,i))==0
        s=['plot(j,mean(AnalTA.TA.CHAMP(:,j,i)))'];
        h(j,2)=eval(s);
        hold on
        set(h(j,2),'color','b','marker','o');
        end
    end 
    
    xlabel('click in the white space when finished');
    
    bad_cycles=[];
    count=0;
    over=0;
    
    while not(over)
        
        waitforbuttonpress;
        hz=gco;
        [bad,channel]=find(h==hz);
        
        if not(isempty(bad))
            set(h(bad,1),'color','r','linewidth',2);
            ylabel(bad);
            set(h(bad,2),'color','r','marker','o')
                        
           for k=1:2
            uistack(h(bad,k),'top')
           end
            
            
            confirmation=menu('Non valide?','oui','non');
            
            switch confirmation
                case confirmation==1
                    
                    delete(h(bad,:))
                    count=count+1;
                    bad_cycles(count)=bad;
                    
                otherwise
                    
                    set(h(bad,1),'color','b','linewidth',0.5);
                    set(h(bad,2),'color','b','marker','o')
                    
            end %SWITCH
            
        else
            over=1;
        end; %if
    end; %while
        
Cycle_Table(3,AnalTA.cycleID.CHAMP(bad_cycles,i),i)=-1;
AnalTA.TA.CHAMP(:,bad_cycles,i)=nan;
    end

   if fin(i)-POST1(i)>1 
    k=0;
    for j=POST1(i):fin(i)-1
         k=k+1;
        if Cycle_Table(3,j,i)==1 & SyncTiming(i,j)<1000 & SyncTiming(i,j)>500
            
            stop=find(isnan(data(:,j,i))==1);
            
            if stop>0;
            stop=stop(1)-1;
           
            
            AnalTA.dureeswing.POST(k,i)=stop-SyncTiming(i,j)+1;
            
            AnalTA.TA.POST(:,k,i)=interp1(1:round(AnalTA.dureeswing.POST(k,i)*1.3),data(SyncTiming(i,j)-round(AnalTA.dureeswing.POST(k,i)*0.3):stop,j,i),1:(round(AnalTA.dureeswing.POST(k,i)*1.3)-1)/(1299):round(AnalTA.dureeswing.POST(k,i)*1.3));
                     
            temp=data(SyncTiming(i,j)-150:end,j,i);
            AnalTA.peakTA.POST(k,i)=max(data(:,j,i));
            
            end
            
        end
        
        AnalTA.cycleID.POST(k,i)=j;     
    end
    
     AnalTA.POSTend(i)=k;
     
     clear h bad_cycles
    figure(1)
    clf
    subplot(2,1,1)
    for j=1:AnalTA.POSTend(i)
    h(j,1)=plot(AnalTA.TA.POST(:,j,i));
    hold on
    end
    set(h(j,1),'color','b')
       
    subplot(2,1,2)
    for j=1:AnalTA.POSTend(i)
        if isnan(AnalTA.TA.POST(1,j,i))==0
        s=['plot(j,mean(AnalTA.TA.POST(:,j,i)))'];
        h(j,2)=eval(s);
        hold on
        set(h(j,2),'color','b','marker','o');
        end
    end 
    
    xlabel('click in the white space when finished');
    
    bad_cycles=[];
    count=0;
    over=0;
    
    while not(over)
        
        waitforbuttonpress;
        hz=gco;
        [bad,channel]=find(h==hz);
        
        if not(isempty(bad))
            set(h(bad,1),'color','r','linewidth',2);
            ylabel(bad);
            set(h(bad,2),'color','r','marker','o')
                        
           for k=1:2
            uistack(h(bad,k),'top')
           end
            
            
            confirmation=menu('Non valide?','oui','non');
            
            switch confirmation
                case confirmation==1
                    
                    delete(h(bad,:))
                    count=count+1;
                    bad_cycles(count)=bad;
                    
                otherwise
                    
                    set(h(bad,1),'color','b','linewidth',0.5);
                    set(h(bad,2),'color','b','marker','o')
                    
            end %SWITCH
            
        else
            over=1;
        end; %if
    end; %while
        
Cycle_Table(3,AnalTA.cycleID.POST(bad_cycles,i),i)=-1;
AnalTA.TA.POST(:,bad_cycles,i)=nan;
   end
     
end






%% TA activation levels
% 
% for i=1:n
%     
%     figure(1)
%     clf
%     plot(baseline2(:,i),'b')
%     hold on
%      temp=find(isnan(TA.CHAMP(1,:,i)')==0);
%     plot(mean(abs(TA.CHAMP(:,temp(end-9:end),i)),2),'m')
%     plot(mean(abs(TA.CHAMP(:,temp(2:11),i)),2),'r')
%     
%     temp=find(isnan(TA.POST(1,:,i)')==0);
%     if length(temp)>11
%     plot(mean(abs(TA.POST(:,temp(2:11),i)),2),'g')
%     end
%     
%     temp=ginput(1);
%     debutbouffee(i)=round(temp(1))
%     temp=ginput(1);
%     finbouffee(i)=round(temp(1))
%     
%      for j=1:BASELINE2end(i)
%    
%     
%     RMSburstTA.baseline2(j,i)=sqrt(sum(TA.baseline2(debutbouffee(i):finbouffee(i),j,i).^2));
%         
%     MEANburstTA.baseline2(j,i)=mean(abs(TA.baseline2(debutbouffee(i):finbouffee(i),j,i)),1);
%      end
%      
%      temp=find(isnan(RMSburstTA.baseline2(:,i)')==0);
%      norRMS=mean(RMSburstTA.baseline2(temp(end-99:end),i));
%      norMEAN=mean(MEANburstTA.baseline2(temp(end-99:end),i));
%      
%      for j=1:CHAMPend(i)
%          
%    if isnan(TA.CHAMP(1,j,i))==0
%     
%     RMSburstTA.CHAMP(j,i)=sqrt(sum(TA.CHAMP(debutbouffee(i):finbouffee(i),j,i).^2));
%     
%     normRMSburstTA.CHAMP(j,i)=RMSburstTA.CHAMP(j,i)/norRMS*100;   
%     
%     MEANburstTA.CHAMP(j,i)=mean(abs(TA.CHAMP(debutbouffee(i):finbouffee(i),j,i)),1);
%     normMEANburstTA.CHAMP(j,i)=MEANburstTA.CHAMP(j,i)/norMEAN*100; 
%     
%     normTAbefore.CHAMP(j,i)=mean(abs(TA.CHAMP(debutbouffee(i):stimtiming(j,i)+150,j,i)),1)/mean(abs(baseline2(debutbouffee(i):stimtiming(j,i)+150,i)),1)*100;
%     normTAafter.CHAMP(j,i)=mean(abs(TA.CHAMP(stimtiming(j,i)+150:finbouffee(i),j,i)),1)/mean(abs(baseline2(stimtiming(j,i)+150:finbouffee(i),i)),1)*100;
%    end
%      end
%      
%      for j=1:POSTend(i)
%        
%     
%     RMSburstTA.POST(j,i)=sqrt(sum(TA.POST(debutbouffee(i):finbouffee(i),j,i).^2));
%     normRMSburstTA.POST(j,i)=RMSburstTA.POST(j,i)/norRMS*100;   
%         
%     MEANburstTA.POST(j,i)=mean(abs(TA.POST(debutbouffee(i):finbouffee(i),j,i)),1);
%     normMEANburstTA.POST(j,i)=MEANburstTA.POST(j,i)/norMEAN*100;   
%      end
%     
% end
