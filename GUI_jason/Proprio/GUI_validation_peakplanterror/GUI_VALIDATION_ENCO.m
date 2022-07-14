function varargout = GUI_VALIDATION_ENCO(varargin)
% GUI_VALIDATION_ENCO MATLAB code for GUI_VALIDATION_ENCO.fig
%      GUI_VALIDATION_ENCO, by itself, creates a new GUI_VALIDATION_ENCO or raises the existing
%      singleton*.
%
%      H = GUI_VALIDATION_ENCO returns the handle to a new GUI_VALIDATION_ENCO or the handle to
%      the existing singleton*.
%
%      GUI_VALIDATION_ENCO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_VALIDATION_ENCO.M with the given input arguments.
%
%      GUI_VALIDATION_ENCO('Property','Value',...) creates a new GUI_VALIDATION_ENCO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_VALIDATION_ENCO_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_VALIDATION_ENCO_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_VALIDATION_ENCO

% Last Modified by GUIDE v2.5 19-Apr-2015 08:32:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GUI_VALIDATION_ENCO_OpeningFcn, ...
    'gui_OutputFcn',  @GUI_VALIDATION_ENCO_OutputFcn, ...
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


% --- Executes just before GUI_VALIDATION_ENCO is made visible.
function GUI_VALIDATION_ENCO_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_VALIDATION_ENCO (see VARARGIN)

% Choose default command line output for GUI_VALIDATION_ENCO
handles.output = hObject;
subject=input('which subject do you want to validate?');
[filename,pathname]=uigetfile('*.mat','Sélectionnez votre fichier AnalENCO')
load([pathname,filename])


handles.deltaENCO=deltaENCO.CHAMP(:,:,subject);
[filename,pathname]=uigetfile('*.mat','Sélectionnez votre fichier AnalCONS_F')
load([pathname,filename])
handles.CONS_F=CONS_F.CHAMP(:,:,subject);
handles.MaxPlantError=MaxPlantError.CHAMP(:,subject)
handles.timing=MaxPlantErrortiming.CHAMP(:,subject)
handles.i=-9;
handles.subject=subject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_VALIDATION_ENCO wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_VALIDATION_ENCO_OutputFcn(hObject, eventdata, handles)
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
handles.i=handles.i+10;

for i=1:10
    s=['set(handles.stride',num2str(i),',''string'',',num2str(handles.i+i-1),')'];eval(s)
    s=['set(handles.MaxError',num2str(i),',''string'',',num2str(handles.MaxPlantError(handles.i+i-1)),')'];eval(s)
    s=['set(handles.ErrorTiming',num2str(i),',''string'',',num2str(handles.timing(handles.i+i-1)),')'];eval(s)
    
    temp=isnan(handles.MaxPlantError(handles.i+i-1));
    if temp==1
        s=['set(handles.notvalid',num2str(i),',''string'',''NOT VALID'')'];eval(s)
        s=['set(handles.notvalid',num2str(i),',''backgroundcolor'',''r'')'];eval(s)
    else
        s=['set(handles.notvalid',num2str(i),',''string'',''VALID'')'];eval(s)
        s=['set(handles.notvalid',num2str(i),',''backgroundcolor'',''g'')'];eval(s)
    end
end

temp=get(handles.axes_CONS_F,'position');
width=temp(3);

k=0
j=1;
for i=handles.i:handles.i+9
    
    axes(handles.axes_deltaENCO)
    plot(k+1:k+1000,handles.deltaENCO(:,i),'b')
    a=axis;
    hold on
    x=(handles.timing(i)+k);
    h(1,j)=line([x x],[a(3) a(4)],'color','k');
    
    
    axes(handles.axes_CONS_F)
    plot(k+1:k+1000,handles.CONS_F(:,i),'b')
    a=axis;
    hold on
    h(2,j)=line([x x],[a(3) a(4)],'color','k');
    
    k=k+1000;
    j=j+1;
    
end
axes(handles.axes_deltaENCO)
title(num2str(handles.i))

