function AnalSignal = GenericAnalysis (Cycle_Table, data, conditions, criticalCycles, SyncData, Signal, subjects)
%GenericAnalysis: This function generate all ankle kinematic
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


question=menu(['Do you already have an Anal', Signal, ' file?'],'Yes','No');

if question==1
    % If there is already an AnalSignal file, load it and get the number of
    % subjects already analysed
    
    load(['Anal' Signal '.mat'])
    %     x=length(AnalSignal.(Signal).(conditions{1}));
    %
    % elseif question==2
    %     % If there is no AnalSignal file, initialize it
    %
    %     x=1;
end

for isubject=subjects
    disp(['processing subject ', num2str(isubject),' out of ', num2str(n)]) % display subject analyzed
    
    %% Patch if you want to do some subjects, we have to reset cell arrays
    if exist('AnalSignal','var')
        myfields=fieldnames(AnalSignal);
        
        for ifield = 1:length(myfields)
            
            if isstruct(AnalSignal.(myfields{ifield}))
                myfields2 = fieldnames(AnalSignal.(myfields{ifield}));
                
                for ifield2 = 1:length(myfields2)
                    
                    if iscell(AnalSignal.(myfields{ifield}).(myfields2{ifield2}))
                        AnalSignal.(myfields{ifield}).(myfields2{ifield2}){isubject}=[];
                    end
                end
                
            elseif iscell(AnalSignal.(myfields{ifield}))
                
                AnalSignal.(myfields{ifield}){isubject}=[];
                
            end
        end
    end
    
    %% process each condition
    for icond = 1 : length(conditions)
        if criticalCycles(icond,isubject)+1<criticalCycles(end,isubject) %if the file ends before the next condition, skip
            
            k=0;
            for istride=criticalCycles(icond,isubject)+1:criticalCycles(icond+1,isubject) % there is probably a way to vectorize this
                k=k+1;
                
                if Cycle_Table{isubject}(3,istride)==1 && SyncData.SyncTiming{isubject}(istride) < length(data{isubject}{istride})
                    % it the stride is valid, SyncTiming is not the last
                    % instant (or a NaN), Synchronize and interpolate the
                    % signal.
                    
                    x = 1 : length(data{isubject}{istride})-SyncData.SyncTiming{isubject}(istride)+1;
                    y = data{isubject}{istride}(SyncData.SyncTiming{isubject}(istride):end);
                    
                    AnalSignal.(Signal).(conditions{icond}){isubject}(1:1000,k)=interp1(x,y,1:(length(x)-1)/(999):length(x));
                    
                    % Duration of the analyzed period
                    AnalSignal.dureeswing.(conditions{icond}){isubject}(k)=length(x);
                    
                else
                    % If the trial is bad, set as Nan
                    AnalSignal.(Signal).(conditions{icond}){isubject}(1:1000,k)=nan;
                    AnalSignal.dureeswing.(conditions{icond}){isubject}(k)=nan;
                    
                end
                
                % Note the stride # (from the initial stride of GroupData),
                % correspond to the analyzed stride)
                AnalSignal.cycleID.(conditions{icond}){isubject}(k)=istride;
            end
            
            
            
            %% remove bad Signal
            % The function will plot synchronized Signal signal and analyzed
            % period duration to validate the synchronization quality.
            
            duree=AnalSignal.dureeswing.(conditions{icond}){isubject};
            tovalidate.Table=AnalSignal.(Signal).(conditions{icond}){isubject};
            
            bad_cycles=removebad_Superpose1(tovalidate,{Signal},...
                1:size(AnalSignal.(Signal).(conditions{icond}){isubject},2), 'Group', 'flagDuree', duree, 'flagMean');
            
            % Set selected strides as non valid
            Cycle_Table{isubject}(3,AnalSignal.cycleID.(conditions{icond}){isubject}(bad_cycles))=-1;
            
            AnalSignal.(Signal).(conditions{icond}){isubject}(:,bad_cycles)=nan;
            
            if icond == 1
                % If we are analyzing the first condition, build the baseline
                % Template (50 last baseline strides)
                AnalSignal.baseline2(:,isubject)=nanmean(AnalSignal.(Signal).(conditions{icond}){isubject}(:,end-49:end),2);
            end
            
            
            for istride=1:size(AnalSignal.(Signal).(conditions{icond}){isubject},2)
                
                AnalSignal.(['delta' Signal]).(conditions{icond}){isubject}(:,istride)=AnalSignal.(Signal).(conditions{icond}){isubject}(:,istride)-AnalSignal.baseline2(:,isubject);
                
                % Peak deltaSIGNAL with indices
                [AnalSignal.(['mindelta' Signal]).(conditions{icond}){isubject}(istride), AnalSignal.(['mindelta' Signal 'time']).(conditions{icond}){isubject}(istride)]...
                    = min(AnalSignal.(['delta' Signal]).(conditions{icond}){isubject}(:,istride));
                
                [AnalSignal.(['maxdelta' Signal]).(conditions{icond}){isubject}(istride), AnalSignal.(['maxdelta' Signal 'time']).(conditions{icond}){isubject}(istride) ]...
                    = max(AnalSignal.(['delta' Signal]).(conditions{icond}){isubject}(:,istride));
                
                % Peak Signal with indices
                [AnalSignal.(['min' Signal]).(conditions{icond}){isubject}(istride), AnalSignal.(['min' Signal 'time']).(conditions{icond}){isubject}(istride)]...
                    = min(AnalSignal.(Signal).(conditions{icond}){isubject}(:,istride));
                
                [AnalSignal.(['max' Signal]).(conditions{icond}){isubject}(istride), AnalSignal.(['max' Signal 'time']).(conditions{icond}){isubject}(istride)]...
                    = max(AnalSignal.(Signal).(conditions{icond}){isubject}(:,istride));
                
            end
        end
    end
end