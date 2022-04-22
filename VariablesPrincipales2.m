close all
clear
clc
%%Constantes
Fz=256; % fréquence d'échantillon
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
%load('Rograssine-2021-10-07-17-07-33-179.mat')
%C4 est l'accélération je crois

%%Identification des variables 
%Ici, pas besoin d'identifier chaque channel Gyro, accel, quat car ils sont
%déja sous forme de table dans les canaux. Par contre, dans chaque canaux
%il y a 5 colonnes, une par essai. Il faut donc identifier chaque essai 
Segments = {'dHTable.rawdata.dHand','Table.rawdata.dForearm','Table.rawdata.dArm','Table.rawdata.Sternum','Table.rawdata.Frame','Table.rawdata.ndHand'};
NombreEssai=size(Table.dHand.AccelX.rawdata,2);
%%Load Data


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

% Filter data [15 Hz) for cumulative integrals; see 
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

%On utilise le minimum du x pour déterminer le début de la poussée, comme
%la fonction min n'existe pas, il faut faire l'inverse du graphique et
%utiliser le findpeaks
Table.Frame.AccelX.frotInvdata0203=(Table.Frame.AccelX.frotdata0203).*-1;




%%PushIdentification en utilisant la méthode de Bergamini SUR les données
%Isolé les maxima sur les fonctions
%Transformer le tout en vecteur
Variable.norme.dHand = sqrt((Table.dHand.AccelX.fdata0203).^2+(Table.dHand.AccelY.fdata0203).^2+(Table.dHand.AccelZ.fdata0203).^2); % accel vectorielle frame
Variable.norme.ndHand = sqrt((Table.ndHand.AccelX.fdata0203).^2+(Table.ndHand.AccelY.fdata0203).^2+(Table.ndHand.AccelZ.fdata0203).^2); % accel vectorielle dHand
Variable.norme.Frame = sqrt((Table.Frame.AccelX.frotdata0203).^2+(Table.Frame.AccelY.frotdata0203).^2+(Table.Frame.AccelZ.frotdata0203).^2); % accel vectorielle ndHand

%%Peaks identification

%Pour le frame
 
[Variable.maximum.pksFInv, Variable.maximum.locsFInv] = arrayfun(@(x) findpeaks(Table.Frame.AccelX.frotInvdata0203(sampleminimal:end,x),'MinPeakDistance',sampleminimal,'MinPeakProminence',MinPeakProminence),...
1:size(Table.Frame.AccelX.frotInvdata0203,2),'UniformOutput',false);

for ipeaksnumber= 1:size(Variable.maximum.locsFInv,2)

Variable.maximum.locsFInv{1, ipeaksnumber}=Variable.maximum.locsFInv{:, ipeaksnumber}+sampleminimal-1;
end

[Variable.maximum.pksF, Variable.maximum.locsF] = arrayfun(@(x) findpeaks(Table.Frame.AccelX.frotdata0203(sampleminimal:end,x),'MinPeakDistance',sampleminimal,'MinPeakProminence',MinPeakProminence),...
1:size(Table.Frame.AccelX.frotdata0203,2),'UniformOutput',false);

for ipeaksnumber= 1:size(Variable.maximum.locsF,2)

Variable.maximum.locsF{1, ipeaksnumber}=Variable.maximum.locsF{:, ipeaksnumber}+sampleminimal-1;
end

%Avec les normes issues des mains

size(Variable.norme.dHand,2);
[Variable.maximum.pksdH, Variable.maximum.locsdH] = arrayfun(@(x) findpeaks(Variable.norme.dHand(:,x),'MinPeakProminence',MinPeakProminenceH),...
    1:size(Variable.norme.dHand,2),'UniformOutput',false);

size(Variable.norme.ndHand,2);
[Variable.maximum.pksndH, Variable.maximum.locsndH] = arrayfun(@(x) findpeaks(Variable.norme.ndHand(:,x),'MinPeakProminence',MinPeakProminenceH),...
    1:size(Variable.norme.ndHand,2),'UniformOutput',false);

PushCyclendH = [Variable.maximum.locsndH; Variable.maximum.pksndH]; % ligne 1 = loc, ligne 2 = peaks
%Le nombre de colonnes équivaut donc au nombre d'essais pour la ligne 1
%(Locs) et la ligne 2 (valeur du peak)

%%Préparation des différentes variables

Everysecondpeakdata_dH(1:NombreDePousseesMax,1:size(PushCyclendH,2))=nan;
Everysecondpeakdata_ndH(1:NombreDePousseesMax,1:size(PushCyclendH,2))=nan;

Variable.StartPropulsion.Frame(1:NombreDePousseesMax,1:size(PushCyclendH,2))=nan;
Variable.StartPropulsion.FrameInv(1:NombreDePousseesMax,1:size(PushCyclendH,2))=nan;

