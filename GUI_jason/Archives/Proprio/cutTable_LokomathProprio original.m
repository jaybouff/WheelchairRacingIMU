%programme make_data_tables

%this program validates gait cycles and creates tables

%Modifiée par Jason: 10 juillet 2012: add chan_gain ligne 136 et max cycle
%lenght 2000 ligne 129


function cutTable_LokomathProprio 

%% decouper cycles

[filename,pathfile]=uigetfile('*.*','Choisir fichier de calibration');
load([pathfile,filename],'-mat')

[filename,pathfile]=uigetfile('*.*','Choisir fichier de données');
load([pathfile,filename],'-mat')

Rdata(1,1)=data(1,2); % pour enlever erreur due au Read_WinVsio_LB
data=data';
%creer un canal de trig a partir des plaques de force


for i=1:length(EMG_channels)
    data(:,i)=data(:,i)-mean(data(:,i));
    [b,a]=butter(2,EMG_filter/500);
    fdata(:,i)=filtfilt(b,a,data(:,i));
    rawdata(:,i)=data(:,i);
end

for i=1:length(Other_channels)
    [b,a]=butter(2,Other_filter/500);
    fdata(:,i+length(EMG_channels))=filtfilt(b,a,data(:,Other_channels(i)));
    rawdata(:,i+length(EMG_channels))=data(:,Other_channels(i));
end



ftrigChannel=fdata(:,Sync_channel);
% Fc=10;
% order=2;
% [b,a] = butter(order,Fc/500);
% ftrigChannel=filtfilt(b,a,trigChannel);

%On détermine le minimum du signal
minimum=min(ftrigChannel);
maximum=max(ftrigChannel);

validnum(1)=find(strcmp(chan_name,'ENCO')==1);
validnum(2)=find(strcmp(chan_name,'COUPLE')==1);
validnum(3)=find(strcmp(chan_name,'HS')==1);

responsechan=find(strcmp(chan_name,'Response')==1);
    
%On définit la bande d'analyse
ftrigChannel=(ftrigChannel-minimum)/maximum;
band_analyse=0.50*abs(maximum-minimum);

%On decime le signal pour accélérer le processus
temp=ftrigChannel;
signal=decimate(temp,5);

%Parametre d'entré de la boucle indéfinie
choix_refaire=['oui'];

while strcmp(choix_refaire,'oui')
    
    %On clear certaines variables
    clear identifiant
    clear id
    clear test1 test2 test3
    clear no_pts_test
    
    %Définition du seuil de détection, de la durée d'un cycle et du début
    %de la prériode d'analyse 10000=sampling rate * 10 secondes
    figure(1);
    clf
    if 10000/5<length(signal)
        debut_signal=round(length(signal)/10);
        fin_signal=debut_signal+1000*10/5;
        if fin_signal>length(signal)
            fin_signal=length(signal);
        end
        plot(signal(debut_signal:fin_signal));
    else
        plot(signal(1:end));
    end

    %Définition du seuil
    title('Definir le seuil de détection');
    [x,seuil]=ginput(1);
    
    %Définition de la durée d'un cycle
    title('Definir la durée d''un cycle (Cliquer le début)');
    [x(1),y]=ginput(1);
    title('Definir la durée d''un cycle (Cliquer la  fin)');
    [x(2),y]=ginput(1);
    duree_cycle=round(x(2)-x(1));
    
    %Définition du point de départ
    title('Definir le point de depart');
    

    
    %On détermine les points qui se trouvent dans la bande d'analyse
    test_up=(signal>seuil); %On regarde les point plus grand que le seuil minimum
    
    %Position du premier cycle
    j=1; %itère le nombre de cycle
    UP=find(test_up==0); 
    identifiant_init(j)=UP(1);
    
    %On définit la période réfractaire (50pct de la durée du cycles)
    [pct_refractaire]=input('Quelle est la période réfractaire? (normalement 80%, écriver nombre entier ex 80)');
    
    pct_refractaire=pct_refractaire/100;
    refractaire=round(pct_refractaire*duree_cycle);
    
    i=2; %itère le no. du point étudié
    h = waitbar(0,'Please wait...');
    
     
    %------------------------------------------------------------------------%
    % Génération d'un identifiant indiquant la début d'un nouveau cycle
    %------------------------------------------------------------------------%
    while i<length(test_up)-1
        point1=test_up(i);
        point2=test_up(i+1);
        
        %On test le point désiré
        if (point1>point2)&&(i>(identifiant_init(j)+refractaire))
            j=j+1; % On itere le nombre de pas
            identifiant_init(j)=i;
            i=i+refractaire;
        end
        
        %On passe au point suivant
        i=i+1;
        waitbar(i/length(test_up),h);
    end
    close(h);
    
