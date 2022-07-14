function [SyncTiming, SyncThreshold, stimtimingSync] = SyncPushoff(Cycle_Table,data,subjects)
% SYNCPUSHOFF: This function synchronize all data on the middle of the 
% pushoff based on ankle kinematic data. (Introduced in Bouffard et al 2014
% JNeuroscience)
%   Input: CYCLE_TABLE: indicate valid/nonvalid, stride duration, FF/NoFF
    % DATA: contains data used for synchronization
    
    load('CyclesCritiques.mat')
    
    % Determine the number of participants
    N = length(Cycle_Table);
  
    
    question=menu('Do you already have a file with Synchronization information?','Yes','No');
    
         
    if question==1
        % If you already have a SyncData, load it
        
        load('SyncData.mat')
%         x=size(SyncTiming,1)+1;
%         
%     elseif question==2
%         % If you don't  have a SyncData, initialize it
%         
%         x=1;  
    end
    
    %% For each subject plot and select threshold
    % initialize the figure
    figure('units','normalized','outerposition',[0 0 1 1], ...
    'Name', 'Select the threshold closest to the middle of the pushoff, for which a maximal amount of strides will cross')

    for isubject=subjects
        clf
        stimtimingSync{isubject}=[];
        
        % If there is at least one stride with a force field, plot
        % baseline, FF and POST in different colors
        if FFlast(isubject)>0
            
            for istride=1:CTRLlast(isubject)
                % Plot baseline cycles in blue
                if Cycle_Table{isubject}(3,istride) == 1
                    % Plot data from 500 to the end to avoid initial
                    % plantar flexion 
                    
                    plot(data{isubject}{istride}(500:end-1),'b')
                    hold on
                    
                end
            end
            
            for istride=FFlast(isubject)+1:fin(isubject)
                % Plot POST cycles in green
                if Cycle_Table{isubject}(3,istride)==1
                    % Plot data from 500 to the end to avoid initial
                    % plantar flexion 
                    
                    plot(data{isubject}{istride}(500:end-1),'g')
                    hold on
                    
                end
            end
            
            for istride=CTRLlast(isubject)+1:FFlast(isubject)
                 % Plot FF cycles in green
                if Cycle_Table{isubject}(3,istride)==1
                    % Plot data from 500 to the end to avoid initial
                    % plantar flexion 
                    
                    plot(data{isubject}{istride}(500:end-1),'r')
                    hold on
                    
                end
            end
            
        else
            
            % If there is no  stride with a force field, plot all strides
            % in blue
            for istride=1:fin(isubject)
                if Cycle_Table{isubject}(3,istride) == 1
                    % Plot data from 500 to the end to avoid initial
                    % plantar flexion
                    
                    plot(data{isubject}{istride}(500:end-1),'b')
                    hold on
                    
                end
            end
        end
        
        % Select the threshold closest to the middle of the pushoff, for which a maximal amount of strides will cross
        [~,SyncThreshold(isubject)] = ginput(1);
        
        
        for istride=1:fin(isubject)
            
            %If the stride is valid
            if Cycle_Table{isubject}(3,istride) == 1
                
                % For each stride, determine the instant at which data cross the
                % threshold with a negative velocity.
                temp=find((data{isubject}{istride}(500:end-1)<SyncThreshold(isubject))&(diff(data{isubject}{istride}(500:end))<0));
                
                if ~isempty(temp)
                    % If the stride cross SyncThreshold with a negative
                    % velocity SyncTiming = the instant + 499 (because
                    % plots begin at 500)
                    SyncTiming{isubject}(istride)=temp(1)+499;
                else
                    % Else, set as nan
                    SyncTiming{isubject}(istride)=nan;
                end
                
            else
                    % If the stride is not valid , set as nan
                    SyncTiming{isubject}(istride)=nan;
            end
            
        end
        

        for istride=1:FFlast(isubject)-CTRLlast(isubject)
            % Correct the instant with peakFF for the synchronization
            % timing
            stimtimingSync{isubject}(istride)=stimtiming{isubject}(istride)-SyncTiming{isubject}(CTRLlast(isubject)+istride);
        end
        
    end
    
    close all
        
        