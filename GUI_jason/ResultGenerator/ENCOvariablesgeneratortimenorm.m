function [AnalENCO]=ENCOvariablesgeneratortimenorm(Cycle_Table, data, conditions, criticalCycles, SyncData, subjects)
%ENCOvariablesgeneratortimenorm: This function generate all ankle kinematic
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

% Load Sync data and critical strides


question=menu('Do you already have an AnalENCO file?','Yes','No');

if question==1
    % If there is already an AnalENCO file, load it and get the number of
    % subjects already analysed
    
    load('AnalENCO.mat')
    %     x=length(AnalENCO.ENCO.(conditions{1}));
    %
    % elseif question==2
    %     % If there is no AnalENCO file, initialize it
    %
    %     x=1;
end

for isubject=subjects
    disp(['processing subject ', num2str(isubject),' out of ', num2str(n)]) % display subject analyzed
    
    %% Patch if you want to do some subjects, we have to reset cell arrays
    if exist('AnalENCO','var')
        myfields=fieldnames(AnalENCO);
        
        for ifield = 1:length(myfields)
            
            if isstruct(AnalENCO.(myfields{ifield}))
                myfields2 = fieldnames(AnalENCO.(myfields{ifield}));
                
                for ifield2 = 1:length(myfields2)
                    
                    if iscell(AnalENCO.(myfields{ifield}).(myfields2{ifield2}))
                        AnalENCO.(myfields{ifield}).(myfields2{ifield2}){isubject}=[];
                    end
                end
                
            elseif iscell(AnalENCO.(myfields{ifield}))
                
                AnalENCO.(myfields{ifield}){isubject}=[];
                
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
                    
                    AnalENCO.ENCO.(conditions{icond}){isubject}(1:1000,k)=interp1(x,y,1:(length(x)-1)/(999):length(x));
                    
                    % Duration of the analyzed period
                    AnalENCO.dureeswing.(conditions{icond}){isubject}(k)=length(x);
                    
                else
                    % If the trial is bad, set as Nan
                    AnalENCO.ENCO.(conditions{icond}){isubject}(1:1000,k)=nan;
                    AnalENCO.dureeswing.(conditions{icond}){isubject}(k)=nan;
                    
                end
                
                % Note the stride # (from the initial stride of GroupData),
                % correspond to the analyzed stride)
                AnalENCO.cycleID.(conditions{icond}){isubject}(k)=istride;
            end
            
            
            %% remove bad ENCO
            % The function will plot synchronized ENCO signal and analyzed
            % period duration to validate the synchronization quality.
            
            duree=AnalENCO.dureeswing.(conditions{icond}){isubject};
            tovalidate.Table=AnalENCO.ENCO.(conditions{icond}){isubject};
            
            bad_cycles=removebad_Superpose1(tovalidate,{'ENCO'},...
                1:size(AnalENCO.ENCO.(conditions{icond}){isubject},2), 'Group', 'flagDuree', duree);
            
            % Set selected strides as non valid
            Cycle_Table{isubject}(3,AnalENCO.cycleID.(conditions{icond}){isubject}(bad_cycles))=-1;
            
            AnalENCO.ENCO.(conditions{icond}){isubject}(:,bad_cycles)=nan;
            
            if icond == 1
                % If we are analyzing the first condition, build the baseline
                % Template (50 last baseline strides)
                BASELINEend = size(AnalENCO.ENCO.(conditions{icond}){isubject},2);
                tempbaseline2=nanmean(AnalENCO.ENCO.(conditions{icond}){isubject}(:,BASELINEend-49:BASELINEend),2); %
                
                % We keep the 45 most representative strides for the actial
                % baseline template
                tempdeltaENCO=AnalENCO.ENCO.(conditions{icond}){isubject}(:,:)-tempbaseline2;
                tempmeanABSError = mean(abs(tempdeltaENCO));
                
                novalid = find(isnan(tempmeanABSError(end-49:end)));
                if length(novalid) > 5
                    % If there is MORE than 5 non valid strides among the last
                    % 50, take all valid strides for the template
                    menu([num2str(isubject),'>10% baseline no valid'],'OK')
                    AnalENCO.baseline2(:,isubject) = tempbaseline2;
                    
                    % save baseline strides number
                    tempcycles = find(~isnan(AnalENCO.ENCO.(conditions{icond}){isubject}(1,BASELINEend-49:BASELINEend)));
                    AnalENCO.CyclesBaseline{isubject}= tempcycles +BASELINEend - 50;
                    
                else
                    % If there is LESS than 5 non valid strides among the last
                    % 50, the 45 most representative strides and save baseline strides number
                    temp=sort(tempmeanABSError(end-49:end));
                    tempcycles=find(ismember(tempmeanABSError(end-49:end),temp(1:45)));
                    
                    AnalENCO.CyclesBaseline{isubject}=tempcycles+BASELINEend-50;
                    AnalENCO.baseline2(:,isubject)=mean(AnalENCO.ENCO.(conditions{icond}){isubject}(:,AnalENCO.CyclesBaseline{isubject}),2);
                    
                end
            end
            
            
            % Subtract ENCO baseline template from each stride for the assessed
            % condition
            AnalENCO.deltaENCO.(conditions{icond}){isubject}=AnalENCO.ENCO.(conditions{icond}){isubject}-AnalENCO.baseline2(:,isubject);
            
            % find Maximal dorsiflexion error (difference from baseline template) and its timing
            [AnalENCO.MaxDorsiError.(conditions{icond}){isubject},  AnalENCO.MaxDorsiErrortiming.baseline2{isubject}] ...
                =max(AnalENCO.deltaENCO.(conditions{icond}){isubject});
            
            % find Maximal plantarflexion error (difference from baseline template) and its timing
            [AnalENCO.MaxPlantError.(conditions{icond}){isubject}, AnalENCO.MaxPlantErrortiming.baseline2{isubject}]...
                =min(AnalENCO.deltaENCO.(conditions{icond}){isubject});
            
            % Find maximal dorsiflexion angle and its timing; start looking
            % after the first 20% to avoid the end of pushoff
            [AnalENCO.peakDorsi.(conditions{icond}){isubject}, AnalENCO.PeakDorsitiming.baseline2{isubject}]...
                =max(AnalENCO.ENCO.(conditions{icond}){isubject}(200:1000,:));
            AnalENCO.PeakDorsitiming.baseline2{isubject} =AnalENCO.PeakDorsitiming.baseline2{isubject}+199;
            
            % Find maximal plantarflexion angle and its timing
            [AnalENCO.peakPlant.(conditions{icond}){isubject}, AnalENCO.peakPlanttiming.baseline2{isubject}]...
                =min(AnalENCO.ENCO.(conditions{icond}){isubject}(1:600,:));
            
            % Compute maximal absolute and signed errors (difference from
            % baseline template)
            AnalENCO.meanABSError.(conditions{icond}){isubject}=mean(abs(AnalENCO.deltaENCO.(conditions{icond}){isubject}));
            AnalENCO.meanSIGNEDError.(conditions{icond}){isubject}=mean(AnalENCO.deltaENCO.(conditions{icond}){isubject});
            
            % If we are assessing Force field condition, compute the relative
            % timing error
            if strcmp(conditions{icond},'CHAMP')
                
                for istride = 1: criticalCycles(icond+1,isubject) - criticalCycles(icond,isubject)
                    
                    weight=abs(AnalENCO.deltaENCO.CHAMP{isubject}(:,istride)).*[1:1000]';
                    
                    AnalENCO.CoG.(conditions{icond}){isubject}(istride)=sum(weight)/sum(abs(AnalENCO.deltaENCO.(conditions{icond}){isubject}(:,istride)));
                    AnalENCO.normPFC.(conditions{icond}){isubject}(istride)=SyncData.stimtimingSync{isubject}(istride)*1000/AnalENCO.dureeswing.(conditions{icond}){isubject}(istride);
                    AnalENCO.CoGrelatif.(conditions{icond}){isubject}(istride)=AnalENCO.CoG.(conditions{icond}){isubject}(istride)-AnalENCO.normPFC.(conditions{icond}){isubject}(istride);
                    
                end
            end
        end
    end
end