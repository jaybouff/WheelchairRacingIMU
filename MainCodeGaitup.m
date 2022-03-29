%% ATTENTION, DES FOIS IL Y A 12 CANAUX JE NE SAIS PAS PK

%% Variable identification
clear 
clc
close all
% Sensor to segment coding
Segments = {'dHand','dForearm','dArm','Sternum','Frame','ndHand'};
Sensors = {'dHand.csv','dForearm.csv','dArm.csv','Sternum.csv','Frame.csv','ndHand.csv'};

% Channel identification
Gyrochannel = 2:4; % les numéros de canaux gyro
Accelchannel = 5:7; % les numéros de canaux accel
Quatchannel = 8:11; % les numéros de canaux Quaternion
Timechannel = 1; % le channel temps
nchannel = 11; %le nombre de canaux total

%% Trial detection parameters
MinimalDuration = 5;
MinimalGap = 60;

TrialDuration = 20;


%% Filter data
Fz=256; % fréquence d'échantillon
Fc = [0.2, 15]; % bande passante 0.2 et 15 Hz
Ordre = 2; % 2e ordre
[b,a] = butter(Ordre,Fc/(Fz/2)); % et on crée le filtre

%% Load data

for isegment = 1:length(Segments)
    data.(Segments{isegment})=importdata([Segments{isegment},'.csv']);
    
    %% S'il y a un canal event, on le retire (il se trouve normalement à la 8e colonne)
    if size(data.(Segments{isegment}).data,2)==12
        data.(Segments{isegment}).data=[data.(Segments{isegment}).data(:,1:7),data.(Segments{isegment}).data(:,9:12)];
    end
        
end

%% Preprocessing 
% Filter data
for isegment = 1:length(Segments)
    
    for ichannel = 1: nchannel

        data.(Segments{isegment}).fdata(:,ichannel) = filtfilt(b,a,data.(Segments{isegment}).data(:,ichannel)); % ici on applique le filtre pour chauqe segment et chaque canal.
        
    end
    
end

%% Localisation essais 
% La première localisation plus macroscopique se fait avec la somme des
% accélérations vectorielles des mains et du Frame
AccelLinFrame = sqrt(data.Frame.fdata(:,Accelchannel(1)).^2+data.Frame.fdata(:,Accelchannel(2)).^2+data.Frame.fdata(:,Accelchannel(3)).^2); % accel vectorielle frame
AccelLindHand = sqrt(data.dHand.fdata(:,Accelchannel(1)).^2+data.dHand.fdata(:,Accelchannel(2)).^2+data.dHand.fdata(:,Accelchannel(3)).^2); % accel vectorielle main dominante
AccelLinndHand = sqrt(data.ndHand.fdata(:,Accelchannel(1)).^2+data.ndHand.fdata(:,Accelchannel(2)).^2+data.ndHand.fdata(:,Accelchannel(3)).^2); % accel vectorielle main non dominante
detectSignal = sum([AccelLindHand/mean(AccelLindHand),AccelLinndHand/mean(AccelLinndHand),AccelLinFrame/mean(AccelLinFrame)],2); % sommes des accelérations vectorielles

% Ici on trouve les moments ou la sommes des accélérations vectorielles est
% supérieur à un seuil

clf
plot(detectSignal) % on affiche le signal pour la détection d'essais
title('Place ton curseur pour déterminer un seuil (en Y) croisant tous tes essais (et seulement ceuxi-ci si possible)')
[~,threshold] = ginput(1); % on sélectionne le seuil grâce à un curseur
overthreshold = find(detectSignal>threshold); % on trouve les moments ou la somme des accélérations vectorielles est > que le seuil

% Find trials with minimal duration separated by minimal gaps
newtrial= find(diff(overthreshold)/Fz > MinimalGap)+1;
trialstart = [overthreshold(1);overthreshold(newtrial)];
trialend=[overthreshold(newtrial-1);overthreshold(end)];

