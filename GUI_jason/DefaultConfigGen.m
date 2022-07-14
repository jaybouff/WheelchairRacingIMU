function [config] = DefaultConfigGen()
%MainConfigGen Generate the main configuration file for the project
%   Generate Default Configuration file. Configuration file could be edit
%   manually by experimenter directly it the .mat file

%% Channel identifier (all vectors, and cell array {chan names})
config.EMG_channels = [1,2,3,4,5]; %EMG_channels:Original EMG chan number in WinVisio
config.Other_channels = [8,14,15,16]; %Other_channels:Original chan number (not EMG, not squared) in WinVisio
config.Square_channels = [10, 12]; %Square_channels:Original chan number (square waves) in WinVisio
config.chan_name = {'TA','SOL','GM','VL','RF','Knee','CONS_F',...
    'ENCO','COUPLE','Response','HS'};%chan_name:EMG goes first, then other_channels, then square channels

%% Identifier event channels with properties (all scalars)
config.ISFF_channel = 7; % ISFF_channel:Channel with FF command (e.g. CONS_F)
config.FFdetect_level = 1; % FFdetect_level:Threshold for FF detection (should be an positive scalar)

config.ISRFLX_channel = 0; % ISRFLX_channel:Channel to identify RFLX, catch, anticatch (e.g. Memory gate)
config.RFLXdetect_level = 0.4; % RFLXdetect_level:Threshold for event channel (should be a positive scalar)

%% Partition table into individual strides (all scalars or char)
config.Sync_channel = 11; % Sync_channel:Channel # used to partition data
config.trig_direction = '<'; %Trig direction: '<': descending, '>': ascending
config.trig_diff = 0; % trig_diff:set to diff order of sync chan (0 if no differentiation)
config.trig_lowpass = 0; % trig_lowpass:Set low pass filter frequency of sync chan (0 if no filter)
config.trig_Nlowpass = 0; % trig_Nlowpass:Set low pass order if to be used
config.pct_refractaire = 0.8; % pct_refractaire:Duration of refractory period (must be between 0 and 1) 

%% Preprocessing properties
config.chan_gain = [250, 250, 250, 250, 250, 90, 4, 8, 10, 1, 1]; % chan_gain:vector with chan gains

config.EMG_filter = [20 450]; % EMG_filter:[low pass Fz, High pass Fz 0
config.Other_filter = 15; %Other_filter:[Low pass Fz]
config.Order = 2; % Order:filter order (divide the wanted number by two as we use filtfilt

config.sFz = 1000; % sFz:Sampling frequency (scalar)

%% Config for Adaptation Analyses
config.useSync = 1; %useSync:1: Use sync data for analyses (e.g. middle pushoff), 0:start at first data point of each stride

%% Config for Proprio Analysis
config.AnkleName = 'ENCO'; % AnkleName: Name of Ankle signal for proprio
config.COUPLEName = 'COUPLE'; % COUPLEName: Name of COUPLE signal for proprio
config.ResponseName = 'Response'; % ResponseName: Name of Response signal for proprio
config.ForcecommandName = 'CONS_F'; % ForcecommandName: Name of Force command signal for proprio
config.ResponseTh = 1.5; % ResponseTh: Threshold for the detection of the button

end

