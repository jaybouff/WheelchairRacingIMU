
function GroupData = GroupTablesGenerator
%GROUPTABLESGENERATOR This function is used to combine multiple subjects'
%data. Data must have been cut into Tables and validated. 
%   No input, all necessary files are loaded in the function

Question = menu('Do you already have a GroupData file?','Yes','No');
Signal = input('Which signals would you like to integrate? Write {''SignalName1'', ''SignalName2'', ..., ''SignalNameN''');


if Question==1
    %If you already have a GroupData file, load it
    
    [filename,pathname] = uigetfile('*.mat','Select your GroupData file');
    load([pathname,filename]);
    
    % Determine the number of participants already included in GroupData
    N = length(GroupData.(Signal{1}));
    
else
    % If you create a new GroupData file, initiate it
    N=0;
   
end

Question=menu('Do you have new subjects to integrate to GroupData?','Yes', 'No');

while Question==1 %'Do you have new subjects to integrate to GroupData?','Yes', 'No'
    
    % Increment subject index
    N=N+1;
    
    % Load your subject's data
    [filename,pathname]=uigetfile('*.mat','Select your Subject Table_data.mat file');
    load([pathname,filename]);
      
    for isignal=1:length(Signal)
        % For each Signal, find the Table with chan_name == Signal
        numSignal=find(strcmp(config.chan_name(1,:),Signal{isignal}));
        
        % Integrate Participant's data for the signal to GroupData.Signal 
        GroupData.(Signal{isignal}){N} = cellfun(@(x)({x(:,numSignal)}),Table);
         
                
    end
    
    % Integrate Cycle_Table (including trials duration, valid/nonvalid,
    % FF/noFF, etc.
    GroupData.Cycle_Table{N}=Cycle_Table(:,:)';
    
    Question = menu('Do you have new subjects to integrate to GroupData?','Yes', 'No');
end %while Question

%% When all participants are integrated, save the file
[filename,pathname]=uiputfile('*.mat');
save([pathname,filename],'GroupData','-v7.3'); %-v7.3: compress file
