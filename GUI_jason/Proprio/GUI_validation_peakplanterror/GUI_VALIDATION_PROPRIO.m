function varargout = GUI_VALIDATION_PROPRIO(varargin)
% GUI_VALIDATION_PROPRIO MATLAB code for GUI_VALIDATION_PROPRIO.fig
%      GUI_VALIDATION_PROPRIO, by itself, creates a new GUI_VALIDATION_PROPRIO or raises the existing
%      singleton*.
%
%      H = GUI_VALIDATION_PROPRIO returns the handle to a new GUI_VALIDATION_PROPRIO or the handle to
%      the existing singleton*.
%
%      GUI_VALIDATION_PROPRIO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_VALIDATION_PROPRIO.M with the given input arguments.
%
%      GUI_VALIDATION_PROPRIO('Property','Value',...) creates a new GUI_VALIDATION_PROPRIO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_VALIDATION_PROPRIO_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_VALIDATION_PROPRIO_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_VALIDATION_PROPRIO

% Last Modified by GUIDE v2.5 08-Jul-2015 12:59:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GUI_VALIDATION_PROPRIO_OpeningFcn, ...
    'gui_OutputFcn',  @GUI_VALIDATION_PROPRIO_OutputFcn, ...
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



% --- Executes just before GUI_VALIDATION_PROPRIO is made visible.
function GUI_VALIDATION_PROPRIO_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_VALIDATION_PROPRIO (see VARARGIN)

% Choose default command line output for GUI_VALIDATION_PROPRIO
handles.output = hObject;
[filename,pathname]=uigetfile('*.mat','ProprioAnal')
load([pathname,filename])
handles.variable=variable;
handles.resultat=resultat;
handles.direction=menu('Which direction is the perturbation','resist dorsiflexion','assist dorsiflexion');
handles.i=0;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_VALIDATION_PROPRIO wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = GUI_VALIDATION_PROPRIO_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in NextPlotButton.
function NextPlotButton_Callback(hObject, eventdata, handles);
% hObject    handle to NextPlotButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes_deltaENCO)
cla
axes(handles.axes_CONS_F)
cla
axes(handles.axes_bouton)
cla
axes(handles.axes_deltaF)
cla
if handles.i>=size(handles.variable.deltaENCO,2)
    menu('C''est fini','OK')
else
    
    handles.i=handles.i+1;
    
    
    set(handles.stride,'string',num2str(handles.i))
    
    
    temp=isnan(handles.resultat(handles.i,1));
    if temp==1
        set(handles.notvalid,'string','NOT VALID')
        set(handles.notvalid,'backgroundcolor','r')
    else
        set(handles.notvalid,'string','VALID')
        set(handles.notvalid,'backgroundcolor','b')
    end
    
    temp=handles.resultat(handles.i,6);
    if temp==1
        set(handles.detected,'string','detected')
        set(handles.detected,'backgroundcolor','g')
    else
        set(handles.detected,'string','not detected')
        set(handles.detected,'backgroundcolor','r')
    end
    
    
    
    axes(handles.axes_deltaENCO)
    plot(handles.variable.deltaENCOcorrected(:,handles.i),'b')
    a=axis;
    hold on
    x1=handles.variable.erreurmax2timing(handles.i);
    handles.h(1)=line([x1 x1],[a(3) a(4)],'color','k');
    
    axes(handles.axes_deltaF)
    plot(handles.variable.deltaCOUPLE(:,handles.i),'b')
    a=axis;
    hold on
    x2=handles.variable.peakFtiming(handles.i);
    handles.h(2)=line([x2 x2],[a(3) a(4)],'color','g');
    
    axes(handles.axes_CONS_F)
    plot(handles.variable.CONS_F(:,handles.i),'b')
    a=axis;
    hold on
    handles.h(3)=line([x1 x1],[a(3) a(4)],'color','k');
    handles.h(4)=line([x2 x2],[a(3) a(4)],'color','g');
    
    axes(handles.axes_bouton)
    plot(handles.variable.bouton(:,handles.i),'b')
    a=axis;
    hold on
    x3=handles.variable.onsetCF(handles.i);
    handles.h(5)=line([x3 x3],[a(3) a(4)],'color','m');
    
    axes(handles.axes_CONS_F)
    a=axis;
    handles.h(6)=line([x3 x3],[a(3) a(4)],'color','m');
    
    
    axes(handles.axes_deltaF)
    a=axis;
    handles.h(7)=line([x3 x3],[a(3) a(4)],'color','m');
    uistack(handles.h(7),'bottom')
    
    axes(handles.axes_deltaENCO)
    a=axis;
    handles.h(8)=line([x3 x3],[a(3) a(4)],'color','m');
    uistack(handles.h(8),'bottom')
    
    set(handles.MaxError,'string',num2str(handles.resultat(handles.i,5)))
    set(handles.MaxError1,'string',num2str(handles.resultat(handles.i,4)))
    set(handles.ErrorTiming,'string',num2str(handles.variable.erreurmax2timing(handles.i)))
    set(handles.peakcouple,'string',num2str(handles.resultat(handles.i,3)))
    set(handles.peakcoupletiming,'string',num2str(handles.variable.peakFtiming(handles.i)))
    set(handles.peakconsf,'string',num2str(handles.resultat(handles.i,1)))
    