over=0;
while not(over)
    waitforbuttonpress
    hz=gco;
    [channel,move]=find(h==hz);
    
    
    if not(isempty(move))
        set(h(:,move),'color','r')
        
        [x,y]=ginput(1);
        
        
        
        
        if x<=1000
            j=handles.i;
            x1=find(handles.deltaENCO(x-40:x+40,j)==min(handles.deltaENCO(x-40:x+40,j)));
            x=round(x1+x-41);
            x1=x;
            handles.timing(j)=x1;
            handles.MaxPlantError(j)=handles.deltaENCO(x1,j);
            s=['set(handles.MaxError',num2str(1),',''string'',',num2str(handles.MaxPlantError(j)),')'];eval(s)
            s=['set(handles.ErrorTiming',num2str(1),',''string'',',num2str(handles.timing(j)),')'];eval(s)
            
        elseif x>1000 && x<=2000
            j=handles.i+1;
            x1=x-1000;
            temp=find(handles.deltaENCO(x1-40:x1+40,j)==min(handles.deltaENCO(x1-40:x1+40,j)));
            x1=round(temp+x1-41);
            x=x1+1000
            handles.timing(j)=x1;
            handles.MaxPlantError(j)=handles.deltaENCO(x1,j);
            s=['set(handles.MaxError',num2str(2),',''string'',',num2str(handles.MaxPlantError(j)),')'];eval(s)
            s=['set(handles.ErrorTiming',num2str(2),',''string'',',num2str(handles.timing(j)),')'];eval(s)
            
        elseif x>2000 && x<=3000
            j=handles.i+2;
            x1=x-2000;
            temp=find(handles.deltaENCO(x1-40:x1+40,j)==min(handles.deltaENCO(x1-40:x1+40,j)));
            x1=round(temp+x1-41);
            x=x1+2000
            handles.timing(j)=x1;
            handles.MaxPlantError(j)=handles.deltaENCO(x1,j);
            s=['set(handles.MaxError',num2str(3),',''string'',',num2str(handles.MaxPlantError(j)),')'];eval(s)
            s=['set(handles.ErrorTiming',num2str(3),',''string'',',num2str(handles.timing(j)),')'];eval(s)
            
        elseif x>3000 && x<=4000
            j=handles.i+3;
            x1=x-3000;
            temp=find(handles.deltaENCO(x1-40:x1+40,j)==min(handles.deltaENCO(x1-40:x1+40,j)));
            x1=round(temp+x1-41);
            x=x1+3000
            handles.timing(j)=x1;
            handles.MaxPlantError(j)=handles.deltaENCO(x1,j);
            s=['set(handles.MaxError',num2str(4),',''string'',',num2str(handles.MaxPlantError(j)),')'];eval(s)
            s=['set(handles.ErrorTiming',num2str(4),',''string'',',num2str(handles.timing(j)),')'];eval(s)
            
        elseif x>4000 && x<=5000
            j=handles.i+4;
            x1=x-4000;
            temp=find(handles.deltaENCO(x1-40:x1+40,j)==min(handles.deltaENCO(x1-40:x1+40,j)));
            x1=round(temp+x1-41);
            x=x1+4000
            handles.timing(j)=x1;
            handles.MaxPlantError(j)=handles.deltaENCO(x1,j);
            s=['set(handles.MaxError',num2str(5),',''string'',',num2str(handles.MaxPlantError(j)),')'];eval(s)
            s=['set(handles.ErrorTiming',num2str(5),',''string'',',num2str(handles.timing(j)),')'];eval(s)
            
        elseif x>5000 && x<=6000
            j=handles.i+5;
            x1=x-5000;
            temp=find(handles.deltaENCO(x1-40:x1+40,j)==min(handles.deltaENCO(x1-40:x1+40,j)));
            x1=round(temp+x1-41);
            x=x1+5000
            handles.timing(j)=x1;
            handles.MaxPlantError(j)=handles.deltaENCO(x1,j);
            s=['set(handles.MaxError',num2str(6),',''string'',',num2str(handles.MaxPlantError(j)),')'];eval(s)
            s=['set(handles.ErrorTiming',num2str(6),',''string'',',num2str(handles.timing(j)),')'];eval(s)
            
        elseif x>6000 && x<=7000
            j=handles.i+6;
            x1=x-6000;
            temp=find(handles.deltaENCO(x1-40:x1+40,j)==min(handles.deltaENCO(x1-40:x1+40,j)));
            x1=round(temp+x1-41);
            x=x1+6000
            handles.timing(j)=x1;
            handles.MaxPlantError(j)=handles.deltaENCO(x1,j);
            s=['set(handles.MaxError',num2str(7),',''string'',',num2str(handles.MaxPlantError(j)),')'];eval(s)
            s=['set(handles.ErrorTiming',num2str(7),',''string'',',num2str(handles.timing(j)),')'];eval(s)
            
        elseif x>7000 && x<=8000
            j=handles.i+7;
            x1=x-7000;
            temp=find(handles.deltaENCO(x1-40:x1+40,j)==min(handles.deltaENCO(x1-40:x1+40,j)));
            x1=round(temp+x1-41);
            x=x1+7000
            handles.timing(j)=x1;
            handles.MaxPlantError(j)=handles.deltaENCO(x1,j);
            s=['set(handles.MaxError',num2str(8),',''string'',',num2str(handles.MaxPlantError(j)),')'];eval(s)
            s=['set(handles.ErrorTiming',num2str(8),',''string'',',num2str(handles.timing(j)),')'];eval(s)
            
        elseif x>8000 && x<=9000
            j=handles.i+8;
            x1=x-8000;
            temp=find(handles.deltaENCO(x1-40:x1+40,j)==min(handles.deltaENCO(x1-40:x1+40,j)));
            x1=round(temp+x1-41);
            x=x1+8000
            handles.timing(j)=x1;
            handles.MaxPlantError(j)=handles.deltaENCO(x1,j);
            s=['set(handles.MaxError',num2str(9),',''string'',',num2str(handles.MaxPlantError(j)),')'];eval(s)
            s=['set(handles.ErrorTiming',num2str(9),',''string'',',num2str(handles.timing(j)),')'];eval(s)
            
        elseif x>9000 && x<=10000
            j=handles.i+9;
            x1=x-9000;
            temp=find(handles.deltaENCO(x1-40:x1+40,j)==min(handles.deltaENCO(x1-40:x1+40,j)));
            x1=round(temp+x1-41);
            x=x1+9000
            handles.timing(j)=x1;
            handles.MaxPlantError(j)=handles.deltaENCO(x1,j);
            s=['set(handles.MaxError',num2str(10),',''string'',',num2str(handles.MaxPlantError(j)),')'];eval(s)
            s=['set(handles.ErrorTiming',num2str(10),',''string'',',num2str(handles.timing(j)),')'];eval(s)
        end
        
        set(h(:,move),'xdata',[x x])
        set(h(:,move),'color','k')
        
    else
        over=1;
    end
