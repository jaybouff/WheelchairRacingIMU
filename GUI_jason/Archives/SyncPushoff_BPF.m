function [SyncTiming, SyncThreshold] = SyncPushoff(Cycle_Table,data)
% part du début au lieu de 500

    load('CyclesCritiques.mat')
    n=find(isnan(Cycle_Table(1,1,:))==1);
    if n>0
        n=n(1)-1;
    else
        n=30
    end
    
    question=menu('Avez-vous déjà un fichier de synchro?','oui','non');
    
    if question==2
        x=1;
               stimtimingSync(1:300,1:30)=nan;
    elseif question==1
        load('SyncData.mat')
        x=size(SyncTiming,1)+1;
    end
    
    for i=x:n
        figure(1)
        clf
        
        if FF1(i)>0
            
            for j=1:FF1(i)-1
                % data(:,j,i)=data(:,j,i)-data(1,j,i); % pour enlever le premier point
                if Cycle_Table(3,j,i)==1
                    
                    plot(data(1:end-1,j,i),'b')
                    hold on
                    
                end
            end
            
            for j=FF1(i):POST1(i)-1
                %data(:,j,i)=data(:,j,i)-data(1,j,i); % pour enlever le premier point
                if Cycle_Table(3,j,i)==1
                    plot(data(1:end-1,j,i),'r')
                    hold on
                    
                end
            end
            
        else
            
            for j=1:fin(i)-1
                % data(:,j,i)=data(:,j,i)-data(1,j,i); % pour enlever le premier point
                if Cycle_Table(3,j,i)==1
                    plot(data(1:end-1,j,i),'b')
                    hold on
                    
                end
            end
        end
        
        
        temp=ginput(1);
        SyncThreshold(i)=temp(2);
        
        for j=1:fin(i)
            
            if Cycle_Table(3,j,i)==1
                temp=find((data(1:end-1,j,i)<SyncThreshold(i))&(diff(data(1:end,j,i))<0));
                if not(isempty(temp))
                    SyncTiming(i,j)=temp(1);
                    
                end
                
            end
            
        end
        

        for j=1:POST1(i)-FF1(i)
            stimtimingSync(j,i)=stimtiming(j,i)-SyncTiming(i,FF1(i)+j-1);
        end
        
    end
        
    save('CyclesCritiques','FF1','POST1','fin','RFLX','stimtiming','stimtimingSync')
        
        