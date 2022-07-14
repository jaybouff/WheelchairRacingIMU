function [ Cycle_Table ] = ValidationGroup( data,Cycle_Table )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

load('CyclesCritiques.mat')
load('SyncData.mat')
    n=find(isnan(Cycle_Table(1,1,:))==1);
    if n>0
        n=n(1)-1;
    else
        n=30
    end

for i=1:n
    
%     temp=find(SyncTiming(i,:)>900);
%     Cycle_Table(3,temp,i)=-2;
    
    CTRL=find(Cycle_Table(3,1:FF1(i)-1,i)==1);
    CHAMP=find(Cycle_Table(3,FF1(i):POST1(i)-1,i)==1)+FF1(i)-1;
    POST=find(Cycle_Table(3,POST1(i):fin(i)-1,i)==1)+POST1(i)-1;
    
    clear h bad_cycles
    figure(1)
    clf
    for j=CTRL
    h(j)=plot(data(SyncTiming(i,j)-150:SyncTiming(i,j)+600,j,i));
    hold on
    end
    
    set(h(CTRL),'color','b')
    
    xlabel('click in the white space when finished');
    
    bad_cycles=[];
    count=0;
    over=0;
    
    while not(over)
        
        waitforbuttonpress;
        hz=gco;
        [bad]=find(h==hz);
        
        if not(isempty(bad))
            set(h(bad),'color','r','linewidth',2);
            ylabel(bad);
                        
            uistack(h(bad),'top')
            
            
            confirmation=menu('Non valide?','oui','non');
            
            switch confirmation
                case confirmation==1
                    
                    delete(h(bad))
                    count=count+1;
                    bad_cycles(count)=bad;
                    
                otherwise
                    
                    set(h(bad),'color','b','linewidth',0.5);
                    
            end %SWITCH
            
        else
            over=1;
        end; %if
    end; %while
    
    
    clf
    for j=CHAMP
    h(j)=plot(data(SyncTiming(i,j)-150:SyncTiming(i,j)+600,j,i));
    hold on
    end
    
    set(h(CHAMP),'color','b')
    
    xlabel('click in the white space when finished');
    
    bad_cycles=[];
    count=0;
    over=0;
    
    while not(over)
        
        waitforbuttonpress;
        hz=gco;
        [bad]=find(h==hz);
        
        if not(isempty(bad))
            set(h(bad),'color','r','linewidth',2);
            ylabel(bad);
            title(bad-FF1(i)+1);
                        
            uistack(h(bad),'top')
            
            
            confirmation=menu('Non valide?','oui','non');
            
            switch confirmation
                case confirmation==1
                    
                    delete(h(bad))
                    count=count+1;
                    bad_cycles(count)=bad;
                    
                otherwise
                    
                    set(h(bad),'color','b','linewidth',0.5);
                    
            end %SWITCH
            
        else
            over=1;
        end; %if
    end; %while
    
    
    clf
    for j=POST
    h(j)=plot(data(SyncTiming(i,j)-150:SyncTiming(i,j)+600,j,i));
    hold on
    end
    
    set(h(POST),'color','b')
    
    xlabel('click in the white space when finished');
    
    bad_cycles=[];
    count=0;
    over=0;
    
    while not(over)
        
        waitforbuttonpress;
        hz=gco;
        [bad]=find(h==hz);
        
        if not(isempty(bad))
            set(h(bad),'color','r','linewidth',2);
            ylabel(bad);
            title(bad-POST1(i)+1);
                        
            uistack(h(bad),'top')
            
            
            confirmation=menu('Non valide?','oui','non');
            
            switch confirmation
                case confirmation==1
                    
                    delete(h(bad))
                    count=count+1;
                    bad_cycles(count)=bad;
                    
                otherwise
                    
                    set(h(bad),'color','b','linewidth',0.5);
                    
            end %SWITCH
            
        else
            over=1;
        end; %if
    end; %while
    
    
Cycle_Table(3,bad_cycles,i)=-1;
end

end