end



guidata(hObject, handles);



% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename,pathname]=uigetfile('*.mat','Sélectionnez votre fichier AnalENCO')
load([pathname,filename])

MaxPlantError.CHAMP(:,handles.subject)=handles.MaxPlantError;
MaxPlantErrortiming.CHAMP(:,handles.subject)=handles.timing;

novalid=find(isnan(handles.MaxPlantError)==1);
meanABSError.CHAMP(novalid,handles.subject)=nan;
CoG.CHAMP(novalid,handles.subject)=nan;

[filename, pathname]=uiputfile('*.mat','Placez le fichier AnalENCO');
save(filename,'ENCO','baseline2','cycleID','BASELINE2end','CHAMPend','POSTend','deltaENCO','MaxDorsiError','MaxPlantError','meanABSError','meanSIGNEDError','meanUndershoot','meanOvershoot', 'percentUndershoot', 'percentOvershoot','dureeswing', 'peakDorsi', 'peakPlant', 'MaxDorsiErrortiming', 'MaxPlantErrortiming', 'peakDorsitiming', 'peakPlanttiming','CoG'); 



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


% --- Executes on button press in notvalid1.
function notvalid1_Callback(hObject, eventdata, handles)
% hObject    handle to notvalid1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cond=get(handles.notvalid1,'string');