end


guidata(hObject, handles);



% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
resultat=handles.resultat;
variable=handles.variable;

save('ProprioAnalValidated','resultat','variable')
xlswrite('AnalProprioValidated',resultat,'A2');



% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: ,character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

switch eventdata.Key
    case 'y'
        NextPlotButton_Callback(hObject, eventdata, handles)
    case 'n'
        correction_Callback(hObject, eventdata, handles)
end


% --- Executes on button press in notvalid.
function notvalid_Callback(hObject, eventdata, handles)
% hObject    handle to notvalid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cond=get(handles.notvalid,'string');

if strcmp(cond,'VALID')==1
    set(handles.notvalid,'string','NOT VALID')
    set(handles.notvalid,'backgroundcolor','r')
    % elseif strcmp(cond,'VALID')==0
    %    set(handles.notvalid,'string','VALID')
    %     set(handles.notvalid,'backgroundcolor','g')
    handles.resultat(handles.i,:)=nan;
    
    
    set(handles.MaxError,'string','NaN')
    set(handles.ErrorTiming,'string','NaN')
    set(handles.peakcouple,'string','NaN')
    set(handles.peakcoupletiming,'string','NaN')
    set(handles.peakconsf,'string','NaN')
    
end
guidata(hObject, handles);




% --- Executes on button press in correction.
function correction_Callback(hObject, eventdata, handles)
% hObject    handle to correction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

over=0;
while not(over)
    waitforbuttonpress
    hz=gco;
    move=find(handles.h==hz);
    
    
    if not(isempty(move)) 
        
        if move==1 || move==3
            set(handles.h([1 3]),'color','r')
            [x,y]=ginput(1);
            
            if handles.direction==1;
                x1=find(handles.variable.deltaENCO(x-40:x+40,handles.i)==min(handles.variable.deltaENCO(x-40:x+40,handles.i)));
            elseif handles.direction==2
                x1=find(handles.variable.deltaENCO(x-40:x+40,handles.i)==max(handles.variable.deltaENCO(x-40:x+40,handles.i)));
            end
            x=round(x1+x-41);
            handles.variable.erreurmax2timing(handles.i)=x;
            handles.resultat(handles.i,5)=handles.variable.deltaENCOcorrected(x,handles.i);
            handles.resultat(handles.i,4)=handles.variable.deltaENCO(x,handles.i);
            set(handles.MaxError,'string',num2str(handles.resultat(handles.i,5)))
            set(handles.MaxError1,'string',num2str(handles.resultat(handles.i,4)))
            set(handles.ErrorTiming,'string',num2str(x))
            
            set(handles.h([1 3]),'xdata',[x x])
            set(handles.h([1 3]),'color','k')
            
        elseif move==2 || move==4
            set(handles.h([2 4]),'color','r')
            [x,y]=ginput(1);
            
            if handles.direction==1;
                x1=find(handles.variable.deltaCOUPLE(x-40:x+40,handles.i)==min(handles.variable.deltaCOUPLE(x-40:x+40,handles.i)));
            elseif handles.direction==2
                x1=find(handles.variable.deltaCOUPLE(x-40:x+40,handles.i)==max(handles.variable.deltaCOUPLE(x-40:x+40,handles.i)));
            end
            x=round(x1+x-41);
            handles.variable.peakFtiming(handles.i)=x;
            handles.resultat(handles.i,3)=handles.variable.deltaCOUPLE(x,handles.i);
            set(handles.peakcouple,'string',num2str(handles.resultat(handles.i,3)))
            set(handles.peakcoupletiming,'string',num2str(x))
            
            set(handles.h([2 4]),'xdata',[x x])
            set(handles.h([2 4]),'color','g')
            
        end
        
        
        
        
        
    else
        over=1;
    end
end
guidata(hObject, handles);


% --- Executes on button press in detected.
function detected_Callback(hObject, eventdata, handles)
% hObject    handle to detected (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cond=get(handles.detected,'string');

if strcmp(cond,'detected')==1
    set(handles.detected,'string','not detected')
    set(handles.detected,'backgroundcolor','r')
    handles.resultat(handles.i,6)=0;
elseif strcmp(cond,'not detected')==1
    set(handles.detected,'string','detected')
    set(handles.detected,'backgroundcolor','g')
    handles.resultat(handles.i,6)=1;
end
guidata(hObject, handles);
