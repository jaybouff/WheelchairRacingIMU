%programme combine data

%amelioration de voir_reflex avec validation en continu et synchro un cycle
%sur deux (18 juin 2012) Amélioration, enlève moyenne EMG JASON(19 novembre
%2012)

clear all;
close all;

%% load calibration file
k=menu('Data pre-treatment program v2.0','OK');
k=menu('Please make sure that you are in the data folder','OK');
    
[fn,pn]=uigetfile('*.mat','select the calibration file');
load([pn,fn],'-mat');

%% convert data
choice=menu('do you want to convert data from spike','yes','no');
if choice==1
    choice2=1; %repeat loop until choice2=1
    while choice2<2
        convert;
        choice2=menu('do you want to convert another file?','yes','no');
    end; %while
end; %if

%% data transformation
k=menu('data will now be prepared','OK');

count=0; %number of files transformed
choice=1;

while choice==1
    count=count+1;
    [fn,pn]=uigetfile('*.*','select a data file');
    load([pn,fn],'-mat');
    
    %check for filetype
    a=whos('data');
    if isempty(a)% that means it is a spike file
        %select only the good channels & put them into the 'rawdata' table
        rawdata=[];
        %EMG first
        h=waitbar(0,'please wait');
        for i=1:size(EMG_channels,2);
            waitbar(i/size(EMG_channels,2),h,['processing ',chan_name(i)]);
            s=['temp=chan',num2str(EMG_channels(i)),';']; eval(s);
            %length verification
            rawdata_length=size(rawdata,1);
            chan_length=size(temp,1);
            if rawdata_length==0
                %do nothing
            elseif rawdata_length<chan_length
                temp=temp(1:end-1);
            elseif rawdata_length>chan_length
                temp(end+1)=temp(end);
            end; %if
                
                
            rawdata=[rawdata,temp];
        end;
        close(h);
        %then other channels
        h=waitbar(0,'please wait');
        for j=1:size(Other_channels,2);
            waitbar(i/size(Other_channels,2),h,['processing ',chan_name(i+j)]);
            s=['temp=chan',num2str(Other_channels(j)),';']; eval(s);
            %length verification
            rawdata_length=size(rawdata,1);
            chan_length=size(temp,1);
            if rawdata_length==0
                %do nothing
            elseif rawdata_length<chan_length
                temp=temp(1:end-1);
            elseif rawdata_length>chan_length
                temp(end+1)=temp(end);
            end; %if
           
            
            
            rawdata=[rawdata,temp];
        end;
        close(h);
        
        %down sample
        choice=menu('downsample data to 1 kHz?','yes','no');
        if choice==1
            h=waitbar(0,'downsampling to 1 kHz');
            data=downsample(rawdata,2);
            close(h);
        else
            data=rawdata;
        end;
    else %that means it is a Winvisio file
        rawdata=data(:,EMG_channels);
        data=[rawdata, data(:,Other_channels)];
    end;
    
    clear rawdata;
    
    
    
    %calibrate data
    data=double(data);
    %+++++++++++ICI ON POURRAIT CALIBRER LES DONNEES
    
    numchan=size(data,2); %calcule le nombre de canaux
    
    %filter emg
    h=waitbar(0.5,'Filtering EMG... please wait');
    emgdata=data(:,1:size(EMG_channels,2)); %filtrer juste l'EMG
    Fc=EMG_filter;
    order=2;
    [b,a] = butter(order,Fc/500);
    fdata=filtfilt(b,a,emgdata);
    for i=1:size(EMG_channels,2)
        fdata(:,i)=fdata(:,i)-mean(fdata(:,i),1);
    end
    fdata_display=fdata;
    %fdata=abs(fdata); %Keep EMG not rectify as long as possible
    close(h);
    
    %filter other channels
    h=waitbar(0.5,'Filtering other channels... please wait');
    otherdata=data(:,size(EMG_channels,2)+1:size(EMG_channels,2)+size(Other_channels,2)); %filtrer juste les canaux non EMG
    Fc=Other_filter;
    order=2;
    [b,a] = butter(order,Fc/500);
    fdata2=filtfilt(b,a,otherdata);
    close(h);
    
    
    %combine all channels
    fdata=[fdata,fdata2];
    fdata_display=[fdata_display,fdata2];%so that we don<t see rectified EMG

    
    %save data temporarily
    save(['temp_',num2str(count)],'fdata');
    clear fdata;
    clear data;
    
    %ask to continue
    choice=menu('Process another data file?','yes','no');
end; %while

%% data combination
choice=menu('Do you want to combine data files?','yes','no');
if choice==1 %combine temp_n files
    tempdata=[];
    for i=1:count %number of files to be combined
        state=menu(['Choose a condition for file#',num2str(i)],'CTRL','FF','POST','Skip');
        s=['load(''temp_',num2str(i),''');']; eval(s);
        switch state
            case 1
                fdata(:,end+1)=0; %add on channel with value 0
            case 2
                fdata(:,end+1)=2; %add on channel with value 2
            case 3
                fdata(:,end+1)=-1; %add on channel with value -1
        end; %switch ** do nothing for case 4
                
        tempdata=[tempdata;fdata];
    end;
        fdata=tempdata;
        clear tempdata;
        save('combined_data','fdata');
else %no combination
    load('temp_1'); %load temp file containing fdata
    save('combined_data','fdata'); % so from here loading combined data is sufficient

end;
