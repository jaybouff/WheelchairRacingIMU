close  all
clear
clc
%%Constantes
Fz=256; % fréquence d'échantillon
FzSP=50;
Samplenumber = 1:5121;
Sample=transpose(Samplenumber);
Time=Sample/Fz;


NombreDePousseesMax = 20;
tempsminimal=0.30;
sampleminimal=tempsminimal*Fz;
MinPeakProminence=0.05; %Pour le Frame
MinPeakProminenceH=0.4; %Pour les mains



%% Aller chercher la table d'enregistrée à partir du code
% SeparationDesEssais
load('Table.mat');

listRogr = dir('Rograssine*');

for ifile = 1:size(listRogr,1)
    tempSP.(['file',num2str(ifile)])=load(listRogr(ifile).name,'c2');
end

MaxlenSP = 0;
for ifile = 1:size(listRogr,1)
     lenessai = length(tempSP.(['file',num2str(ifile)]).c2);
     if lenessai>MaxlenSP
         MaxlenSP=lenessai;
     end
end

Table.SciencePerfo.position.rawdata(1:MaxlenSP, 1:size(listRogr,1))=nan;

for ifile = 1:size(listRogr,1)
    Table.SciencePerfo.position.rawdata(1:length(tempSP.(['file',num2str(ifile)]).c2)-1,ifile)=tempSP.(['file',num2str(ifile)]).c2(2:end,:);
end



%load('Rograssine-2021-10-07-17-07-33-179.mat')

%%Identification des variables 
%Ici, pas besoin d'identifier chaque channel Gyro, accel, quat car ils sont
%déja sous forme de table dans les canaux. Par contre, dans chaque canaux
%il y a 5 colonnes, une par essai. Il faut donc identifier chaque essai 
Segments = {'dHTable.rawdata.dHand','Table.rawdata.dForearm','Table.rawdata.dArm','Table.rawdata.Sternum','Table.rawdata.Frame','Table.rawdata.ndHand'};
NombreEssai=size(Table.dHand.AccelX.rawdata,2);
%%Load Data
TimeSP= transpose((1:MaxlenSP)*1/FzSP);
TimeSPcut = TimeSP(1:700,1);

%% Filter data
Fc = [0.2, 15]; % bande passante 0.2 et 15 Hz
Ordre = 2; % 2e ordre
[b,a] = butter(Ordre,Fc/(Fz/2)); % et on crée le filtre

%La la différence cest que les accels sont sous forme de canaux et non de
%colonne dans la matrice

Table.dHand.AccelX.fdata0215 = filtfilt(b,a,Table.dHand.AccelX.rawdata);
Table.dHand.AccelY.fdata0215 = filtfilt(b,a,Table.dHand.AccelY.rawdata);
Table.dHand.AccelZ.fdata0215 = filtfilt(b,a,Table.dHand.AccelZ.rawdata);

Table.ndHand.AccelX.fdata0215  = filtfilt(b,a,Table.ndHand.AccelX.rawdata);
Table.ndHand.AccelY.fdata0215 = filtfilt(b,a,Table.ndHand.AccelY.rawdata);
Table.ndHand.AccelZ.fdata0215 = filtfilt(b,a,Table.ndHand.AccelZ.rawdata);

Table.Frame.AccelX.frotdata0215 = filtfilt(b,a,Table.Frame.AccelX.rotdata);
Table.Frame.AccelY.frotdata0215 = filtfilt(b,a,Table.Frame.AccelY.rotdata);
Table.Frame.AccelZ.frotdata0215 = filtfilt(b,a,Table.Frame.AccelZ.rotdata);

% Filter data [0.2,3 Hz) for blablabal; see Bergamini (2015)
Fc = [0.2, 3]; 
[b,a] = butter(Ordre,Fc/(Fz/2)); % et on crée le filtre

