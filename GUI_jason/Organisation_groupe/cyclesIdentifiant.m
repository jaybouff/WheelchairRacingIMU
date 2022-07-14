function [CTRLlast, FFlast, fin, RFLX, stimtiming]=cyclesIdentifiant(Cycle_Table,CONS_F)
%CYCLESIDENTIFIANT: This function extract critical cycles from Cycle_Table
%   to facilitate further analyses
   
   % Determine the number of participants in Cycle_Table variable
   n=length(Cycle_Table);
   
    for isubject=1:n
        % Note strides with force field
        FF=find(Cycle_Table{isubject}(5,:)==1);
        % Note the last stride of the file   
        fin(isubject)=size(Cycle_Table{isubject},2);
            
      
        if length(FF)>0
            % If there is at least one trial with force field, find the
            % first stride with the force field and the first after force
            % field
            
            CTRLlast(isubject)=FF(1)-1;
            FFlast(isubject)=FF(end);
            
        else
            % If there is no force field for the subject, set FF1 and POST1 as NaN            
            CTRLlast(isubject)=nan;
            FFlast(isubject)=nan;
        end
        
        %% Find the strides with reflexes (or catch/anticatch)
        isRFLX=find(Cycle_Table{isubject}(4,:)==1);
    
    if length(isRFLX) > 0
        % If there is at least one trial with reflexes, note all strides
        % with RFLXs
        
        RFLX{isubject}=isRFLX;
    else
        % If there is no reflexes, set RFLX as NaN
        
        RFLX{isubject}=nan;
    end
    
    end
    
    %% If there is an CONS_F as input signal, run StimulationTime to find the timing of each FF within the stride
    if exist('CONS_F')
        stimtiming=StimulationTime(CTRLlast, FFlast, CONS_F);
    else
        stimtiming=nan;
    end

        
    
    
