function cutTable_Raph(config,fdata,trialID) 
%CUTTABLE_LOKOMATH: This function is used to cut continuous data vectors 
%into separate strides based on the the selected Sync_Channel. Also create
%Cycle_Table with key events (FF or Reflexes). 
%   INPUT: Config file generated with XXX FUNCTION. Filtered data.
%   OUTPUT: None. Table_data saved..
%   
%   Initially developed by Martin Noel and Laurent Bouyer. Modified by
%   Jason Bouffard



%% Select data of the channel to be used for synchronisation
signal=fdata(:,config.Sync_channel)*config.trig_gain;

if config.trig_lowpass > 0
    % If you want to apply a lowpass filter to sync channel (e.g. EMG)
    [b,a]=butter(config.trig_Nlowpass,config.trig_lowpass/config.sFz*2);
    signal = filtfilt(b,a,signal);
end

if config.trig_diff > 0
    % If you want to differentiate your sync channel
    signal = diff(signal,config.trig_diff)*config.sFz;
end
% Decimate signal to accelerate the process
signal=decimate(signal,5);

   
    identifiant_init = [1;find(islocalmin(signal, 1,'MinSeparation', config.min_duration*config.sFz/5,'MinProminence',config.min_peakprominence,'FlatSelection', 'first'))];

   
    
    %% Validation and correction
figure(2)
clf
plot(signal,'k')
hold on

for icycle=1:length(identifiant_init)
        % Place the stride duration plot next to all signals
        
        % for each stride plot stride duration as a function of stride number
        h(icycle)=plot(identifiant_init(icycle),signal(identifiant_init(icycle))); % should change to duration
        hold on
        
        % set all strides to valid (blue)
        set(h(icycle),'color','b','marker','o');
        title('click in the graph to delete/add a marker, zoom in, or continue to next step')
        
        
       % Wait for the most recent key to become the return/enter key   
        
        
end

choice =0;
while choice ~= 1
    [cursor,~]=ginput(1);
    
    % If user clicked on an an object, get its ID
    bad = find(abs(identifiant_init-cursor)==min(abs(identifiant_init-cursor),[],'omitnan'));
    set(h(bad),'color','r','marker','o');
    
    h(length(h)+1)=plot(cursor,signal(round(cursor)));
    set(h(end),'color','g','marker','o');
    
    
    choice = menu('What do you want to do', 'Stop correcting cycles','Zoom in','Delete red marker','Add green marker','Zoom out','delete many cycles');
    
    
    
 

    if choice == 2
        
        zoom on
        %title('press enter when ready to continue')
        menu('Click ok to continue','OK')
        zoom off
        delete(h(end))
         set(h(bad),'color','b','marker','o');

        
     elseif choice == 3
         delete(h(bad))
         identifiant_init(bad)=nan;
         delete(h(end))
          h = h(~isnan(identifiant_init));

         identifiant_init = identifiant_init (~isnan(identifiant_init));


         
    elseif choice == 4
            set(h(end),'color','b','marker','o');
                     set(h(bad),'color','b','marker','o');

            identifiant_init(length(identifiant_init)+1)=cursor;
            
    
    elseif choice ==5
        zoom out
        delete(h(end))
                 set(h(bad),'color','b','marker','o');
                 
    elseif choice ==6
        title('Place a second cursor, all markers between the red one and this cursor will be deleted');
        [cursor2,~]=ginput(1);
        bads = find(identifiant_init>min([cursor,cursor2])&identifiant_init<max([cursor,cursor2]));
         identifiant_init([bad;bads])=nan;
         delete(h(end))
        delete(h([bad;bads]))
        h = h(~isnan(identifiant_init));
         identifiant_init = identifiant_init (~isnan(identifiant_init));
         


        
    end
    

 

    
end

identifiant_init = sort(identifiant_init (~isnan(identifiant_init)));
    
    %% We build Cycle_Table which contains: 
    %1, beginning of the strides
    %2, end of the stride
    %3, is the stride valid?(no strides are valid before validation)
    
Cycle_Table(:,1)= identifiant_init(1:end-1)*5;% *5 because of decimation factor
Cycle_Table(:,2)= identifiant_init(2:end)*5;
Cycle_Table(:,3) = 0;

newtrial = [1,find(diff(trialID)>0),length(trialID)];

for itrial = 2:length(newtrial)
    mypush = find(Cycle_Table(:,2)<newtrial(itrial) & Cycle_Table(:,2)>newtrial(itrial-1));
    Cycle_Table(mypush,4)=itrial-1;
    Cycle_Table(mypush,5)=1:length(mypush);
end


    myfig = figure('units','normalized','outerposition',[0 0 1 1]);
    % We show the cycle duration and ask if the user is happy
    plot(1:size(Cycle_Table,1),(Cycle_Table(:,2)-Cycle_Table(:,1))/config.sFz,'bo')
    axes=axis;
    axis([axes(1),axes(2),0,2]);
    

%% Create the tables

h=waitbar(0,'please wait');
for istride=size(Cycle_Table,1):-1:1
    
    waitbar(istride/size(Cycle_Table,1),h);
         
        Table{istride} = bsxfun(@times,fdata(Cycle_Table(istride,1):Cycle_Table(istride,2),:),config.chan_gain);
      %  Table{istride} = fdata(Cycle_Table(istride,1):Cycle_Table(istride,2),:).*config.chan_gain;
   
end %for istride

close(h);



%% save tables & stimpos
save('Table_data','Table','Cycle_Table','config');