validtrials= find((trialend-trialstart)/Fz > MinimalDuration);
trials = [trialstart(validtrials),trialend(validtrials)];

% for itrial = 1:size(trials,1)
%     hold on
%     plot(detectSignal(trials(itrial,1):trials(itrial,2)))
% end

% Placer début essai
% Graph 3 subplot frame et 2 main 30 second avant debut et mettre ginput au
% bon endroit
clf

for itrial = 1:size(trials,1)
    duration = (trials(itrial,2)-trials(itrial,1))/Fz;
    
subplot(3,1,1)
plot(-30:1/Fz:duration,AccelLinFrame(trials(itrial,1)-30*Fz:trials(itrial,2)));
ylabel('Frame')
title('Place ton curseur à l''endroit ou débute l''essai (1ere accélération des mains et du fauteuil')

subplot(3,1,2)
plot(-30:1/Fz:duration,AccelLindHand(trials(itrial,1)-30*Fz:trials(itrial,2)));
ylabel('dHand')

subplot(3,1,3)
plot(-30:1/Fz:duration,AccelLinndHand(trials(itrial,1)-30*Fz:trials(itrial,2)));
ylabel('ndHand')
xlabel(['Trial #' num2str(itrial)])

[debut,~] = ginput(1);
trials(itrial,1) = round(debut * Fz + trials(itrial,1));
trials(itrial,2) = trials(itrial,1) + TrialDuration*Fz;
end

%% Create structures containing only raw data from each trial 
% Example of a structure: Table.dHand.AccelX(1:nSample per trial,
% 1:nTrial) nSample per trial = TrialDuration * Fz (ici 20 secondes * 256Hz
% = 5120 (+1 parce que le premier sample a un indice de 1 et non de 0)
for isegment = 1: length(Segments)
    for itrial = 1:size(trials,1)
        
        Table.(Segments{isegment}).AccelX.rawdata(:,itrial) = data.(Segments{isegment}).data(trials(itrial,1):trials(itrial,2),Accelchannel(1));
        Table.(Segments{isegment}).AccelY.rawdata(:,itrial) = data.(Segments{isegment}).data(trials(itrial,1):trials(itrial,2),Accelchannel(2));
        Table.(Segments{isegment}).AccelZ.rawdata(:,itrial) = data.(Segments{isegment}).data(trials(itrial,1):trials(itrial,2),Accelchannel(3));
        Table.(Segments{isegment}).GyroX.rawdata(:,itrial) = data.(Segments{isegment}).data(trials(itrial,1):trials(itrial,2),Gyrochannel(1));
        Table.(Segments{isegment}).GyroY.rawdata(:,itrial) = data.(Segments{isegment}).data(trials(itrial,1):trials(itrial,2),Gyrochannel(2));
        Table.(Segments{isegment}).GyroZ.rawdata(:,itrial) = data.(Segments{isegment}).data(trials(itrial,1):trials(itrial,2),Gyrochannel(3));
        Table.(Segments{isegment}).Quat1.rawdata(:,itrial) = data.(Segments{isegment}).data(trials(itrial,1):trials(itrial,2),Quatchannel(1));
        Table.(Segments{isegment}).Quat2.rawdata(:,itrial) = data.(Segments{isegment}).data(trials(itrial,1):trials(itrial,2),Quatchannel(2));
        Table.(Segments{isegment}).Quat3.rawdata(:,itrial) = data.(Segments{isegment}).data(trials(itrial,1):trials(itrial,2),Quatchannel(3));
        Table.(Segments{isegment}).Quat4.rawdata(:,itrial) = data.(Segments{isegment}).data(trials(itrial,1):trials(itrial,2),Quatchannel(4));

    end
end

save('Data.mat','Gyrochannel','Quatchannel','Accelchannel','Timechannel','data','trials','Fz');
save('Table.mat','Table');