if strcmp(cond,'VALID')==1
    set(handles.notvalid1,'string','NOT VALID')
    set(handles.notvalid1,'backgroundcolor','r')
    % elseif strcmp(cond,'VALID')==0
    %    set(handles.notvalid1,'string','VALID')
    %     set(handles.notvalid1,'backgroundcolor','g')
    handles.MaxPlantError(handles.i)=nan;
    handles.timing(handles.i)=0;
    set(handles.MaxError1,'string',num2str(handles.MaxPlantError(handles.i)))
    set(handles.ErrorTiming1,'string',num2str(handles.timing(handles.i)))
    
end
guidata(hObject, handles);


% --- Executes on button press in notvalid2.
function notvalid2_Callback(hObject, eventdata, handles)
% hObject    handle to notvalid2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cond=get(handles.notvalid2,'string');

if strcmp(cond,'VALID')==1
    set(handles.notvalid2,'string','NOT VALID')
    set(handles.notvalid2,'backgroundcolor','r')
    % elseif strcmp(cond,'VALID')==0
    %    set(handles.notvalid2,'string','VALID')
    %     set(handles.notvalid2,'backgroundcolor','g')
    handles.MaxPlantError(handles.i+1)=nan;
    handles.timing(handles.i+1)=0;
    set(handles.MaxError2,'string',num2str(handles.MaxPlantError(handles.i+1)))
    set(handles.ErrorTiming2,'string',num2str(handles.timing(handles.i+1)))
    
end
guidata(hObject, handles);


% --- Executes on button press in notvalid3.
function notvalid3_Callback(hObject, eventdata, handles)
% hObject    handle to notvalid3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cond=get(handles.notvalid3,'string');

if strcmp(cond,'VALID')==1
    set(handles.notvalid3,'string','NOT VALID')
    set(handles.notvalid3,'backgroundcolor','r')
    % elseif strcmp(cond,'VALID')==0
    %    set(handles.notvalid3,'string','VALID')
    %     set(handles.notvalid3,'backgroundcolor','g')
    handles.MaxPlantError(handles.i+2)=nan;
    handles.timing(handles.i+2)=0;
    set(handles.MaxError3,'string',num2str(handles.MaxPlantError(handles.i+2)))
    set(handles.ErrorTiming3,'string',num2str(handles.timing(handles.i+2)))
end
   guidata(hObject, handles);


% --- Executes on button press in notvalid4.
function notvalid4_Callback(hObject, eventdata, handles)
% hObject    handle to notvalid4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cond=get(handles.notvalid4,'string');

if strcmp(cond,'VALID')==1
    set(handles.notvalid4,'string','NOT VALID')
    set(handles.notvalid4,'backgroundcolor','r')
    % elseif strcmp(cond,'VALID')==0
    %    set(handles.notvalid4,'string','VALID')
    %     set(handles.notvalid4,'backgroundcolor','g')
    handles.MaxPlantError(handles.i+3)=nan;
    handles.timing(handles.i+3)=0;
    set(handles.MaxError4,'string',num2str(handles.MaxPlantError(handles.i+3)))
    set(handles.ErrorTiming4,'string',num2str(handles.timing(handles.i+3)))
end
guidata(hObject, handles);


% --- Executes on button press in notvalid5.
function notvalid5_Callback(hObject, eventdata, handles)
% hObject    handle to notvalid5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cond=get(handles.notvalid5,'string');

if strcmp(cond,'VALID')==1
    set(handles.notvalid5,'string','NOT VALID')
    set(handles.notvalid5,'backgroundcolor','r')
    % elseif strcmp(cond,'VALID')==0
    %    set(handles.notvalid5,'string','VALID')
    %     set(handles.notvalid5,'backgroundcolor','g')
    handles.MaxPlantError(handles.i+4)=nan;
    handles.timing(handles.i+4)=0;
    set(handles.MaxError5,'string',num2str(handles.MaxPlantError(handles.i+4)))
    set(handles.ErrorTiming5,'string',num2str(handles.timing(handles.i+4)))
end
guidata(hObject, handles);


% --- Executes on button press in notvalid6.
function notvalid6_Callback(hObject, eventdata, handles)
% hObject    handle to notvalid6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cond=get(handles.notvalid6,'string');

