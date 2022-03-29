clear all

%% Load data
load('Data.mat')

%% Constantes
%Temps non pertinent au début 
Begin = 120 * Fz;
End = trials(1,1);

Segments = {'dHand','dForearm','dArm','Sternum','Frame','ndHand'};

%% Cibler le début de la procédure de calibration

close all
subplot(2,1,1)
plot(Begin:End,data.Frame.data(Begin:End,Accelchannel))
title('Frame Accel')

subplot(2,1,2)
plot(Begin:End,data.Frame.data(Begin:End,Gyrochannel))
title('Frame Gyro')

menu('cible le début de la calibration du fauteuil (avant arrière)','ok')
[debutcalib,~]=ginput(1);
debutcalib=round(debutcalib);

%% Cibler la fin de la procédure de calibration
close all

subplot(4,1,1)
plot(Begin:End,data.dHand.data(Begin:End,Gyrochannel))
title('dHand Gyro')

subplot(4,1,2)
plot(Begin:End,data.dForearm.data(Begin:End,Gyrochannel))
title('dForearm Gyro')

subplot(4,1,3)
plot(Begin:End,data.dArm.data(Begin:End,Gyrochannel))
title('dArm Gyro')

subplot(4,1,4)
plot(Begin:End,data.Sternum.data(Begin:End,Gyrochannel))
title('Sternum Gyro')

menu('cible la fin de la calibration dynamique du participant (rotation tronc)','ok')
[fincalib,~]=ginput(1);
fincalib=round(fincalib);
%% Cibler début et fin de chaque étape du processus de calibration
close all
%% Fauteuil roulant
subplot(2,1,1)
plot(debutcalib:fincalib,data.Frame.data(debutcalib:fincalib,Accelchannel))
title('Frame Accel')

subplot(2,1,2)
plot(debutcalib:fincalib,data.Frame.data(debutcalib:fincalib,Gyrochannel))
title('Frame Gyro')

%avant-arrière
menu('identifier le début et la fin de la calibration avant-arrière du fauteuil','ok');
[fauteuilAvAr,~] = ginput(2);
fauteuilAvAr=round(fauteuilAvAr);

Calib.fauteuil.AvantArriere.Gyro =data.Frame.data(fauteuilAvAr(1):fauteuilAvAr(2),Gyrochannel); 
Calib.fauteuil.AvantArriere.Accel =data.Frame.data(fauteuilAvAr(1):fauteuilAvAr(2),Accelchannel); 

%statique
menu('identifier le début et la fin de la calibration statique du fauteuil','ok');
[fauteuilStat,~] = ginput(2);
fauteuilStat=round(fauteuilStat);

Calib.fauteuil.Statique.Gyro =data.Frame.data(fauteuilStat(1):fauteuilStat(2),Gyrochannel); 
Calib.fauteuil.Statique.Accel =data.Frame.data(fauteuilStat(1):fauteuilStat(2),Accelchannel); 

%wheelie
menu('identifier le début et la fin de la calibration Wheelie du fauteuil','ok');
[fauteuilWheelie,~] = ginput(2);
fauteuilWheelie=round(fauteuilWheelie);

Calib.fauteuil.Wheelie.Gyro =data.Frame.data(fauteuilWheelie(1):fauteuilWheelie(2),Gyrochannel); 
Calib.fauteuil.Wheelie.Accel =data.Frame.data(fauteuilWheelie(1):fauteuilWheelie(2),Accelchannel); 


%% Participant
close all

subplot(4,1,1)
yyaxis left
plot(debutcalib:fincalib,data.dHand.data(debutcalib:fincalib,Accelchannel),'b')
hold on
yyaxis right
plot(debutcalib:fincalib,data.dHand.data(debutcalib:fincalib,Gyrochannel),'r')

title('dHand Accel en bleu et Gyro en rouge')

subplot(4,1,2)
yyaxis left
plot(debutcalib:fincalib,data.dForearm.data(debutcalib:fincalib,Accelchannel),'b')
hold on
yyaxis right
plot(debutcalib:fincalib,data.dForearm.data(debutcalib:fincalib,Gyrochannel),'r')
title('dForearm Accel en bleu et Gyro en rouge')

