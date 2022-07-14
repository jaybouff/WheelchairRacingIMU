
function removebad_Superpose

clear all 
load('Table_data.mat');


    
    validnum(1)=find(strcmp(chan_name,'ENCO')==1);
    validnum(2)=find(strcmp(chan_name,'COUPLE')==1);
    validnum(3)=find(strcmp(chan_name,'HS')==1);
    validnum(4)=find(strcmp(chan_name,'CONS_F')==1);
    numchan2=4;
    
    
    
    
    top(1)=30;
    bottom(1)=-30;
    
    top(2)=10;
    bottom(2)=-10;
    
    top(3)=5;
    bottom(3)=0;
    
    top(4)=2;
    bottom(4)=-12;

if isempty(find(Cycle_Table(:,5)==1))
    % For baseline1
    
    %Procedure Baseline
    figure(1)
    clf
    j=0;
    CTRL=1:size(Table1,2);
    for i=validnum
        j=j+1;
        subplot(numchan2+1,1,j) %numchan2+1
        s=['plot(','Table',num2str(i),'(:,CTRL))'];
        
        
        h(CTRL,j)=eval(s);
        set(h(CTRL,j),'color','b')
        
        title(chan_name(i))
        hold on;
        
        a=axis;
        axis([0 1500 bottom(j) top(j)])
        
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
    
else
    
    STIM=find(Cycle_Table(:,5)==1);
    CTRL=find(Cycle_Table(:,5)==0);
    
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
        title(chan_name(i))
        
        hold on;
        
        a=axis;
        axis([0 1500 bottom(j) top(j)])
        
    end %For
    
    for i=1:length(CTRL)
        subplot(numchan2+1,1,numchan2+1)
        s=['plot(CTRL(i),Cycle_Table(CTRL(i),2)-Cycle_Table(CTRL(i),1))'];
        h(CTRL(i),numchan2+1)=eval(s);
        hold on
        set(h(CTRL(i),numchan2+1),'color','b','marker','o');
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
        s=['plot(','Table',num2str(i),'(:,STIM))'];
        
        
        h(STIM,j)=eval(s);
        set(h(STIM,j),'color','b')
        
        title(chan_name(i))
        
        hold on;
        
        a=axis;
        axis([0 1500 bottom(j) top(j)])
        
    end %For
    
    
    for i=1:length(STIM)
        subplot(numchan2+1,1,numchan2+1)
        s=['plot(i,Cycle_Table(STIM(i),2)-Cycle_Table(STIM(i),1))'];
        h(STIM(i),numchan2+1)=eval(s);
        hold on
        set(h(STIM(i),numchan2+1),'color','b','marker','o');
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
    
    
   
    
end %if
    Cycle_Table(:,3)=1;
    Cycle_Table(bad_cycles,3)=0;
    
    close
    clear h count bad bad_cycles hz confirmation channel a s over CTRL FF POST onsetFF k;
    save('Table_data.mat');


