function AnalCOUPLE = COUPLEtimenormvariablesgenerator (Cycle_Table, data, conditions, criticalCycles, SyncData)
%COUPLEtimenormvariablesgenerator: This function generate all ankle kinematic
%variables published in Bouffard et al 2014,2016 and 2018 on pain and Motor
%learning.
%   INPUT: Cycle_Table, indicates if strides are valid or not, if the have
%   a force field or not, etc. 
%   data: COUPLE signal (Group cell arrays
%   conditions: conditions to test (e.g. baseline, FF, POST)
%   SyncData: Synchronization signal and indices (e.g. mid pushoff)


    
% catch Errors in data input
if length(conditions)+1 ~= size(criticalCycles,1)
    error('conditions length mismatch', 'conditions and criticalCycles input must be the same lenght');
end

% Determine the number of participants to analyze

n=length(Cycle_Table);

% Load Sync data and critical strides


question=menu('Do you already have an AnalCOUPLE file?','Yes','No');

if question==1
    % If there is already an AnalENCO file, load it and get the number of
    % subjects already analysed
    
    load('AnalCOUPLE.mat')
    x=length(AnalCOUPLE.COUPLE.(conditions{1}));
    
elseif question==2
    % If there is no AnalENCO file, initialize it
    
    x=1;
end

for isubject=x:n
    disp(['processing subject ', num2str(isubject),' out of ', num2str(n)]) % display subject analyzed
    
    for icond = 1 : length(conditions)
        
        k=0;
        for istride=criticalCycles(icond,isubject)+1:criticalCycles(icond+1,isubject) % there is probably a way to vectorize this
            k=k+1;
            
            if Cycle_Table{isubject}(3,istride)==1 && SyncData.SyncTiming{isubject}(istride) < length(data{isubject}{istride})
                % it the stride is valid, SyncTiming is not the last
                % instant (or a NaN), Synchronize and interpolate the
                % signal.
                
                x = 1 : length(data{isubject}{istride})-SyncData.SyncTiming{isubject}(istride)+1;
                y = data{isubject}{istride}(SyncData.SyncTiming{isubject}(istride):end);
                
                AnalCOUPLE.COUPLE.(conditions{icond}){isubject}(:,k)=interp1(x,y,1:(length(x)-1)/(999):length(x));
                
                % Duration of the analyzed period
                AnalCOUPLE.dureeswing.(conditions{icond}){isubject}(k)=length(x);
                
            else
                % If the trial is bad, set as Nan
                AnalCOUPLE.COUPLE.(conditions{icond}){isubject}(:,k)=nan;
                AnalCOUPLE.dureeswing.(conditions{icond}){isubject}(k)=nan;
                
            end
            
        % Note the stride # (from the initial stride of GroupData),
        % correspond to the analyzed stride)
        AnalCOUPLE.cycleID.(conditions{icond}){isubject}(k)=istride;    
        end
        
        
        
        %% remove bad COUPLE
        % The function will plot synchronized COUPLE signal and analyzed
        % period duration to validate the synchronization quality.
        
        duree=AnalCOUPLE.dureeswing.(conditions{icond}){isubject};
        tovalidate.Table=AnalCOUPLE.COUPLE.(conditions{icond}){isubject};
        
        bad_cycles=removebad_Superpose1(tovalidate,{'COUPLE'},...
            1:size(AnalCOUPLE.COUPLE.(conditions{icond}){isubject},2), 'Group', 'flagDuree', duree);
        
        % Set selected strides as non valid
        Cycle_Table{isubject}(3,AnalCOUPLE.cycleID.(conditions{icond}){isubject}(bad_cycles))=-1;
        
        AnalCOUPLE.COUPLE.(conditions{icond}){isubject}(:,bad_cycles)=nan;
        
        if icond == 1
            % If we are analyzing the first condition, build the baseline
            % Template (50 last baseline strides)
            AnalCOUPLE.baseline2(:,isubject)=nanmean(AnalCOUPLE.COUPLE.(conditions{icond}){isubject}(:,end-49:end),2);
        end
    
   
    for istride=1:size(AnalCOUPLE.COUPLE.(conditions{icond}){isubject},2)
        
        AnalCOUPLE.deltaCOUPLE.(conditions{icond}){isubject}(:,istride)=AnalCOUPLE.COUPLE.(conditions{icond}){isubject}(:,istride)-AnalCOUPLE.baseline2(:,isubject);
        
        % Peak deltaCOUPLE with indices
        [AnalCOUPLE.mindeltaCOUPLE.(conditions{icond}){isubject}(istride), AnalCOUPLE.mindeltaCOUPLEtime.(conditions{icond}){isubject}(istride)]...
            = min(AnalCOUPLE.deltaCOUPLE.(conditions{icond}){isubject}(:,istride));
        
        [AnalCOUPLE.maxdeltaCOUPLE.(conditions{icond}){isubject}(istride), AnalCOUPLE.maxdeltaCOUPLEtime.(conditions{icond}){isubject}(istride) ]...
            = max(AnalCOUPLE.deltaCOUPLE.(conditions{icond}){isubject}(:,istride));
        
        % Peak COUPLE with indices
        [AnalCOUPLE.minCOUPLE.(conditions{icond}){isubject}(istride), AnalCOUPLE.minCOUPLEtime.(conditions{icond}){isubject}(istride)]...
            = min(AnalCOUPLE.COUPLE.(conditions{icond}){isubject}(:,istride));
        
        [AnalCOUPLE.maxCOUPLE.(conditions{icond}){isubject}(istride), AnalCOUPLE.maxCOUPLEtime.(conditions{icond}){isubject}(istride)]...
            = max(AnalCOUPLE.COUPLE.(conditions{icond}){isubject}(:,istride));

    end
    end
end