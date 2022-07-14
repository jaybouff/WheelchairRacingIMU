function [GroupData] = TimeNormGroup(GroupData)
%TimeNormGroup Interpolate GroupTables to 1000 data points
%   Input and output: GroupData structure: Contains Signals to interpolate
%   and Cycle_Table matrix containing onset and offset of each stride

Signal = input('Which signals would you like to integrate? Write {''SignalName1'', ''SignalName2'', ..., ''SignalNameN''');


for isubject=1:length(GroupData.Cycle_Table)
    
    for istride=1:size(GroupData.Cycle_Table{isubject},2)
        
        dureecycle=GroupData.Cycle_Table{isubject}(2,istride)-GroupData.Cycle_Table{isubject}(1,istride);
        x = 1:dureecycle+1;
        
        for isignal = 1:length(Signal)
            
            y = GroupData.(Signal{isignal}){isubject}{istride};
            GroupData.([Signal{isignal}, 'NORM']){isubject}(:,istride)=interp1(x,y,1:(dureecycle)/999:dureecycle+1);
            
        end      
    end
end