subplot(4,1,3)
yyaxis left
plot(debutcalib:fincalib,data.dArm.data(debutcalib:fincalib,Accelchannel),'b')
hold on
yyaxis right
plot(debutcalib:fincalib,data.dArm.data(debutcalib:fincalib,Gyrochannel),'r')
title('dArm Accel en bleu et Gyro en rouge')

subplot(4,1,4)
yyaxis left
plot(debutcalib:fincalib,data.Sternum.data(debutcalib:fincalib,Accelchannel),'b')
hold on
yyaxis right
plot(debutcalib:fincalib,data.Sternum.data(debutcalib:fincalib,Gyrochannel),'r')
title('Sternum Accel en bleu et Gyro en rouge')

%% Statique
menu('identifier le début et la fin de la calibration statique du participant','ok');
[ParticipantStat,~] = ginput(2);
ParticipantStat=round(ParticipantStat);

for isegment = 1:length(Segments)
    
    Calib.participant.Statique.(Segments{isegment}).Gyro =data.Frame.data(ParticipantStat,Gyrochannel);
    Calib.participant.Statique.(Segments{isegment}).Accel =data.Frame.data(ParticipantStat,Accelchannel);
    Calib.participant.Statique.(Segments{isegment}).Quat =data.Frame.data(ParticipantStat,Quatchannel);

end

%% Calib dynamique
close all

subplot(4,1,1)
yyaxis left
plot(ParticipantStat(2):fincalib,data.dHand.data(ParticipantStat(2):fincalib,Accelchannel),'b')
hold on
yyaxis right
plot(ParticipantStat(2):fincalib,data.dHand.data(ParticipantStat(2):fincalib,Gyrochannel),'r')

title('dHand Accel en bleu et Gyro en rouge')

subplot(4,1,2)
yyaxis left
plot(ParticipantStat(2):fincalib,data.dForearm.data(ParticipantStat(2):fincalib,Accelchannel),'b')
hold on
yyaxis right
plot(ParticipantStat(2):fincalib,data.dForearm.data(ParticipantStat(2):fincalib,Gyrochannel),'r')
title('dForearm Accel en bleu et Gyro en rouge')

subplot(4,1,3)
yyaxis left
plot(ParticipantStat(2):fincalib,data.dArm.data(ParticipantStat(2):fincalib,Accelchannel),'b')
hold on
yyaxis right
plot(ParticipantStat(2):fincalib,data.dArm.data(ParticipantStat(2):fincalib,Gyrochannel),'r')
title('dArm Accel en bleu et Gyro en rouge')

subplot(4,1,4)
yyaxis left
plot(ParticipantStat(2):fincalib,data.Sternum.data(ParticipantStat(2):fincalib,Accelchannel),'b')
hold on
yyaxis right
plot(ParticipantStat(2):fincalib,data.Sternum.data(ParticipantStat(2):fincalib,Gyrochannel),'r')
title('Sternum Accel en bleu et Gyro en rouge')
mesAxes = axis;


% Poignet / avant-bras
% Pronation supination
menu('identifier le début et la fin de la calibration dynamique pronation et supination','ok');
[ProSup,~] = ginput(2);
ProSup=round(ProSup);
plot([ProSup(1) ProSup(1)],[mesAxes(3) mesAxes(4)],'k','linewidth',2) 
plot([ProSup(2) ProSup(2)],[mesAxes(3) mesAxes(4)],'k','linewidth',2) 


% Déviation
menu('identifier le début et la fin de la calibration dynamique déviation ulnaire et radiale poignet','ok');
[PoignetDev,~] = ginput(2);
PoignetDev=round(PoignetDev);
plot([PoignetDev(1) PoignetDev(1)],[mesAxes(3) mesAxes(4)],'k','linewidth',2) 
plot([PoignetDev(2) PoignetDev(2)],[mesAxes(3) mesAxes(4)],'k','linewidth',2) 

