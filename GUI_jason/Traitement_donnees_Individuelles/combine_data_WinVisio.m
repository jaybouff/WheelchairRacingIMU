function combine_data_WinVisio(config)
%COMBINE_DATA_WINVISIO This function is used to combine multiple data files
%extracted from Winvisio using Read_Winvisio_LB. Moreover, data are
%filtered based on config files 
%   INPUT: Config file generated with XXX FUNCTION. Data files are selected
%   in the function
%   OUTPUT: None. Combined raw and filtered data are saved in
%   combined_data.mat in the current directory.
%   
%   Initially developed by Martin Noel and Laurent Bouyer. Modified by
%   Jason Bouffard

    
    % Get the data file
    [mypath]=uigetdir('','select your data folder');
    cd(mypath);
    load('Table.mat','-mat');
    load('config.mat','-mat')
    
    
    
    %% Keep only selected channels, put EMG first
    for ichannel = 1:length(config.IMU_channels)
        rawdata(ichannel,:)=reshape(eval(config.IMU_channels{ichannel}),[],1);
    end
    rawdata=rawdata';
  
    
    % Filter data
    Fc=config.Other_filter;
    order=config.Order;
    [b,a] = butter(order,Fc/config.sFz*2);
    fdata = filtfilt(b,a,rawdata);
    
    
    for ichannorm=1:size(config.normChannel,1)
        fdata(:,size(fdata,2)+1)=sqrt(fdata(:,config.normChannel(ichannorm,1)).^2+fdata(:,config.normChannel(ichannorm,2)).^2+fdata(:,config.normChannel(ichannorm,3)).^2);
    end
    
        [trialduration,trialn]=size(eval(config.IMU_channels{1}));
        
        for itrial = 1:trialn
            trialID(1+trialduration*(itrial-1):trialduration*(itrial))=itrial;
        end
  
%% Save concatenated filtered and raw data       
    save('combined_data','rawdata','fdata','trialID');

end
    


