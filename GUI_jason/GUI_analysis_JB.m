function varargout = GUI_analysis_JB(varargin)
% GUI_ANALYSIS_JB MATLAB code for GUI_analysis_JB.fig
%      GUI_ANALYSIS_JB, by itself, creates a new GUI_ANALYSIS_JB or raises the existing
%      singleton*.
%
%      H = GUI_ANALYSIS_JB returns the handle to a new GUI_ANALYSIS_JB or the handle to
%      the existing singleton*.
%
%      GUI_ANALYSIS_JB('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_ANALYSIS_JB.M with the given input arguments.
%
%      GUI_ANALYSIS_JB('Property','Value',...) creates a new GUI_ANALYSIS_JB or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_analysis_JB_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_analysis_JB_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_analysis_JB

% Last Modified by GUIDE v2.5 15-Jun-2018 16:36:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_analysis_JB_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_analysis_JB_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GUI_analysis_JB is made visible.
function GUI_analysis_JB_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_analysis_JB (see VARARGIN)

% Choose default command line output for GUI_analysis_JB
handles.output = hObject;

% Find the rootpath of the GUI_analysis_JB codes and add all relevant
% subpaths
tooldir = which('GUI_analysis_JB.m');
handles.tooldir = tooldir(1:end-17);

subfolders = {'FctMatlab','Organisation_groupe','Proprio','ResultGenerator'...
    ,'Traitement_donnees_Individuelles', 'Help'};
addpath(handles.tooldir);
for ipath = 1:length(subfolders)
    addpath([handles.tooldir, subfolders{ipath}]);
end

%% my global variables
handles.MainDir = uigetdir([],'Go get the parent folder for your project');
cd(handles.MainDir)
% Load or generate default config file
if exist([handles.MainDir, '/config.mat'],'file')
    load([handles.MainDir, '/config.mat'])
    handles.config = config;
    disp('Config file loaded')
else
config = DefaultConfigGen;
handles.config = config;
save([handles.MainDir, '/config.mat'],'config');
disp('Config file created')
end
    
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_analysis_JB wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_analysis_JB_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%% MY FUNCTIONS START HERE

%% Single subject data preprocessing / processing
% --------------------------------------------------------------------
function convert_raw_to_mat_Callback(hObject, eventdata, handles)
% hObject    handle to convert_raw_to_mat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% This function import WinVisio .raw files into .mat format
Read_WinVisio_LB
disp('file *.mat saved')

% --------------------------------------------------------------------
function Combine_WinVisio_data_Callback(hObject, eventdata, handles)
% hObject    handle to Combine_WinVisio_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% This function combine multiple .mat files and process data (filters,
% gain, etc.)
%% Load calibration
%[fn,pn]=uigetfile('*.mat','select the calibration file');
%config=load([pn,fn],'-mat');

% cd the subject directory
cd(uigetdir([],'Go to your subject directory'))

if exist('config.mat','file')
    %If there is a subject specific config file, load it
    load('config.mat');
    disp('Subject specific config')
else
    
    %If there is no subject specific config file, load the generic one
    config = handles.config;
    disp('Generic config')
end

combine_data_WinVisio(config)
disp('combined file saved')

% --------------------------------------------------------------------
function Cut_Table_Lokomath_Callback(hObject, eventdata, handles)
% hObject    handle to Cut_Table_Lokomath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%This function cut processed data into individual strides
%% load config file
% cd the subject directory
cd(uigetdir([],'Go to your subject directory'))

if exist('config.mat','file')
    %If there is a subject specific config file, load it
    load('config.mat');
    disp('Subject specific config')
else
    
    %If there is no subject specific config file, load the generic one
    config = handles.config;
    disp('Generic config')
end
%[filename,pathfile]=uigetfile('*.*','Choisir fichier de calibration');
%config = load([pathfile,filename],'-mat');

%% Load combined data file in the current folder
load('combined_data');

%% Cut and save tables
cutTable_Lokomath(config, fdata, trialID);
disp('Table_data saved')

% --------------------------------------------------------------------
function Remove_bad_superpose_Callback(hObject, eventdata, handles)
% hObject    handle to Remove_bad_superpose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% This function open a GUI to clean individual data files
data = load('Table_data.mat');

Signal = input('Which signals would you like to show for validation?{''FrameAccelX'',''ndHandAccelNorm'',''dHandAccelNorm''}');

for itrial = 1: max(data.Cycle_Table(:,4))
Essai = find( data.Cycle_Table(:,4) == itrial);

bad_cycles = removebad_Superpose1 (data, Signal, Essai, 'subject','flagDuree');
data.Cycle_Table(bad_cycles,3)=0;
data.Cycle_Table(Essai(~ismember(Essai, bad_cycles)),3) = 1;
end

clearvars -except data
v2struct(data)
clear data
save('Table_data.mat')

disp('Table_data saved')

%% Group data organization
% --------------------------------------------------------------------
function Combine_Group_Data_Callback(hObject, eventdata, handles)
% hObject    handle to Combine_Group_Data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% This function combine multiple subjects data into a single structure/cell
% array
cd(handles.MainDir)

GroupTablesGeneratorJB
disp('GroupData saved')

% --------------------------------------------------------------------
function Idendification_Cycles_Callback(hObject, eventdata, handles)
% hObject    handle to Idendification_Cycles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% This function identify critical cycles as last baseline, FF or POST
% strides, presences of RFLX, and timing of FF within each stride

[fn,pn]=uigetfile('*.mat','Choisi ton fichier de données GroupData');
load([pn,fn],'-mat');
cd(pn)

if isfield(GroupData,'CONS_F')
[CTRLlast, FFlast, fin, RFLX, stimtiming]=cyclesIdentifiant(GroupData.Cycle_Table,GroupData.CONS_F);
else
[CTRLlast, FFlast, fin, RFLX, stimtiming]=cyclesIdentifiant(GroupData.Cycle_Table);
end


save('CyclesCritiques','CTRLlast','FFlast','fin','RFLX','stimtiming'); 
disp('CyclesCritiques saved')

% --------------------------------------------------------------------
function Synchro_Pushoff_Callback(hObject, eventdata, handles)
% hObject    handle to Synchro_Pushoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% This function is used to synchronize data on the middle of the PushOff
% based on kinematic data %%% COULD IT BE GENERALIZED TO OTHER
% SIGNALS/EVENTS?

[fn,pn]=uigetfile('*.mat','Choisi ton fichier de données');
load([pn,fn],'-mat');
cd(pn)

prompt='Which subjects do you want to analysis? Write subjects numbers between [], if all subjects write nothing: ';
subjects = input(prompt)

if isempty(subjects); subjects = 1:length(GroupData.Cycle_Table); end

[SyncTiming, SyncThreshold, stimtimingSync] = SyncPushoff(GroupData.Cycle_Table,GroupData.ENCO,subjects);
save('SyncData','SyncTiming','SyncThreshold', 'stimtimingSync'); 
disp('SyncData saved')

%% Results generators
% --------------------------------------------------------------------
function KinematicAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to KinematicAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% This function generates Kinematic outcome measures for FF adaptation

% Load GroupData
[fn,pn]=uigetfile('*.mat','Choose your GroupData.mat data file');
load([pn,fn],'-mat');
cd(pn)

% Load SyncData
if handles.config.useSync
    SyncData = load([pn,'SyncData.mat']);
else
    %If you don't want to use SyncData, use the beginning of each stride
    for isubject = 1:length(GroupData.Cycle_Table)
       SyncData.SyncTiming{isubject}(1:size(GroupData.Cycle_Table{isubject},2))=1;
       SyncData.stimtimingSync{isubject}=cellfun(@(x)(find(x == min(x))),GroupData.CONS_F{isubject});
    end
end

load([pn,'CyclesCritiques.mat']);
criticalCycles = [zeros(1,length(CTRLlast));CTRLlast; FFlast; fin];

conditions = {'Baseline2', 'CHAMP', 'POST'};

prompt='Which subjects do you want to analysis? Write subjects numbers between [], if all subjects write nothing: ';
subjects = input(prompt)

if isempty(subjects)
    subjects = 1 : length(GroupData.Cycle_Table);
end

AnalENCO = ENCOvariablesgeneratortimenorm(GroupData.Cycle_Table,GroupData.ENCO, conditions, criticalCycles, SyncData, subjects);

[filename, pathname]=uiputfile('*.mat','Placez le fichier AnalENCO');
save(filename,'AnalENCO'); 

disp('AnalENCO saved')


% --------------------------------------------------------------------
function TAAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to TAAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%This function generates TA outcome measures for FF adaptation

[fn,pn]=uigetfile('*.mat','Choose your GroupData.mat data file');
load([pn,fn],'-mat');
cd(pn)

side=menu('Do you want to Analyse right or left TA?','Right (RTA)','Left (LTA)','Just TA (TA)');
if side==1
    data=Filter_RBI(GroupData.RTA,9,3,1);
    
elseif side==2
    
    data=Filter_RBI(GroupData.LTA,9,3,1);
    
elseif side==3
    
    data=Filter_RBI(GroupData.TA,9,3,1);
    
end

useold=menu('Do you already have AnalTA file?','Yes','No');

if useold==1
    load([pn, 'AnalRBITA.mat']);
else
    AnalTA=[];
end

if handles.config.useSync
    SyncData = load([pn,'SyncData.mat']);
else 
    %If you don't want to use SyncData, use the beginning of each stride
    for isubject = 1:length(GroupData.Cycle_Table)
       SyncData.SyncTiming{isubject}(1:size(GroupData.Cycle_Table{isubject},2))=1;
       SyncData.stimtimingSync{isubject}=cellfun(@(x)(find(x == min(x))),GroupData.CONS_F{isubject});
    end
end

load([pn,'CyclesCritiques.mat']);
criticalCycles = [zeros(1,length(CTRLlast));CTRLlast; FFlast; fin];

conditions = {'Baseline2', 'CHAMP', 'POST'};

prompt='Which subjects do you want to analysis? Write subjects numbers between [], if all subjects write nothing: ';
subjects = input(prompt)

if isempty(subjects)
    subjects = 1 : length(GroupData.Cycle_Table);
end


[AnalTA]=RBITAvariablesgeneratorTimenorm(GroupData.Cycle_Table,data,conditions,criticalCycles,AnalTA,SyncData, subjects);

save([pn, 'AnalRBITA.mat'], 'AnalTA'); 

disp('AnalRBITA saved')

TAratiovariable = EMGratioCode(GroupData,AnalTA, criticalCycles, SyncData, pn);

save([pn, 'TAratio.mat'], 'TAratiovariable'); 

disp('TAratio saved')

% --------------------------------------------------------------------
function GENERICAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to GENERICAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% This function generates GENERIC SIGNAL outcome measures for FF adaptation

% Load GroupData
[fn,pn]=uigetfile('*.mat','Choose your GroupData.mat data file');
load([pn,fn],'-mat');
cd(pn)

% Load SyncData

if handles.config.useSync
    SyncData = load([pn,'SyncData.mat']);
else % not tested
    %If you don't want to use SyncData, use the beginning of each stride
    for isubject = 1:length(GroupData.Cycle_Table)
       SyncData.SyncTiming{isubject}(1:size(GroupData.Cycle_Table{isubject},2))=1;
       SyncData.stimtimingSync{isubject}=cellfun(@(x)(find(x == min(x))),GroupData.CONS_F{isubject});
    end
end

% load Cycles critiques (onset and end of each condition)
load([pn,'CyclesCritiques.mat']);
criticalCycles = [zeros(1,length(CTRLlast));CTRLlast; FFlast; fin];

conditions = {'Baseline2', 'CHAMP', 'POST'};

prompt='Which subjects do you want to analysis? Write subjects numbers between [], if all subjects write nothing: ';
subjects = input(prompt)

if isempty(subjects)
    subjects = 1 : length(GroupData.Cycle_Table);
end

Signal = input ('Identify the Signal you want to analyse');

GenericAnal=GenericAnalysis(GroupData.Cycle_Table, GroupData.(Signal), conditions, criticalCycles, SyncData, Signal,subjects);

[filename, pathname]=uiputfile('*.mat','Placez le fichier GenericAnal');
save(filename,'GenericAnal');


% --------------------------------------------------------------------
function GENERICAnalysisEMG_Callback(hObject, eventdata, handles)
% hObject    handle to GENERICAnalysisEMG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%This function generates GENERIC EMG outcome measures for FF adaptation

[fn,pn]=uigetfile('*.mat','Choose your GroupData.mat data file');
load([pn,fn],'-mat');
cd(pn)

%Defin the signal you want to analyse
Signal = input ('Identify the Signal you want to analyse');

data=Filter_RBI(GroupData.(Signal),9,3,1);
 
if handles.config.useSync
    SyncData = load([pn,'SyncData.mat']);
else 
    %If you don't want to use SyncData, use the beginning of each stride
    for isubject = 1:length(GroupData.Cycle_Table)
       SyncData.SyncTiming{isubject}(1:size(GroupData.Cycle_Table{isubject},2))=1;
       SyncData.stimtimingSync{isubject}=cellfun(@(x)(find(x == min(x))),GroupData.CONS_F{isubject});
    end
end

load([pn,'CyclesCritiques.mat']);
criticalCycles = [zeros(1,length(CTRLlast));CTRLlast; FFlast; fin];

conditions = {'Baseline2', 'CHAMP', 'POST'};

prompt='Which subjects do you want to analysis? Write subjects numbers between [], if all subjects write nothing: ';
subjects = input(prompt)

if isempty(subjects)
    subjects = 1 : length(GroupData.Cycle_Table);
end

GenericAnalEMG=GenericAnalysis(GroupData.Cycle_Table, data, conditions, criticalCycles, SyncData, Signal, subjects);

[filename, pathname]=uiputfile('*.mat','Placez le fichier GenericAnal');
save(filename,'GenericAnalEMG');

disp('GenericEMG saved')

% --------------------------------------------------------------------
function GroupData_TimeNorm_Callback(hObject, eventdata, handles)
% hObject    handle to GroupData_TimeNorm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% This function generate Time normalized vectors for each stride of each
% participant

[fn,pn]=uigetfile('*.mat','Choose your GroupData.mat data file');
load([pn,fn],'-mat');
cd(pn)

GroupData=TimeNormGroup(GroupData);

save([pn,fn],'GroupData');


%% Proprioception analyses
% --------------------------------------------------------------------
function AnalProprio_Callback(hObject, eventdata, handles)
% hObject    handle to AnalProprio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cd(uigetdir([],'Go to your subject directory'))

load('Table_data.mat')

AnalProprio = ProprioAnalysis(Table, Cycle_Table, config);
save('AnalProprio.mat','AnalProprio');

% --------------------------------------------------------------------
function ValidationProprio_Callback(hObject, eventdata, handles)
% hObject    handle to ValidationProprio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cd(uigetdir([],'Go to your subject directory'))

GUI_VALIDATION_PROPRIO

% --------------------------------------------------------------------
function ProprioOutcome_Callback(hObject, eventdata, handles)
% hObject    handle to ProprioOutcome (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cd(uigetdir([],'Go to your subject directory'))

load('AnalProprio.mat'); 
 
% Compute Outcomes for ENCO signal 
%% Compute Outcomes for COUPLE signal 
[sortedCOUPLE,I] = sort(AnalProprio.peakDeltaCOUPLEcorr.STIM); 
Response = AnalProprio.Response.STIM(I); 
 

for itrial = 1 :length(sortedCOUPLE)-2 
    movingsortedCOUPLE (itrial) = mean(abs(sortedCOUPLE(itrial:itrial+2)));     
    movingResponse (itrial) = round(mean(Response(itrial:itrial+2)));  
end 

% Zone incertitude COUPLE 
AnalProprio.ZI.COUPLE = movingsortedCOUPLE(find(movingResponse==0,1,'first')) - movingsortedCOUPLE(find(movingResponse==1,1,'last')); 

data = [movingsortedCOUPLE(~isnan(movingsortedCOUPLE)) ; movingResponse(~isnan(movingsortedCOUPLE))]'; 
[AnalProprio.Threshold.COUPLE] = createFit(data,'COUPLE'); 
 
save('AnalProprio.mat','AnalProprio');

%% Compute Outcomes for ENCO signal 
[sortedENCO,I] = sort(AnalProprio.peakDeltaENCOcorr.STIM); 
Response = AnalProprio.Response.STIM(I); 
 
 
for itrial = 1 :length(sortedENCO)-2 
    movingsortedENCO (itrial) = mean(abs(sortedENCO(itrial:itrial+2)));     
    movingResponse (itrial) = round(mean(Response(itrial:itrial+2)));  
end 

 
% Zone incertitude ENCO 
AnalProprio.ZI.ENCO = movingsortedENCO(find(movingResponse==0,1,'first')) - movingsortedENCO(find(movingResponse==1,1,'last')); 

data = [movingsortedENCO(~isnan(movingsortedENCO)) ; movingResponse(~isnan(movingsortedENCO))]'; 
[AnalProprio.Threshold.ENCO] = createFit(data,'ENCO'); 
 
 
save('AnalProprio.mat','AnalProprio');
 
% --------------------------------------------------------------------
function Help_Callback(hObject, eventdata, handles)
% hObject    handle to Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

open([handles.tooldir, 'Help\helpGUIJB.pdf']);
