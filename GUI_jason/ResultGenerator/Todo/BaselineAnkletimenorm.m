function [ENCO,baseline2,baseline1,cycleID,BASELINE2end,BASELINE1end,deltaENCO, meanABSError,dureeswing,peakDorsi,peakPlant,peakDorsitiming,peakPlanttiming, deltaBaseline1, meanABSdeltabaseline1]=ENCObaselinetimenorm(Cycle_Table,data)

n=find(isnan(Cycle_Table(1,1,:))==1);
if n>0
    n=n(1)-1;
else
    n=30
end


[filename,pathname]=uigetfile('*.mat','Sélectionnez votre fichier AnalENCO Day1')
load([pathname,filename],'baseline2','ENCO','BASELINE2end','cycleID','dureeswing', 'peakDorsi', 'peakPlant', 'peakDorsitiming', 'peakPlanttiming')

load('SyncData.mat');
load('CyclesCritiques.mat');

question=menu('Avez-vous déjà un fichier AnalENCO baseline1?','oui','non');

if question==2

figure(1)
ENCO.baseline1(1:1000,1:588,1:30)=nan;
deltaBaseline1.baseline2(1:1000,1:588,1:30)=nan;

dureeswing.baseline1(1:588,1:30)=nan;

deltaENCO.baseline1(1:1000,1:588,1:30)=nan;

cycleID.baseline1(1:588,1:30)=nan;

baseline1(1:1000,1:30)=nan;
BASELINE1end(1:30)=nan;

meanABSError.baseline1(1:588,1:30)=nan;
peakDorsi.baseline1(1:588,1:30)=nan;
peakPlant.baseline1(1:588,1:30)=nan; 
peakDorsitiming.baseline1(1:588,1:30)=nan;
peakPlanttiming.baseline1(1:588,1:30)=nan;
meanABSdeltabaseline1.baseline2(1:588,1:30)=nan;

x=1;

elseif question==1
    load('AnalENCOtimenorm.mat')
    temp=find(isnan(BASELINE1end)==1);
    x=temp(1);
end

for i=x:n
    i
    k=0;
    
    for j=1:fin(i)
        k=k+1;
        if Cycle_Table(3,j,i)==1 & SyncTiming(i,j)<1000 & Cycle_Table(4,j,i)==0 & SyncTiming(i,j)>500
            
            stop=find(isnan(data(:,j,i))==1);
            if stop>0;
            stop=stop(1)-1;
            
            ENCO.baseline1(:,k,i)=interp1(1:(stop-SyncTiming(i,j)+1),data(SyncTiming(i,j):stop,j,i),1:(stop-SyncTiming(i,j))/(999):(stop-SyncTiming(i,j)+1));
                
            dureeswing.baseline1(k,i)=stop-SyncTiming(i,j)+1;
            
            else 
                              
            ENCO.baseline1(:,k,i)=nan;            
            dureeswing.baseline1(k,i)=nan;
            
            end
           
        else
            ENCO.baseline1(:,k,i)=nan;            
            dureeswing.baseline1(k,i)=nan;
        end
        cycleID.baseline1(k,i)=j;
        
        
    end
    BASELINE1end(i)=k;
    
    clear h bad_cycles
    figure(1)
    clf
    subplot(2,1,1)
    for j=1:BASELINE1end(i)
    h(j,1)=plot(ENCO.baseline1(:,j,i));
    hold on
    end
    set(h(j,1),'color','b')
       
    subplot(2,1,2)
    for j=1:BASELINE1end(i)
        s=['plot(j,dureeswing.baseline2(j,i))'];
        h(j,2)=eval(s);
        hold on
        set(h(j,2),'color','b','marker','o');
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
        
Cycle_Table(3,cycleID.baseline2(bad_cycles,i),i)=-1;
 ENCO.baseline1(:,bad_cycles,i)=nan;

temp=find(Cycle_Table(3,BASELINE1end(i)-49:BASELINE1end(i),i)==1);
countbase=length(temp);

    baseline1(:,i)=mean(ENCO.baseline1(:,temp+BASELINE1end(i)-50,i),2); %
%    velocitybaseline2(:,i)=mean(Velocity.baseline2(:,temp+BASELINE2end(i)-50,i),2);
    clear temp
end
    


clear data GroupData Cycle_Table
for i=x:n
    
    for j=1:size(ENCO.baseline1(:,:,i),2)
        
        deltaENCO.baseline1(:,j,i)=ENCO.baseline1(:,j,i)-baseline1(:,i);
        
    
    meanABSError.baseline1(j,i)=mean(abs(deltaENCO.baseline1(:,j,i)));
       
    end
    
    
novalid=find(isnan(meanABSError.baseline1(BASELINE1end(i)-49:BASELINE1end(i),i))==1);
if length(novalid)>5
    menu([num2str(i),'>10% baseline no valid'],'ok je vais aller voir ses données')
else
    temp=sort(meanABSError.baseline1(BASELINE1end(i)-49:BASELINE1end(i),i));
    for k=1:45
    temp2=find(meanABSError.baseline1(BASELINE1end(i)-49:BASELINE1end(i),i)==temp(k));
    cyclesbaseline(k,i)=temp2+BASELINE1end(i)-50;
    end
    baseline1(:,i)=mean(ENCO.baseline1(:,cyclesbaseline(:,i),i),2)
    %velocitybaseline2(:,i)=mean(Velocity.baseline2(:,cyclesbaseline(:,i),i),2);
end

end


for i=x:n
    
    for j=1:size(ENCO.baseline1(:,:,i),2)
        
        deltaENCO.baseline1(:,j,i)=ENCO.baseline1(:,j,i)-baseline2(:,i);
    end
    
    for j=1:size(ENCO.baseline2(:,:,i),2)
        deltaBaseline1.baseline2(:,j,i)=ENCO.baseline2(:,j,i)-baseline1(:,i);
    end
  
end
 
for i=x:n
%    
    
       
    for j=1:BASELINE1end(i)
        
        if isnan(deltaENCO.baseline1(1,j,i))==0
            
            
           
            peakDorsi.baseline1(j,i)=max(ENCO.baseline1(200:1000,j,i));
            peakPlant.baseline1(j,i)=min(ENCO.baseline1(1:600,j,i));
            
         
            
            temp=find(ENCO.baseline1(200:1000,j,i)==max(ENCO.baseline1(200:1000,j,i)));
            peakDorsitiming.baseline1(j,i)=temp(1)+199;
            
            temp=find(ENCO.baseline1(1:600,j,i)==min(ENCO.baseline1(1:600,j,i)));
            peakPlanttiming.baseline1(j,i)=temp(1);
            
            meanABSError.baseline1(j,i)=mean(abs(deltaENCO.baseline1(:,j,i)));
            meanSIGNEDError.baseline1(j,i)=mean(deltaENCO.baseline1(:,j,i));
            
          
               
            
        end
    end
    
    for j=1:BASELINE2end(i)
        
        if isnan(deltaBaseline1.baseline2(1,j,i))==0
            
            
           
            
            
            meanABSdeltabaseline1.baseline2(j,i)=mean(abs(deltaBaseline1.baseline2(:,j,i)));
                      
               
            
        end
    end
        
    
    
    
    
end