% Coude
% Flexion-Extension
menu('identifier le début et la fin de la calibration dynamique flexion-extemsion coude','ok');
[CoudeFlex,~] = ginput(2);
CoudeFlex=round(CoudeFlex);
plot([CoudeFlex(1) CoudeFlex(1)],[mesAxes(3) mesAxes(4)],'k','linewidth',2) 
plot([CoudeFlex(2) CoudeFlex(2)],[mesAxes(3) mesAxes(4)],'k','linewidth',2) 

% Épaule
% Flexion-Extension
menu('identifier le début et la fin de la calibration dynamique flexion-extemsion épaule','ok');
[ShoulFlex,~] = ginput(2);
ShoulFlex=round(ShoulFlex);
plot([ShoulFlex(1) ShoulFlex(1)],[mesAxes(3) mesAxes(4)],'k','linewidth',2) 
plot([ShoulFlex(2) ShoulFlex(2)],[mesAxes(3) mesAxes(4)],'k','linewidth',2) 

% Abduction-Adduction
menu('identifier le début et la fin de la calibration dynamique Abd-Add épaule','ok');
[ShoulAbd,~] = ginput(2);
ShoulAbd=round(ShoulAbd);
plot([ShoulAbd(1) ShoulAbd(1)],[mesAxes(3) mesAxes(4)],'k','linewidth',2) 
plot([ShoulAbd(2) ShoulAbd(2)],[mesAxes(3) mesAxes(4)],'k','linewidth',2) 

% Rotation interne-externe
menu('identifier le début et la fin de la calibration dynamique rotation interne et externe épaule','ok');
[ShoulRot,~] = ginput(2);
ShoulRot=round(ShoulRot);
plot([ShoulRot(1) ShoulRot(1)],[mesAxes(3) mesAxes(4)],'k','linewidth',2) 
plot([ShoulRot(2) ShoulRot(2)],[mesAxes(3) mesAxes(4)],'k','linewidth',2) 

% Tronc
% Flexion-Extension
menu('identifier le début et la fin de la calibration dynamique flexion-extemsion Tronc','ok');
[TrunkFlex,~] = ginput(2);
TrunkFlex=round(TrunkFlex);
plot([TrunkFlex(1) TrunkFlex(1)],[mesAxes(3) mesAxes(4)],'k','linewidth',2) 
plot([TrunkFlex(2) TrunkFlex(2)],[mesAxes(3) mesAxes(4)],'k','linewidth',2) 

% Abduction-Adduction
menu('identifier le début et la fin de la calibration dynamique Abd-Add épaule','ok');
[TrunkLat,~] = ginput(2);
TrunkLat=round(TrunkLat);
plot([TrunkLat(1) TrunkLat(1)],[mesAxes(3) mesAxes(4)],'k','linewidth',2) 
plot([TrunkLat(2) TrunkLat(2)],[mesAxes(3) mesAxes(4)],'k','linewidth',2) 

% Rotation interne-externe
menu('identifier le début et la fin de la calibration dynamique rotation interne et externe épaule','ok');
[TrunkRot,~] = ginput(2);
TrunkRot=round(TrunkRot);
plot([TrunkRot(1) TrunkRot(1)],[mesAxes(3) mesAxes(4)],'k','linewidth',2) 
plot([TrunkRot(2) TrunkRot(2)],[mesAxes(3) mesAxes(4)],'k','linewidth',2) 

%% Créer les tables de calibration
for isegment = 1:length(Segments)

Calib.Participant.ProSup.(Segments{isegment}).Gyro =data.(Segments{isegment}).data(ProSup(1):ProSup(2),Gyrochannel); 
Calib.Participant.ProSup.(Segments{isegment}).Accel =data.(Segments{isegment}).data(ProSup(1):ProSup(2),Accelchannel); 
Calib.Participant.ProSup.(Segments{isegment}).Quat =data.(Segments{isegment}).data(ProSup(1):ProSup(2),Quatchannel); 

Calib.Participant.PoignetDev.(Segments{isegment}).Gyro =data.(Segments{isegment}).data(PoignetDev(1):PoignetDev(2),Gyrochannel); 
Calib.Participant.PoignetDev.(Segments{isegment}).Accel =data.(Segments{isegment}).data(PoignetDev(1):PoignetDev(2),Accelchannel); 
Calib.Participant.PoignetDev.(Segments{isegment}).Quat =data.(Segments{isegment}).data(PoignetDev(1):PoignetDev(2),Quatchannel); 

