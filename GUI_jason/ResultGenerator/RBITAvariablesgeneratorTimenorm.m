
function [AnalTA]= RBITAvariablesgeneratorTimenorm(Cycle_Table,data,conditions,criticalCycles,AnalTA,SyncData, subjects)
%TAvariablesgenerator: This function generate RBITA analysis
%variables published in Bouffard et al 2014,2016 and 2018 on pain and Motor
%learning.
%   INPUT: Cycle_Table, indicates if strides are valid or not, if the have
%   a force field or not, etc.
%Date

% catch Errors in data input
if length(conditions)+1 ~= size(criticalCycles,1)
    error('conditions length mismatch', 'conditions and criticalCycles input must be the same lenght');
end

% Determine the number of participants to analyze
n=length(Cycle_Table);
%
% if isfield(AnalTA,'TA')
%
%     % If there is already an AnalTA file, find the last subject analysed
%
%     x=length(AnalTA.TA.(conditions{1}));
%
% else
%     %else, initialize the file
%     x=1;
%
% end


for isubject=subjects
    disp(['processing subject ', num2str(isubject),' out of ', num2str(n)]) % display subject analyzed
    
    %% Patch if you want to do some subjects, we have to reset cell arrays
    if ~isempty(AnalTA)
        
        myfields=fieldnames(AnalTA);
        
        for ifield = 1:length(myfields)
            
            if isstruct(AnalTA.(myfields{ifield}))
                myfields2 = fieldnames(AnalTA.(myfields{ifield}));
                
                for ifield2 = 1:length(myfields2)
                    
                    if iscell(AnalTA.(myfields{ifield}).(myfields2{ifield2}))
                        AnalTA.(myfields{ifield}).(myfields2{ifield2}){isubject}=[];
                    end
                end
                
            elseif iscell(AnalTA.(myfields{ifield}))
                
                AnalTA.(myfields{ifield}){isubject}=[];
                
            end
        end
    end
    
    %% process each condition
    for icond = 1 : length(conditions)
        
        if criticalCycles(icond,isubject)+1<criticalCycles(end,isubject) %if the file ends before the next condition, skip
            
            k=0;
            
            for istride=criticalCycles(icond,isubject)+1:criticalCycles(icond+1,isubject) % there is probably a way to vectorize this
                k=k+1;
                
                if max(SyncData.SyncTiming{isubject})>1 % we use a real SyncTiming file (not only ones)we extend the swing
                    % phase duration by 30% so timenorm on 1300 points
                    
                    if Cycle_Table{isubject}(3,istride)==1 && SyncData.SyncTiming{isubject}(istride) < length(data{isubject}{istride}) % if a valid stride
                        % it the stride is valid, SyncTiming is not the last
                        % instant (or a NaN), Synchronize and interpolate the
                        % signal.
                        
                        % Duration of the analyzed period, for EMG, we extend the swing
                        % phase duration by 30%
                        AnalTA.dureeswing.(conditions{icond}){isubject}(k)=length(data{isubject}{istride})-SyncData.SyncTiming{isubject}(istride)+1;
                        
                        
                        x = 1 : round(AnalTA.dureeswing.(conditions{icond}){isubject}(k)*1.3);
                        y = data{isubject}{istride}(SyncData.SyncTiming{isubject}(istride)-round(AnalTA.dureeswing.(conditions{icond}){isubject}(k)*0.3):end);
                        
                        AnalTA.TA.(conditions{icond}){isubject}(1:1300,k)=interp1(x,y,1:(length(x)-1)/(1299):length(x));
                        
                    else % if not valid
                        
                        AnalTA.TA.(conditions{icond}){isubject}(1:1300,k)=nan;
                        AnalTA.dureeswing.(conditions{icond}){isubject}(k)=nan;
                        
                    end
                    
                else % If we use  synctiming containing only ones (whole strides) (timenorm on 1000 points)
                    
                    if Cycle_Table{isubject}(3,istride)==1 % if valid
                        
                        x = 1:length(data{isubject}{istride});
                        y = data{isubject}{istride};
                        AnalTA.TA.(conditions{icond}){isubject}(1:1000,k)=interp1(x,y,1:(length(x)-1)/(999):length(x));
                        
                    else
                        
                        AnalTA.TA.(conditions{icond}){isubject}(1:1000,k)=nan;
                        AnalTA.dureeswing.(conditions{icond}){isubject}(k)=nan;
                        
                    end
                end
                
                % Note the stride # (from the initial stride of GroupData),
                % correspond to the analyzed stride)
                AnalTA.cycleID.(conditions{icond}){isubject}(k)=istride;
                
            end
            
            %%remove bad TA
            % The function will plot synchronized TA signal and analyzed
            % period duration to validate the synchronization quality and mean value.
            duree=AnalTA.dureeswing.(conditions{icond}){isubject};
            
            tovalidate.Table=AnalTA.TA.(conditions{icond}){isubject};
            
            bad_cycles=removebad_Superpose1(tovalidate,{'TA'},...
                1:size(AnalTA.TA.(conditions{icond}){isubject},2), 'Group', 'flagMean',...
                'flagDuree',duree);
            
            % Set selected strides as non valid
            
            Cycle_Table{isubject}(3,AnalTA.cycleID.(conditions{icond}){isubject}(bad_cycles))=-1;
            AnalTA.TA.(conditions{icond}){isubject}(:,bad_cycles)=nan;
            
        end
    end
end

