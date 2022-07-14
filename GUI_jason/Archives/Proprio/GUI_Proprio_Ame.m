function varargout = GUI_Proprio_Ame(varargin)
% GUI_PROPRIO_AME MATLAB code for GUI_Proprio_Ame.fig
%      GUI_PROPRIO_AME, by itself, creates a new GUI_PROPRIO_AME or raises the existing
%      singleton*.
%
%      H = GUI_PROPRIO_AME returns the handle to a new GUI_PROPRIO_AME or the handle to
%      the existing singleton*.
%
%      GUI_PROPRIO_AME('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_PROPRIO_AME.M with the given input arguments.
%
%      GUI_PROPRIO_AME('Property','Value',...) creates a new GUI_PROPRIO_AME or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_Proprio_Ame_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_Proprio_Ame_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_Proprio_Ame

% Last Modified by GUIDE v2.5 08-Jul-2015 14:17:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_Proprio_Ame_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_Proprio_Ame_OutputFcn, ...
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


% --- Executes just before GUI_Proprio_Ame is made visible.
function GUI_Proprio_Ame_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_Proprio_Ame (see VARARGIN)

% Choose default command line output for GUI_Proprio_Ame
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_Proprio_Ame wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_Proprio_Ame_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function ConvertFile_Callback(hObject, eventdata, handles)
% hObject    handle to ConvertFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Read_WinVisio_LB_2017
disp('file *.mat saved')


% --------------------------------------------------------------------
function CutTable_Callback(hObject, eventdata, handles)
% hObject    handle to CutTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cutTable_LokomathProprio
disp('Table_data saved')


% --------------------------------------------------------------------
function ValidatecCycles_Callback(hObject, eventdata, handles)
% hObject    handle to ValidatecCycles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

removebad_Proprio
disp('Table_data saved')


% --------------------------------------------------------------------
function GenerateAnalyses_Callback(hObject, eventdata, handles)
% hObject    handle to GenerateAnalyses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[variable,resultat]=analyse_proprio_Bouton_JB_LB_JBjuly8_2017;
save('ProprioAnal','resultat','variable');
disp('excel file created')


% --------------------------------------------------------------------
function Validate_Analyses_Callback(hObject, eventdata, handles)
% hObject    handle to Validate_Analyses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

GUI_VALIDATION_PROPRIO

% --------------------------------------------------------------------
function Combine_WinVisio_data_Callback(hObject, eventdata, handles)
% hObject    handle to Combine_WinVisio_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

combine_data_WinVisio
disp('combined file saved')
