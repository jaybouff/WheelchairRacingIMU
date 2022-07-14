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

   
    identifiant_init = [1/5;find(islocalmin(signal, 1,'MinSeparation', config.min_duration*config.sFz/5,'MinProminence',config.min_peakprominence,'FlatSelection', 'first'))];

   
    
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