Variable.DureePoussee.dHand(1:NombreDePousseesMax,1:size(PushCyclendH,2))=nan;
Variable.Frequence.dHand(1:NombreDePousseesMax,1:size(PushCyclendH,2))=nan;

Variable.DureePoussee.ndHand(1:NombreDePousseesMax,1:size(PushCyclendH,2))=nan;
Variable.Frequence.ndHand(1:NombreDePousseesMax,1:size(PushCyclendH,2))=nan;

Variable.DureePoussee.FrameInv(1:NombreDePousseesMax,1:size(PushCyclendH,2))=nan;
Variable.Frequence.FrameInv(1:NombreDePousseesMax,1:size(PushCyclendH,2))=nan;

Variable.DureePoussee.Frame(1:NombreDePousseesMax,1:size(PushCyclendH,2))=nan;
Variable.Frequence.Frame(1:NombreDePousseesMax,1:size(PushCyclendH,2))=nan;

Variable.CyclePeak.dHand(1:NombreDePousseesMax,1:size(PushCyclendH,2))=nan;
Variable.CyclePeak.ndHand(1:NombreDePousseesMax,1:size(PushCyclendH,2))=nan;

Variable.Symmetrie.Acc(1:NombreDePousseesMax,1:size(PushCyclendH,2))=nan;
Variable.Symmetrie.Timing(1:NombreDePousseesMax,1:size(PushCyclendH,2))=nan;

%%Trouver les peaks pertinents pour identifier le début des cycles de
%%poussées




for iPushCyclendH = 1:size(PushCyclendH,2)

clf
subplot(4,1,1)
plot(Variable.maximum.locsdH{1, iPushCyclendH}, Variable.maximum.pksdH{1, iPushCyclendH}, 'og')
hold on
plot(Sample,Variable.norme.dHand(:,iPushCyclendH),'g')
grid on
ylabel('Acceleration dHand (g)')
xlabel('Sample')

subplot(4,1,2)
plot(Variable.maximum.locsndH{1, (iPushCyclendH)}, Variable.maximum.pksndH{1, iPushCyclendH}, 'og')
hold on
plot(Sample,Variable.norme.ndHand(:,iPushCyclendH),'g')
grid on
ylabel('Acceleration ndHand (g)')
xlabel('Sample') 

subplot(4,1,3)
plot(Variable.maximum.locsFInv{1, iPushCyclendH}, Variable.maximum.pksFInv{1, iPushCyclendH}, 'og')
hold on
plot(Sample,Table.Frame.AccelX.frotInvdata0203(:,iPushCyclendH),'g')
grid on
ylabel('Acceleration FrameInv (g)')
xlabel('Sample')

subplot(4,1,4)
plot(Variable.maximum.locsF{1, iPushCyclendH}, Variable.maximum.pksF{1, iPushCyclendH}, 'og')
hold on
plot(Sample,Table.Frame.AccelX.frotdata0203(:,iPushCyclendH),'g')
grid on
ylabel('Acceleration Frame (g)')
xlabel('Sample')


%Le ginput sert à déterminer quels valeurs de peaks (ceux au dessus du seuil
%choisis) sont celles qui sont utilisées pour l'identification des poussées
[~,threshold_dH] = ginput(1); %Sélectionner le treshhold
flocsdHand = find(Variable.maximum.pksdH{1, iPushCyclendH}>threshold_dH);%trouve la position des peaks en haut du treshold
%Répéter pour l'autre main
[~,threshold_ndH] = ginput(1); 
flocsndHand = find(Variable.maximum.pksndH{1, iPushCyclendH}>threshold_ndH); 

%Ici, considérant que la longueur de flocsdHand sera le nombre de poussée
%x2, on ajuste le nombre de poussées effectué pour chaque essai
if length(flocsdHand)<2*NombreDePousseesMax||length(flocsndHand)<2*NombreDePousseesMax
    NombreDePoussees=min([floor(length(flocsdHand)/2),floor(length(flocsndHand)/2)]);
else
    NombreDePoussees=NombreDePousseesMax;
end

%Identifier une seule location de peak sur deux considérant que le elbow
%ascending et elbow descending vont générer des accels maximales
Everysecondpeakdata_dH(1:NombreDePoussees,iPushCyclendH) = flocsdHand(2:2:(2*NombreDePoussees),:);
%Retrouver le Sample qui corresponds aux peaks identifiés
Variable.StartPropulsion.dHand(2:NombreDePoussees+1,iPushCyclendH) = Variable.maximum.locsdH{1, iPushCyclendH}(Everysecondpeakdata_dH(1:NombreDePoussees,iPushCyclendH));