Cycle_Table=[];
Cycle_Table(:,1)=[identifiant_init(1:end-1)*5];%*5 à cause du facteur de décimation
Cycle_Table(:,2)=[identifiant_init(2:end)*5];
Cycle_Table(:,3)=0; %set all gait cycles as non valid

    figure(1)
    plot(1:size(Cycle_Table,1),Cycle_Table(:,2)-Cycle_Table(:,1),'bo')
    
choix_refaire=menu('Voulez vous redéfinir le seuil du foot switch?','oui','non');
end

clf

Choix_offset=1;

while Choix_offset==1
clf
for j=10:100:size(Cycle_Table,1)
    subplot(4,1,1)
plot(fdata(Cycle_Table(j,1):Cycle_Table(j,2),validnum(1)),'b')
hold on

title('ENCO')

subplot(4,1,2)
plot(diff(fdata(Cycle_Table(j,1):Cycle_Table(j,2),validnum(1))),'b')
hold on
title('Velocity')

subplot(4,1,3)
plot(fdata(Cycle_Table(j,1):Cycle_Table(j,2),validnum(3)),'b')
hold on
title('HS')

subplot(4,1,4)
plot(rawdata(Cycle_Table(j,1):Cycle_Table(j,2),validnum(2)),'b')
hold on
title('COUPLE')
end

Choix_offset=menu('Do you want to create an offset of the HS position','Yes','No')

if Choix_offset==1
    title('put the ginput where you would like the stride end')
    debut=ginput(1);
    debut=round(debut(1));
    
    title('put the ginput where the stride presently stop')
    fin=ginput(1);
    fin=round(fin(1));
    
    offset=fin-debut;
    Cycle_Table(2:end,1)=Cycle_Table(2:end,1)-offset;
    Cycle_Table(2:end,2)=Cycle_Table(2:end,2)-offset;
    
    
end


end

%% create the generic tables padded with NaNs
numchan=size(fdata,2);    
h=waitbar(0,'please wait');
vector_length=2000; %max(Cycle_Table(:,2)-Cycle_Table(:,1))+1;%max duration of a gait cycle
k=0;
for j=1:numchan
        waitbar(j/numchan,h,['processing ',chan_name(j)]);
    s=['Table',num2str(j),'=[];'];eval(s); %creates an empty table
    for i=1:size(Cycle_Table,1)
        the_onset=Cycle_Table(i,1);
        the_end=Cycle_Table(i,2);
        temp=fdata(the_onset:the_end,j)*chan_gain(j); %channel(j) %****ATTENTION
        if size(temp,1)<vector_length
            temp(end+1:vector_length)=nan;
        else
            temp=temp(1:vector_length);
        end;
        s=['Table',num2str(j),'=[Table',num2str(j),',temp];'];eval(s); %adds new cycle to table
    end; %for i    
end; %for j
close(h);

%% create response indexes
Cycle_Table(:,4)=0; %fourth column is reflex cycle or not


    s=['temp_Table=Table',num2str(responsechan),';'];eval(s);
    for i=1: size(temp_Table,2)
        if min(temp_Table(1:end,i))<detect_level
            Cycle_Table(i,4)=1;
        end;
        %k=waitforbuttonpress;
    end;


%% create FF indexes
Cycle_Table(:,5)=0; %fifth column is force field cycle or not

if ISFF_channel>0 %if there are FF
    s=['temp_Table=abs(Table',num2str(ISFF_channel),')',';'];eval(s);
    for i=1: size(temp_Table,2)
        if max(temp_Table(FFdetect_onset:FFdetect_offset,i)>FFdetect_level)
            Cycle_Table(i,5)=1;
        end;
        %k=waitforbuttonpress;
    end;
end;



%% save tables & stimpos
save('Table_data','Table*','Cycle_Table','numchan','chan_name');