Table.dHand.AccelX.fdata0203 = filtfilt(b,a,Table.dHand.AccelX.rawdata);
Table.dHand.AccelY.fdata0203 = filtfilt(b,a,Table.dHand.AccelY.rawdata);
Table.dHand.AccelZ.fdata0203 = filtfilt(b,a,Table.dHand.AccelZ.rawdata);

Table.ndHand.AccelX.fdata0203  = filtfilt(b,a,Table.ndHand.AccelX.rawdata);
Table.ndHand.AccelY.fdata0203 = filtfilt(b,a,Table.ndHand.AccelY.rawdata);
Table.ndHand.AccelZ.fdata0203 = filtfilt(b,a,Table.ndHand.AccelZ.rawdata);

Table.Frame.AccelX.frotdata0203 = filtfilt(b,a,Table.Frame.AccelX.rotdata);
Table.Frame.AccelY.frotdata0203 = filtfilt(b,a,Table.Frame.AccelY.rotdata);
Table.Frame.AccelZ.frotdata0203 = filtfilt(b,a,Table.Frame.AccelZ.rotdata);

% Filter data [3 Hz) for cumulative integrals; see 
Fc = 3; 
[b,a] = butter(Ordre,Fc/(Fz/2),'low'); % et on crée le filtre


Table.dHand.AccelX.fdata03LP = filtfilt(b,a,Table.dHand.AccelX.rawdata);
Table.dHand.AccelY.fdata03LP = filtfilt(b,a,Table.dHand.AccelY.rawdata);
Table.dHand.AccelZ.fdata03LP = filtfilt(b,a,Table.dHand.AccelZ.rawdata);

Table.ndHand.AccelX.fdata03LP  = filtfilt(b,a,Table.ndHand.AccelX.rawdata);
Table.ndHand.AccelY.fdata03LP = filtfilt(b,a,Table.ndHand.AccelY.rawdata);
Table.ndHand.AccelZ.fdata03LP = filtfilt(b,a,Table.ndHand.AccelZ.rawdata);

Table.Frame.AccelX.frotdata03LP = filtfilt(b,a,Table.Frame.AccelX.rotdata);
Table.Frame.AccelY.frotdata03LP = filtfilt(b,a,Table.Frame.AccelY.rotdata);
Table.Frame.AccelZ.frotdata03LP = filtfilt(b,a,Table.Frame.AccelZ.rotdata);

%Filtre pour sciencePerfo
Table.SciencePerfo.position.rawdata(isnan(Table.SciencePerfo.position.rawdata))=0;

Fc = 3; 
[b,a] = butter(Ordre,Fc/(FzSP/2),'low'); % et on crée le filtre

Table.SciencePerfo.position.fdata04LP = filtfilt(b,a,Table.SciencePerfo.position.rawdata);

%Transformer les données de SciencePerfo en accélération pour les intégrer
%au code
Table.SciencePerfo.vitessekmh.fdata04LP=((diff(Table.SciencePerfo.position.fdata04LP))*FzSP)*3.6;
Table.SciencePerfo.vitessems.fdata04LP=((diff(Table.SciencePerfo.position.fdata04LP))*FzSP);
Table.SciencePerfo.accelkmh.fdata04LP=((diff(Table.SciencePerfo.vitessekmh.fdata04LP))*FzSP);
Table.SciencePerfo.accelms.fdata04LP=((diff(Table.SciencePerfo.vitessems.fdata04LP))*FzSP);

%Maintenant, on intègre les valeurs du frame

Table.Frame.Vitessexkmh.frotdata03LP = cumtrapz(Table.Frame.AccelX.frotdata03LP*9.8)*(3.6)/(Fz);
Table.Frame.Vitessexms.frotdata03LP = cumtrapz(Table.Frame.AccelX.frotdata03LP*9.8)/(Fz);
Table.Frame.Positionxms.frotdata03LP = cumtrapz(Table.Frame.Vitessexms.frotdata03LP)/(Fz);
%%
Table.SciencePerfo.vitessekmh.fdata04LPcut = Table.SciencePerfo.vitessekmh.fdata04LP(1:700,:);


