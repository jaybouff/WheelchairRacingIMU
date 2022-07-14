function [SyncData] = SyncPushoffProprio(Cycle_Table,data, conditions, chan_ENCO)
% SYNCPUSHOFFProprio: This function synchronize all data on the middle of the 
% pushoff based on ankle kinematic data. (Introduced in Bouffard et al 2014
% JNeuroscience), used for individual subjects
%   Input: CYCLE_TABLE: indicate valid/nonvalid, stride duration, FF/NoFF
    % DATA: contains data used for synchronization
    colors = {'b','r','g','k','m','c'};
    %% For each subject plot and select threshold
    % initialize the figure
    figure('units','normalized','outerposition',[0 0 1 1], ...
    'Name', 'Select the threshold closest to the middle of the pushoff, for which a maximal amount of strides will cross')

       for icond = 1:length(conditions) 
           
            for istride=1:length(conditions{icond})
                stride=conditions{icond}(istride);
                % Plot baseline cycles in blue
                if Cycle_Table(istride,3) == 1
                    % Plot data from 500 to the end to avoid initial
                    % plantar flexion 
                    
                    plot(data{stride}(500:end-1,chan_ENCO),colors{icond})
                    hold on
                    
                end
            end
       end
            
        % Select the threshold closest to the middle of the pushoff, for which a maximal amount of strides will cross
        [~,SyncData.SyncThreshold] = ginput(1);
        
        
        for istride=1:length(data)
            
            %If the stride is valid
            if Cycle_Table(istride,3) == 1
                
                % For each stride, determine the instant at which data cross the
                % threshold with a negative velocity.
                temp=find((data{istride}(500:end-1,chan_ENCO) < SyncData.SyncThreshold)&(diff(data{istride}(500:end,chan_ENCO))<0));
                
                if ~isempty(temp)
                    % If the stride cross SyncThreshold with a negative
                    % velocity SyncTiming = the instant + 499 (because
                    % plots begin at 500)
                    SyncData.SyncTiming(istride)=temp(1)+499;
                else
                    % Else, set as nan
                    SyncData.SyncTiming(istride)=nan;
                end
                
            else
                    % If the stride is not valid , set as nan
                    SyncData.SyncTiming(istride)=nan;
            end
            
        end
        
        
    
    
    close 
        
        