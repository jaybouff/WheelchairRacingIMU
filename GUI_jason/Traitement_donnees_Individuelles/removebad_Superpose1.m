function bad_cycles = removebad_Superpose1( data, signal, cycles, type, varargin)
%REMOVEBAD_SUPERPOSE1: This function is used to remove bad cycles using
%selected signals.
%   INPUT: data: matrix or Cell array of individual strides.  Config file generated with XXX FUNCTION. Filtered data.
%'flagDuree' plot individual strides duration for validation.
%   OUTPUT: None. Table_data saved..
%
%   Initially developed by Martin Noel and Laurent Bouyer. Modified by
%   Jason Bouffard

if strcmp(type, 'Group')
    % If we work with Group data, we only validate one signal
    data.config.chan_name=signal;
    
    if sum(strcmp(varargin, 'flagDuree')) == 1
        % If we work with GroupData and have flag Duree, Cycle duration is
        % entered as the variable following the 'flagDuree' TO CHANGE
        data.Cycle_Table(cycles,1) = 1;
        data.Cycle_Table(cycles,2)=cell2mat(varargin(find(strcmp(varargin,'flagDuree'))+1));
    end
    
end

 
myfig = figure('units','normalized','outerposition',[0 0 1 1], ...
    'Name', 'Select bad strides, and click in the white space when finished')
% Determine the number of additional needed for 'flagDuree' and/or
% 'flagMean'
otherplots = sum(strcmp(varargin, 'flagDuree')|strcmp(varargin, 'flagMean'));
bad_cycles=[];
%% For each signal, configure the data to be ploted
for isignal=length(signal):-1:1
    
    %Place the subplot for isignal
    subplot(length(signal)+otherplots,1,isignal)
    hold on
    
    % find Table number of each SIGNAL used to validate
    validnum(isignal)=find(strcmp(data.config.chan_name,signal{isignal})==1);
    
    if iscell(data.Table)
        % if input is a cell array, use cellfun
        
        %determine the max/min of each stride, than compute overall max/min to
        %adjust axes
        top(isignal)=max(cellfun(@(x)(max(x(:,validnum(isignal)))),data.Table));
        bottom(isignal)=min(cellfun(@(x)(min(x(:,validnum(isignal)))),data.Table));
        
        % plot each stride of the signal as an handle
        h(cycles,isignal)=cellfun(@(x)(plot(x(:,validnum(isignal)))),data.Table(cycles));
        
    elseif isnumeric(data.Table)
        % if input is a matrix,  we need to add 'omitnan' as matrix are padded
        %with NaNs.
        
        % determine the max/min of each stride, than compute overall max/min
        top(isignal) = max(max(data.Table(:,cycles),[],'omitnan'));
        bottom(isignal) = min(min(data.Table(:,cycles),[],'omitnan'));
        
        % plot each stride of the signal as an handle
        h(cycles,isignal)=plot(data.Table(:,cycles));
        
    end
    
    % set all plots to blue (valid)
    set(h(cycles,isignal),'color','b');
    
    % adjust axes
    a=axis;
    axis([a(1) a(2) bottom(isignal) top(isignal)])
    
end %For isignal

% Plot stride duration if 'flagDuree' is in VarArgin
if sum(strcmp(varargin, 'flagDuree')) == 1
    
    
    for icycle=1:length(cycles)
        % Place the stride duration plot next to all signals
        subplot(length(signal)+otherplots,1,length(signal)+1)
        
        % for each stride plot stride duration as a function of stride number
        h(cycles(icycle),length(signal)+1)=plot(cycles(icycle),data.Cycle_Table(cycles(icycle),2)-data.Cycle_Table(cycles(icycle),1)); % should change to duration
        hold on
        
        % set all strides to valid (blue)
        set(h(cycles(icycle),length(signal)+1),'color','b','marker','o');
        
    end
    
end

% Plot mean value of the first signal if flag in varargin
if sum(strcmp(varargin, 'flagMean')) == 1
    
    for icycle=1:length(cycles)
        
        % Place the mean value plot next to all signals and next to stride
        % duration plot (if 'flagDuree')
        subplot(length(signal)+otherplots,1,length(signal)+otherplots)
        hold on
        
        if iscell(data.Table)
            % plot mean value of each signal as an handle
            
            h(cycles(icycle),length(signal)+otherplots) = plot(cycles(icycle),nanmean(data.Table{cycles(icycle)}(:,1)));
        elseif isnumeric(data.Table)
            h(cycles(icycle),length(signal)+otherplots) = plot(cycles(icycle),nanmean(data.Table(:,cycles(icycle))));
            
        end
        
        % set all strides to valid (blue)
        set(h(cycles(icycle),length(signal)+otherplots),'color','b','marker','o');
        
    end
    
end


%% clean data
% Initialize variables
count=0;
over=0;

while over~=1
    
    % Select bad cycles
    waitforbuttonpress;
    hz = gco;
    
    % If user clicked on an an object, get its ID
    [bad,~] = find(h==hz);
    
    if not(isempty(bad))
        % Set all signals of the selected strides as potentially non valid (red)
        set(h(bad,1:length(signal)),'color','r','linewidth',2);
        ylabel(bad);
        
        if sum(strcmp(varargin, 'flagMean')) == 1 || sum(strcmp(varargin, 'flagDuree')) == 1
            set(h(bad,length(signal)+1:length(signal)+otherplots),'color','r','marker','o');
        end
        
        % Bring selected  stride to front
        for isignal=1:length(signal)
            uistack(h(bad,isignal),'top');
        end
        
        confirmation=menu(['Stride #', num2str(bad), ', Non valid?'],'Yes','No');
        
        if confirmation==1
            % If the selected stride is bad, delete from the graph and save
            % its ID
            delete(h(bad,:))
            count=count+1;
            bad_cycles(count)=bad;
            
        else
            
            % If the selected stride is not bad, set to valid (blue)
            set(h(bad,1:length(signal)),'color','b','linewidth',0.5);
            
            if sum(strcmp(varargin, 'flagMean')) == 1 || sum(strcmp(varargin, 'flagDuree')) == 1
                set(h(bad,length(signal)+1:length(signal)+otherplots),'color','b','marker','o');
            end
            
        end %if
        
    else
        
        %If the user selected no object (click in the white space), it is
        %over
        over=menu('Are you done selecting bad trials?','Yes','No');
        
    end %if
end %while

close(myfig) 
