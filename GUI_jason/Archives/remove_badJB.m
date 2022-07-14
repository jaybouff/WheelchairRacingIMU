%program remove bad cycles
%Il resterais à faire variable pour les différentes conditions afin de
%raccourcir le programme et rendre valide pour reflexe-catch-channel etc.

%June 11th 2012

k=menu('Remove Bad Data analysis program version 1.0','OK');
k=menu('Please make sure that you are in the data folder','OK');

%% load data
clear all;
load('Table_data.mat');

%% For baseline1
% validnum=[1 2 8 9 10 11];
% numchan2=6;
% %Procedure Baseline
% figure(1)
% clf
% j=0;
% CTRL=1:size(Table1,2);
% for i=validnum
%     j=j+1;
%     subplot(numchan2+1,1,j) %numchan2+1
%     s=['plot(','Table',num2str(i),'(:,CTRL))'];
%     
%     
%     h(CTRL,j)=eval(s);
%     set(h(CTRL,j),'color','b')
%     
%     hold on;
%     
%     a=axis;
%     axis([0 1500 a(3) a(4)])
%     
% end %For
% 
% for i=CTRL
% subplot(numchan2+1,1,numchan2+1)
% s=['plot(i,Cycle_Table(i,2)-Cycle_Table(i,1))'];
% h(i,numchan2+1)=eval(s);
% hold on
% set(h(i,numchan2+1),'color','b','marker','o');
% end 
% 
% xlabel('click in the white space when finished');
% 
% bad_cycles=[];
% count=0;
% over=0;
% 
% while not(over)
%     
%     waitforbuttonpress;
%     hz=gco;
%     [bad,channel]=find(h==hz);
%     
%     if not(isempty(bad))
%         set(h(bad,1:numchan2),'color','r','linewidth',2);
%         ylabel(bad);
%         set(h(bad,numchan2+1),'color','r','marker','o')
%         
%         for i=1:numchan2
%             uistack(h(bad,i),'top')
%         end
%         
%         confirmation=menu('Non valide?','oui','non');
%         
%         switch confirmation
%             case confirmation==1
%                 
%                 delete(h(bad,:))
%                 count=count+1;
%                 bad_cycles(count)=bad;
%                 
%             otherwise
%                 
%                 set(h(bad,1:numchan2),'color','b','linewidth',0.5);
%                 set(h(bad,numchan2+1),'color','b','marker','o')
%         end %SWITCH
%         
%     else
%         over=1;
%     end; %if
% end; %while

%% Feed data into proper tables for the rest of the dataset

onsetFF=find(Cycle_Table(:,5)==1);


validnum=[1 2 8 9 10 11];



numchan2=6;
CTRL=1:onsetFF(1)-1;
FF=onsetFF(1):onsetFF(end);
POST=onsetFF(end)+1:size(Table1,2);
h(size(Table1,2),numchan2)=nan;

%Procédure Baseline
figure(1)
clf
j=0;
for i=validnum
    j=j+1;
    subplot(numchan2+1,1,j) %numchan2+1
    s=['plot(','Table',num2str(i),'(:,CTRL))'];
    
    
    h(CTRL,j)=eval(s);
    set(h(CTRL,j),'color','b')
    
    hold on;
    
    a=axis;
    axis([0 1500 a(3) a(4)])
    
end %For

for i=CTRL
subplot(numchan2+1,1,numchan2+1)
s=['plot(i,Cycle_Table(i,2)-Cycle_Table(i,1))'];
h(i,numchan2+1)=eval(s);
hold on
set(h(i,numchan2+1),'color','b','marker','o');
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
        set(h(bad,1:numchan2),'color','r','linewidth',2);
        ylabel(bad);
        set(h(bad,numchan2+1),'color','r','marker','o')
        
        for i=1:numchan2
            uistack(h(bad,i),'top')
        end
        
        confirmation=menu('Non valide?','oui','non');
        
        switch confirmation
            case confirmation==1
                
                delete(h(bad,:))
                count=count+1;
                bad_cycles(count)=bad;
                
            otherwise
                
                set(h(bad,1:numchan2),'color','b','linewidth',0.5);
                set(h(bad,numchan2+1),'color','b','marker','o')
        end %SWITCH
        
    else
        over=1;
    end; %if
end; %while



%Procédure FF
figure(1)
clf
j=0;
for i=validnum
    j=j+1;
    subplot(numchan2+1,1,j)
    s=['plot(','Table',num2str(i),'(:,FF))'];
    
    
    h(FF,j)=eval(s);
    set(h(FF,j),'color','b')
    
    hold on;
    
    a=axis;
    axis([0 1500 a(3) a(4)])
    
end %For


for i=FF
subplot(numchan2+1,1,numchan2+1)
s=['plot(i,Cycle_Table(i,2)-Cycle_Table(i,1))'];
h(i,numchan2+1)=eval(s);
hold on
set(h(i,numchan2+1),'color','b','marker','o');
end

xlabel('click in the white space when finished');


over=0;

while not(over)
    
    waitforbuttonpress;
    hz=gco;
    [bad,channel]=find(h==hz);
    if not(isempty(bad))
        set(h(bad,1:numchan2),'color','r','linewidth',2);
        set(h(bad,numchan2+1),'color','r','marker','o')
        ylabel(bad-size(CTRL));
        
        for i=1:numchan2
            uistack(h(bad,i),'top')
        end
        
        confirmation=menu('Non valide?','oui','non');
        switch confirmation
            case confirmation==1
                
                delete(h(bad,:))
                count=count+1;
                bad_cycles(count)=bad;
                
            otherwise
                
                set(h(bad,1:numchan2),'color','b','linewidth',0.5);
                set(h(bad,numchan2+1),'color','b','marker','o')
        end %SWITCH
        
    else
        over=1;
    end; %if
end; %while


%Procédure POST
figure(1)
clf
j=0;
for i=validnum
    j=j+1;
    
    subplot(numchan2+1,1,j)
    s=['plot(','Table',num2str(i),'(:,POST))'];
    
    
    h(POST,j)=eval(s);
    set(h(POST,j),'color','b')
    
    hold on;
    
    a=axis;
    axis([0 1500 a(3) a(4)])
    
end %FOR

for i=POST
subplot(numchan2+1,1,numchan2+1)
s=['plot(i,Cycle_Table(i,2)-Cycle_Table(i,1))'];
h(i,numchan2+1)=eval(s);
hold on
set(h(i,numchan2+1),'color','b','marker','o');
end

xlabel('click in the white space when finished');


over=0;

while not(over)
    
    waitforbuttonpress;
    hz=gco;
    [bad,channel]=find(h==hz);
    if not(isempty(bad))
        set(h(bad,1:numchan2),'color','r','linewidth',2);
        set(h(bad,numchan2+1),'color','r','marker','o')
        ylabel(bad-size(CTRL)-size(FF));
        
        for i=1:numchan2
            uistack(h(bad,i),'top')
        end
        
        confirmation=menu('Non valide?','oui','non');
        switch confirmation
            case confirmation==1
                
                delete(h(bad,:))
                count=count+1;
                bad_cycles(count)=bad;
                
            otherwise
                
                set(h(bad,1:numchan2),'color','b','linewidth',0.5);
                set(h(bad,numchan2+1),'color','b','marker','o')
        end %SWITCH
        
    else
        over=1;
    end; %if
end; %while

Cycle_Table(:,3)=1;
Cycle_Table(bad_cycles,3)=0;

clear h count bad bad_cycles hz confirmation channel a s over CTRL FF POST onsetFF k;
save('Table_data.mat');