Sensor = {'SP','IMU'};
Variables = {'maximum','minimum'};
VecteursTemporels = {TimeSPcut, Time};
VecteursVitesse = {Table.SciencePerfo.vitessekmh.fdata04LPcut, Table.Frame.Vitessexkmh.frotdata03LP};




%Trouver les True or false
 Variable.maximum.courbevit.TouF.SP = islocalmax(Table.SciencePerfo.vitessekmh.fdata04LPcut, 1,'MinSeparation', tempsminimal*FzSP,'FlatSelection', 'first');
 Variable.minimum.courbevit.TouF.SP = islocalmin(Table.SciencePerfo.vitessekmh.fdata04LPcut, 1,'MinSeparation', tempsminimal*FzSP,'FlatSelection', 'first');
    
 Variable.maximum.courbevit.TouF.IMU= islocalmax(Table.Frame.Vitessexkmh.frotdata03LP, 1,'MinSeparation', tempsminimal*Fz,'FlatSelection', 'first');
 Variable.minimum.courbevit.TouF.IMU = islocalmin(Table.Frame.Vitessexkmh.frotdata03LP, 1,'MinSeparation', tempsminimal*Fz,'FlatSelection', 'first');




%NombreDePousseesMax


% Table.(Segments{isegment}).AccelX.rawdata(:,itrial) = data.(Segments{isegment}).data(trials(itrial,1):trials(itrial,2),Accelchannel(1));
%Maintenant ça fonctionne parfaitement pour SP mais pas pour IMU
for isensor = 1:length(Sensor)
    for ivariable = 1:length(Variables)
        for itrial=1:NombreEssai
         donnees = VecteursTemporels{isensor}(Variable.(Variables{ivariable}).courbevit.TouF.(Sensor{isensor})(:,itrial));
         Variable.(Variables{ivariable}).courbevit.temps.(Sensor{isensor})(2:NombreDePousseesMax+1,itrial)=donnees(1:NombreDePousseesMax,1);
        end
    end
end

for isensor = 1:length(Sensor)
    for ivariable = 1:length(Variables)
        for itrial=1:NombreEssai
         donnees = VecteursVitesse{isensor}(Variable.(Variables{ivariable}).courbevit.TouF.(Sensor{isensor})(:,itrial),itrial);
         Variable.(Variables{ivariable}).courbevit.vitesse.(Sensor{isensor})(2:NombreDePousseesMax+1,itrial)=donnees(1:NombreDePousseesMax,1);
        end
    end
end

%% Déterminer les variables en fonction des données 
% Durée d'une poussée

for isensor = 1:length(Sensor)
    for ivariable = 1:length(Variables)
        for itrial=1:NombreEssai
        Variable.PushTime.(Sensor{isensor}).(Variables{ivariable})(1:NombreDePousseesMax,itrial)=...
        Variable.(Variables{ivariable}).courbevit.temps.(Sensor{isensor})(2:NombreDePousseesMax+1,itrial) -...
        Variable.(Variables{ivariable}).courbevit.temps.(Sensor{isensor})(1:NombreDePousseesMax,itrial);
        end
    end
end

% Gain de vitesse

for isensor = 1:length(Sensor)
    for ivariable = 1:length(Variables)
        for itrial=1:NombreEssai
        Variable.SpeedGain.(Sensor{isensor}).(Variables{ivariable})(1:NombreDePousseesMax,itrial)=...
        Variable.(Variables{ivariable}).courbevit.vitesse.(Sensor{isensor})(2:NombreDePousseesMax+1,itrial) -...
        Variable.(Variables{ivariable}).courbevit.vitesse.(Sensor{isensor})(1:NombreDePousseesMax,itrial);
        end
    end
end

% Vitesse moyenne par poussée
% Pour y arriver, il faut trouver la moyenne de la courbe entre deux
% points. Ce qui serait logique serait de prendre la courbe de vitesse
% entre deux mins ou deux maxs. 