if strcmp(cond,'VALID')==1
    set(handles.notvalid6,'string','NOT VALID')
    set(handles.notvalid6,'backgroundcolor','r')
    % elseif strcmp(cond,'VALID')==0
    %    set(handles.notvalid6,'string','VALID')
    %     set(handles.notvalid6,'backgroundcolor','g')
    handles.MaxPlantError(handles.i+5)=nan;
    handles.timing(handles.i+5)=0;
    set(handles.MaxError6,'string',num2str(handles.MaxPlantError(handles.i+5)))
    set(handles.ErrorTiming6,'string',num2str(handles.timing(handles.i+5)))
end
guidata(hObject, handles);


% --- Executes on button press in notvalid7.
function notvalid7_Callback(hObject, eventdata, handles)
% hObject    handle to notvalid7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cond=get(handles.notvalid7,'string');

if strcmp(cond,'VALID')==1
    set(handles.notvalid7,'string','NOT VALID')
    set(handles.notvalid7,'backgroundcolor','r')
    % elseif strcmp(cond,'VALID')==0
    %    set(handles.notvalid7,'string','VALID')
    %     set(handles.notvalid7,'backgroundcolor','g')
    handles.MaxPlantError(handles.i+6)=nan;
    handles.timing(handles.i+6)=0;
    set(handles.MaxError7,'string',num2str(handles.MaxPlantError(handles.i+6)))
    set(handles.ErrorTiming7,'string',num2str(handles.timing(handles.i+6)))
end
guidata(hObject, handles);


% --- Executes on button press in notvalid8.
function notvalid8_Callback(hObject, eventdata, handles)
% hObject    handle to notvalid8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cond=get(handles.notvalid8,'string');

if strcmp(cond,'VALID')==1
    set(handles.notvalid8,'string','NOT VALID')
    set(handles.notvalid8,'backgroundcolor','r')
    % elseif strcmp(cond,'VALID')==0
    %    set(handles.notvalid8,'string','VALID')
    %     set(handles.notvalid8,'backgroundcolor','g')
    handles.MaxPlantError(handles.i+7)=nan;
    handles.timing(handles.i+7)=0;
    set(handles.MaxError8,'string',num2str(handles.MaxPlantError(handles.i+7)))
    set(handles.ErrorTiming8,'string',num2str(handles.timing(handles.i+7)))
end
guidata(hObject, handles);


% --- Executes on button press in notvalid9.
function notvalid9_Callback(hObject, eventdata, handles)
% hObject    handle to notvalid9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cond=get(handles.notvalid9,'string');

if strcmp(cond,'VALID')==1
    set(handles.notvalid9,'string','NOT VALID')
    set(handles.notvalid9,'backgroundcolor','r')
    % elseif strcmp(cond,'VALID')==0
    %    set(handles.notvalid9,'string','VALID')
    %     set(handles.notvalid9,'backgroundcolor','g')
    handles.MaxPlantError(handles.i+8)=nan;
    handles.timing(handles.i+8)=0;
    set(handles.MaxError9,'string',num2str(handles.MaxPlantError(handles.i+8)))
    set(handles.ErrorTiming9,'string',num2str(handles.timing(handles.i+8)))
end
guidata(hObject, handles);


% --- Executes on button press in notvalid10.
function notvalid10_Callback(hObject, eventdata, handles)
% hObject    handle to notvalid10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cond=get(handles.notvalid10,'string');

if strcmp(cond,'VALID')==1
    set(handles.notvalid10,'string','NOT VALID')
    set(handles.notvalid10,'backgroundcolor','r')
    % elseif strcmp(cond,'VALID')==0
    %    set(handles.notvalid10,'string','VALID')
    %     set(handles.notvalid10,'backgroundcolor','g')
    handles.MaxPlantError(handles.i+9)=nan;
    handles.timing(handles.i+9)=0;
    set(handles.MaxError10,'string',num2str(handles.MaxPlantError(handles.i+9)))
    set(handles.ErrorTiming10,'string',num2str(handles.timing(handles.i+9)))
end
guidata(hObject, handles);