%Même principe pour l'autre main
Everysecondpeakdata_ndH(1:NombreDePoussees,iPushCyclendH)= flocsndHand(2:2:(2*NombreDePoussees),:);%Détermine le numéro des peaks 
Variable.StartPropulsion.ndHand(2:NombreDePoussees+1,iPushCyclendH) = Variable.maximum.locsndH{1, iPushCyclendH}(Everysecondpeakdata_ndH(1:NombreDePoussees,iPushCyclendH));

%Même principe pour le frame
Variable.StartPropulsion.FrameInv(2:NombreDePoussees+1,iPushCyclendH) = Variable.maximum.locsFInv{1, iPushCyclendH}(1:NombreDePoussees,1);
Variable.StartPropulsion.Frame(2:NombreDePoussees+1,iPushCyclendH) = Variable.maximum.locsF{1, iPushCyclendH}(1:NombreDePoussees,1);

%Maintenant on trouve les pks maximaux
Variable.CyclePeak.dHand(1:NombreDePoussees,iPushCyclendH) = Variable.maximum.pksdH{1, iPushCyclendH}(Everysecondpeakdata_dH(1:NombreDePoussees,iPushCyclendH));
Variable.CyclePeak.ndHand(1:NombreDePoussees,iPushCyclendH) = Variable.maximum.pksndH{1, iPushCyclendH}(Everysecondpeakdata_ndH(1:NombreDePoussees,iPushCyclendH));
end



%%Données Spatio-temporelles des poussées (Fréquence/durée des poussées)
Variable.DureePoussee.dHand(1:NombreDePoussees,:)= diff(Variable.StartPropulsion.dHand)/Fz; %%Déterminer le début des peaks de la ndHand
Variable.Frequence.dHand(1:NombreDePoussees,:)=Variable.DureePoussee.dHand(1:NombreDePoussees,:).^-1;

Variable.DureePoussee.ndHand(1:NombreDePoussees,:)= diff(Variable.StartPropulsion.ndHand)/Fz; %%Déterminer le début des peaks de la ndHand
Variable.Frequence.ndHand(1:NombreDePoussees,:)=Variable.DureePoussee.ndHand(1:NombreDePoussees,:).^-1;

Variable.DureePoussee.FrameInv(1:NombreDePoussees,:)= diff(Variable.StartPropulsion.FrameInv)/Fz; %%Déterminer le début des peaks de la ndHand
Variable.Frequence.FrameInv(1:NombreDePoussees,:)=Variable.DureePoussee.FrameInv(1:NombreDePoussees,:).^-1;

Variable.DureePoussee.Frame(1:NombreDePoussees,:)= diff(Variable.StartPropulsion.Frame)/Fz; %%Déterminer le début des peaks de la ndHand
Variable.Frequence.Frame(1:NombreDePoussees,:)=Variable.DureePoussee.Frame(1:NombreDePoussees,:).^-1;



%%Symmétrie
%Sym = [(apeaks dominant arm)/ (Apeaks dominant arm + apeak non dimonant arm)]*100
%value ranging between 45% and 55% indicates good symmetry, whereas a value lower than 45% or higher than 55% reflects greater accelerations for the nondominant or dominant hand rim, respectively [30].


%Calcul de symmétrie pour chaque poussée (ligne) et chaque trial
%(colone)
for iTrials = 1:size(Everysecondpeakdata_dH,2)
    iPoussee = 1:size(Variable.CyclePeak.dHand,1);

Variable.Symmetrie.Acc(iPoussee,iTrials) = (Variable.CyclePeak.dHand(iPoussee,iTrials)./(Variable.CyclePeak.ndHand(iPoussee,iTrials)+Variable.CyclePeak.dHand(iPoussee,iTrials)))*100;
end

%%Intégrale cumulative
%Pour atteindre les données de vitesse

Table.CourbedeVitesse=cumtrapz(Table.Frame.AccelX.frotdata03LP*9.8)*(3.6)/(Fz);

Table.CourbedeVitesseInv=(Table.CourbedeVitesse)*-1;


%Ici, le code sert à déterminer les points trouvés sur les courbes
%d'accélération grace à la fonction findpeaks et à les projeter sur la
%courbe de vitesse


%%Refaire ce qui a été fait mais sur les courbes de vitesse voir ce que
%%cela donne

%Trouver les peaks
[Variable.maximum.pksVitesse, Variable.maximum.locsVitesse] = arrayfun(@(x) findpeaks(Table.CourbedeVitesse(sampleminimal:end,x),'MinPeakDistance',sampleminimal),...
1:size(Table.CourbedeVitesse,2),'UniformOutput',false);

for ipeaksnumber= 1:size(Variable.maximum.locsVitesse,2)

Variable.maximum.locsVitesse{1, ipeaksnumber}=Variable.maximum.locsVitesse{:, ipeaksnumber}+sampleminimal-1;
end

