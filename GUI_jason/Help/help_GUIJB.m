%% GUI_analysis_JB help file
% GUI_analysis_JB has been developed by Jason Bouffard with the
% collaboration of Laurent Bouyer, Martin Noel (LOKOMAT) and Benoit Pairot 
% de Fonteney %between 2010 and 2018 to analyse data from the robotic ankle 
% foot orthosis (Noel et al. 2008, IEEE Trans Neural Syst Rehabil Eng)
% 
% Here is a brief list of publications using the current or previous versions of
% GUI_analysis_JB, or embedded functions
% Noel et al. 2008, IEEE Trans Neural Syst Rehabil Eng
% Noel et al. 2009, J Neuroeng Rehabil
% Blanchette et al. 2011, Gait Posture
% Bouffard et al. 2014, J Neuroscience
% Fournier-Belley et al. 2016, Gait Posture
% Bouffard et al. 2016, Neural Plasticity
% Bouffard et al. 2016, J Neurophysiol
% 
%% Getting started
% You can get the up-to-date version of the toolbox by downloading the
% latest release or cloning the master branch on 
%https://github.com/jabou356/rAFO_adaptation

% To launch the program, just run the GUI_analysis_JB.m file. All necessary
% paths will be added to your Matlab Search paths.
% You will then be asked to open your project's parent folder. The program
% will load the config.mat(see Annexe 1 for the content of config file) file or create and save a default one if it
% doesn't exist. If you want to modify the config.mat file, just do it
% manually. The program bring you back to the project's parent folder and
% save some files in it, so organize your data structure to navigate easily
% between subfolders during data analysis.

%% Step by step guide
%% Transfer your .raw file from WinVision into a .mat
% File->Convert *.raw vers *.mat

% You will have to select the *.raw file you want to
% convert, then save it as a *.mat file. Repeat for each file. 
%
%The .mat file contain a !!data(1:number of channels,1:number of samples)!!
%matrix, filename, sampling frequency, nb_channels, nb_samples)

%% Combine all .mat files for one subject into a single one
% Data Processing -> Combine Files from WinVisio
%
% This function will process data (apply filters and gains) and combine
% multiple files. The function will first ask you to go into your subject
% directory (i.e. the one with your .mat files). If you have a subject 
% specific config.mat file in your subject directory, it will be loaded. If
% no such file exist, it will use the generic config.mat file loaded from
% the project parent directory.
% subject

%% Annexe 1: Config file
%Channel identifier (all vectors, and cell array {chan names})
% config.EMG_channels = [1,2,3,4,5]; %EMG_channels:Original EMG chan number in WinVisio
% config.Other_channels = [8,14,15,16]; %Other_channels:Original chan number (not EMG, not squared) in WinVisio
% config.Square_channels = [10, 12]; %Square_channels:Original chan number (square waves) in WinVisio
% config.chan_name = {'TA','SOL','GM','VL','RF','Knee','CONS_F',...
%     'ENCO','COUPLE','Response','HS'};%chan_name:EMG goes first, then other_channels, then square channels
% 
% %% Identifier event channels with properties (all scalars)
% config.ISFF_channel = 7; % ISFF_channel:Channel with FF command (e.g. CONS_F)
% config.FFdetect_level = 0.6; % FFdetect_level:Threshold for FF detection (should be an positive scalar)
% 
% config.ISRFLX_channel = 0; % ISRFLX_channel:Channel to identify RFLX, catch, anticatch (e.g. Memory gate)
% config.RFLXdetect_level = 0.4; % RFLXdetect_level:Threshold for event channel (should be a positive scalar)
% 
% %% Partition table into individual strides (all scalars or char)
% config.Sync_channel = 11; % Sync_channel:Channel # used to partition data
% config.trig_direction = '<'; %Trig direction: '<': descending, '>': ascending
% config.trig_diff = 0; % trig_diff:set to diff order of sync chan (0 if no differentiation)
% config.trig_lowpass = 0; % trig_lowpass:Set low pass filter frequency of sync chan (0 if no filter)
% config.trig_Nlowpass = 0; % trig_Nlowpass:Set low pass order if to be used
% config.pct_refractaire = 0.8; % pct_refractaire:Duration of refractory period (must be between 0 and 1) 
% 
% %% Preprocessing properties
% config.chan_gain = [250, 250, 250, 250, 250, 90, 4, 8, 10, 1, 1]; % chan_gain:vector with chan gains
% 
% config.EMG_filter = [20 450]; % EMG_filter:[low pass Fz, High pass Fz 0
% config.Other_filter = 15; %Other_filter:[Low pass Fz]
% config.Order = 2; % Order:filter order (divide the wanted number by two as we use filtfilt
% 
% config.sFz = 1000; % sFz:Sampling frequency (scalar)
% 
% %% Config for Adaptation Analyses
% config.useSync = 1; %useSync:1: Use sync data for analyses (e.g. middle pushoff), 0:start at first data point of each stride
% 
% %% Config for Proprio Analysis
% config.AnkleName = 'ENCO'; % AnkleName: Name of Ankle signal for proprio
% config.COUPLEName = 'COUPLE'; % COUPLEName: Name of COUPLE signal for proprio
% config.ResponseName = 'Response'; % ResponseName: Name of Response signal for proprio
% config.ForcecommandName = 'CONS_F'; % ForcecommandName: Name of Force command signal for proprio
% config.ResponseTh = 1.5; % ResponseTh: Threshold for the detection of the button