Calib.Participant.CoudeFlex.(Segments{isegment}).Gyro =data.(Segments{isegment}).data(CoudeFlex(1):CoudeFlex(2),Gyrochannel); 
Calib.Participant.CoudeFlex.(Segments{isegment}).Accel =data.(Segments{isegment}).data(CoudeFlex(1):CoudeFlex(2),Accelchannel); 
Calib.Participant.CoudeFlex.(Segments{isegment}).Quat =data.(Segments{isegment}).data(CoudeFlex(1):CoudeFlex(2),Quatchannel); 

Calib.Participant.ShoulFlex.(Segments{isegment}).Gyro =data.(Segments{isegment}).data(ShoulFlex(1):ShoulFlex(2),Gyrochannel); 
Calib.Participant.ShoulFlex.(Segments{isegment}).Accel =data.(Segments{isegment}).data(ShoulFlex(1):ShoulFlex(2),Accelchannel); 
Calib.Participant.ShoulFlex.(Segments{isegment}).Quat =data.(Segments{isegment}).data(ShoulFlex(1):ShoulFlex(2),Quatchannel); 

Calib.Participant.ShoulAbd.(Segments{isegment}).Gyro =data.(Segments{isegment}).data(ShoulAbd(1):ShoulAbd(2),Gyrochannel); 
Calib.Participant.ShoulAbd.(Segments{isegment}).Accel =data.(Segments{isegment}).data(ShoulAbd(1):ShoulAbd(2),Accelchannel); 
Calib.Participant.ShoulAbd.(Segments{isegment}).Quat =data.(Segments{isegment}).data(ShoulAbd(1):ShoulAbd(2),Quatchannel); 

Calib.Participant.ShoulRot.(Segments{isegment}).Gyro =data.(Segments{isegment}).data(ShoulRot(1):ShoulRot(2),Gyrochannel); 
Calib.Participant.ShoulRot.(Segments{isegment}).Accel =data.(Segments{isegment}).data(ShoulRot(1):ShoulRot(2),Accelchannel); 
Calib.Participant.ShoulRot.(Segments{isegment}).Quat =data.(Segments{isegment}).data(ShoulRot(1):ShoulRot(2),Quatchannel); 

Calib.Participant.TrunkFlex.(Segments{isegment}).Gyro =data.(Segments{isegment}).data(TrunkFlex(1):TrunkFlex(2),Gyrochannel); 
Calib.Participant.TrunkFlex.(Segments{isegment}).Accel =data.(Segments{isegment}).data(TrunkFlex(1):TrunkFlex(2),Accelchannel); 
Calib.Participant.TrunkFlex.(Segments{isegment}).Quat =data.(Segments{isegment}).data(TrunkFlex(1):TrunkFlex(2),Quatchannel); 

Calib.Participant.TrunkLat.(Segments{isegment}).Gyro =data.(Segments{isegment}).data(TrunkLat(1):TrunkLat(2),Gyrochannel); 
Calib.Participant.TrunkLat.(Segments{isegment}).Accel =data.(Segments{isegment}).data(TrunkLat(1):TrunkLat(2),Accelchannel); 
Calib.Participant.TrunkLat.(Segments{isegment}).Quat =data.(Segments{isegment}).data(TrunkLat(1):TrunkLat(2),Quatchannel); 

Calib.Participant.TrunkRot.(Segments{isegment}).Gyro =data.(Segments{isegment}).data(TrunkRot(1):TrunkRot(2),Gyrochannel); 
Calib.Participant.TrunkRot.(Segments{isegment}).Accel =data.(Segments{isegment}).data(TrunkRot(1):TrunkRot(2),Accelchannel); 
Calib.Participant.TrunkRot.(Segments{isegment}).Quat =data.(Segments{isegment}).data(TrunkRot(1):TrunkRot(2),Quatchannel); 

end

save('Calib.mat','Calib');