[Variable.maximum.pksVitesseInv, Variable.maximum.locsVitesseInv] = arrayfun(@(x) findpeaks(Table.CourbedeVitesseInv(sampleminimal:end,x),'MinPeakDistance',sampleminimal),...
1:size(Table.CourbedeVitesseInv,2),'UniformOutput',false);

for ipeaksnumber= 1:size(Variable.maximum.locsVitesseInv,2)

Variable.maximum.locsVitesseInv{1, ipeaksnumber}=Variable.maximum.locsVitesseInv{:, ipeaksnumber}+sampleminimal-1;
end

%Graphique


close all

PushCycleVitesse = [Variable.maximum.locsVitesse; Variable.maximum.pksVitesse]; % ligne 1 = loc, ligne 2 = peaks


for iPushCycleVitesse = 1:1:size(PushCycleVitesse,2)

   txt=['Vitesse essai ',num2str(iPushCycleVitesse)];

subplot(size(PushCycleVitesse,2),1,iPushCycleVitesse)
plot(Variable.maximum.locsVitesse{1, iPushCycleVitesse}, Variable.maximum.pksVitesse{1, iPushCycleVitesse}, 'og')
hold on
plot(Variable.maximum.locsVitesseInv{1, iPushCycleVitesse}, -1*Variable.maximum.pksVitesseInv{1, iPushCycleVitesse}, 'og')
hold on
plot(Sample,Table.CourbedeVitesse(:,iPushCycleVitesse),'g')
grid on
ylabel(txt)
xlabel('Sample')

end

%Variables spatio-temporelles

for iPushCycleVitesse = 1:size(PushCycleVitesse,2)
Variable.StartPropulsion.CourbedeVitesse(2:NombreDePoussees+1,iPushCycleVitesse) = Variable.maximum.locsVitesse{1, iPushCycleVitesse}(1:NombreDePoussees,1);
Variable.StartPropulsion.CourbedeVitesseInv(2:NombreDePoussees+1,iPushCycleVitesse) = Variable.maximum.locsVitesseInv{1, iPushCycleVitesse}(1:NombreDePoussees,1);
end




MaximumCourbeDeVitesse=Table.CourbedeVitesse(round(Variable.StartPropulsion.Frame(2:end,:)));
MinimumCourbeDeVitesse=Table.CourbedeVitesse(round(Variable.StartPropulsion.FrameInv(2:end,:)));

close all
plot(Variable.StartPropulsion.Frame(2:end,1), MaximumCourbeDeVitesse(:,1), 'or')
hold on
plot(Variable.StartPropulsion.FrameInv(2:end,1),MinimumCourbeDeVitesse(:,1), 'ob')
hold on
plot(Table.CourbedeVitesse(:,1),'g')
grid on
ylabel('Acceleration Frame (g)')
xlabel('Sample')



% Variable.DureePoussee.CourbedeVitesse(1:NombreDePoussees,:)= diff(Variable.StartPropulsion.CourbedeVitesse)/Fz; %%Déterminer le début des peaks de la ndHand
% Variable.Frequence.CourbedeVitesse(1:NombreDePoussees,:)=Variable.DureePoussee.CourbedeVitesse(1:NombreDePoussees,:).^-1;

Variable.DureePoussee.CourbedeVitesseInv(1:NombreDePoussees,:)= diff(Variable.StartPropulsion.CourbedeVitesseInv)/Fz;
Variable.Frequence.CourbedeVitesseInv(1:NombreDePoussees,:)=Variable.DureePoussee.CourbedeVitesseInv(1:NombreDePoussees,:).^-1;

%%Gain par poussée

%Commencer en rajoutant une ligne de 0 sur la colonne inversée pour avoir
%le vraie gain de la première poussée
%Puis, faire Pks de la courbe de vitesse (maximum de vitesse) - peaks
%courbe de vitesse inversée (minimum vitesse) en guise de N+1 - N en terme
%de lignes

Aveclezero(1:NombreDePousseesMax+1,1:size(PushCyclendH,2))=nan;
Variable.GainParPousee(1:NombreDePousseesMax,1:size(PushCyclendH,2))=nan;


for iPushCycleVitesse = 1:NombreEssai

Aveclezero(2:NombreDePoussees+1,iPushCycleVitesse)=Variable.maximum.pksVitesseInv{1, iPushCycleVitesse}(1:NombreDePoussees,:)*-1;
Variable.GainParPousee(1:NombreDePoussees,iPushCycleVitesse)=Variable.maximum.pksVitesse{1, iPushCycleVitesse}(1:NombreDePoussees,:) - (Aveclezero(1:NombreDePoussees,iPushCycleVitesse)); 
end

save('Analyses.mat','Table','Variable');