% Table.SciencePerfo.vitessekmh.fdata04LPcut et Table.Frame.Vitessexkmh.frotdata03LP

for isensor = 1:length(Sensor)
    for ivariable = 1:length(Variables)
        for itrial=1:NombreEssai
            for ipoussee = 1:NombreDePousseesMax-1
            
            if (round(Variable.(Variables{ivariable}).courbevit.temps.(Sensor{isensor})((ipoussee),itrial)*FzSP))==0
                debut_moyenne = 1;
            else
                debut_moyenne = (round(Variable.(Variables{ivariable}).courbevit.temps.(Sensor{isensor})((ipoussee),itrial)*FzSP));
            end

            fin_moyenne = (round(Variable.(Variables{ivariable}).courbevit.temps.(Sensor{isensor})((ipoussee+1),itrial)*FzSP));

            Variable.Mean.(Variables{ivariable}).courbevit.(Sensor{isensor})(ipoussee,itrial) = ...
            mean(Table.SciencePerfo.vitessekmh.fdata04LPcut(...
            debut_moyenne:fin_moyenne,itrial));
            end
        end
    end
end


%Probleme actuel est que le premier chiffre est un zero, il faudrait que ce
%soit un 1 pour fonctionner dans la fonction


for itrial = 1:NombreEssai 

    clf
    subplot(2,1,1)
    plot(TimeSPcut(:,1),Table.SciencePerfo.vitessekmh.fdata04LPcut(:,itrial), ...
        Variable.maximum.courbevit.temps.SP(2:NombreDePousseesMax+1,itrial),Variable.maximum.courbevit.vitesse.SP(2:NombreDePousseesMax+1,itrial),'r*',...
    Variable.minimum.courbevit.temps.SP(2:NombreDePousseesMax+1,itrial), Variable.minimum.courbevit.vitesse.SP(2:NombreDePousseesMax+1,itrial),'b*')

    subplot(2,1,2)
    plot(Time(:,1),Table.Frame.Vitessexkmh.frotdata03LP(:,itrial), ...
        Variable.maximum.courbevit.temps.IMU(2:NombreDePousseesMax+1,itrial), Variable.maximum.courbevit.vitesse.IMU(2:NombreDePousseesMax+1,itrial),'r*',...
    Variable.minimum.courbevit.temps.IMU(2:NombreDePousseesMax+1,itrial),  Variable.minimum.courbevit.vitesse.IMU(2:NombreDePousseesMax+1,itrial),'b*')

     uiwait(msgbox('Cliquer sur OK pour passer au prochain essai'));
end


% for itrial = 1:NombreEssai
% 
%     clf
%     subplot(3,1,1)
%     plot(TimeSP(1:700,:),(Table.SciencePerfo.accelms.fdata04LP(1:700,itrial)/9.8))
%     hold on
%     plot(Time,Table.Frame.AccelX.frotdata0203(:,itrial),'g')
%     grid on
%     ylabel('Acceleration (ms2)')
%     xlabel('Time')
%     
%     subplot(3,1,2)
%     plot(TimeSP(1:700,:), Table.SciencePerfo.vitessekmh.fdata04LP(1:700,itrial))
%     hold on
%     plot(Time,Table.Frame.Vitessexkmh.frotdata03LP(:,itrial),'g')
%     grid on
%     ylabel('Velocity (kmh)')
%     xlabel('Time') 
%     
%     subplot(3,1,3)
%     plot(TimeSP(1:700,:), (Table.SciencePerfo.position.fdata04LP(1:700,1)-Table.SciencePerfo.position.fdata04LP(1,itrial)))
%     hold on
%     plot(Time,Table.Frame.Positionxms.frotdata03LP(:,itrial),'g')
%     grid on
%     ylabel('position (m)')
%     xlabel('Time')
%     
%     uiwait(msgbox('This message will pause execution until you click OK'));
% end






save('Analyses.mat','Table','Variable');