% Ce code permet de réaliser la calibration anatomique des capteurs inertiels pour le
% projet de propulsion de FR de course. Il a été développé pour travailler
% avec les structures créées par Raphaël Ouellet et les données fusionnées
% par le logiciel de Gait Up. Le code nécessite le toolbox SPATIAL MATH for MAtlab suivant afin de
% réaliser la transformation Quaternion/Matrices/Angles: https://github.com/petercorke/spatialmath-matlab
clear all
%Design filter
Ordre = 2;
Fc = 4;
Fs = 256;

[b,a] = butter(Ordre,Fc/(Fs/2)); % et on crée le filtre

%Define angles during anatomical pose (roll, pitch, yaw)
load('Calib.mat');
Segments = {'Sternum','dArm','dForearm','dHand'};
Joints = {'Thorax','HumeroThorax','Elbow','Wrist'};

DynamicCalib = {'TrunkFlex','ShoulFlex','ShoulFlex','ShoulFlex'};

%Indiquer sur quel axe devrait se trouver la gravité pour chaque segment !!
%Les angles d'Euler ne peuvent être calculés qu'avec l'ordre ZYZ, alors que
%ISB à l'épaule recommande YXY. Le système de coordonnées sera donc Z= axe
%longitudinal, Y vers l'avant et X vers la droite.
% AngleAnato = [90, 0 ,0;
%     90, 0 ,0;
%     0, 0 ,0;
%     0, 0 ,0;
%     90, 0 ,0];Segments

%  AngleAnato = [0, 0 ,0;
%      0, 0 ,0;
%      90, 0 ,0;
%      0, 0 ,0];%joint

Anato = [1,0,0;
    0,1,0;
    0,0,1];

GravityAxis = [3,3,1,1];
 
 AxisDynamic = [1,1,2,2];
 
 AxisAutre = [2,2,3,3];

%% Define rotation matrix for anatomical pose
for isegment = 1:length(Segments)% For all joints except for the elbow (neutral positition)

measuredGravity = mean(filtfilt(b,a,Calib.Participant.Statique.(Segments{isegment}).Accel));
Ref(1:3,GravityAxis(isegment))  = measuredGravity ./ norm(measuredGravity);

measuredVelocity = std(filtfilt(b,a,Calib.Participant.(DynamicCalib{isegment}).(Segments{isegment}).Gyro));
normVelocity  = measuredVelocity ./ norm(measuredVelocity);
Ref(1:3,AxisAutre(isegment))=cross(Ref(1:3,GravityAxis(isegment)),normVelocity); 
Ref(1:3,AxisDynamic(isegment))=cross(Ref(1:3,AxisAutre(isegment)),Ref(1:3,GravityAxis(isegment))); 


Calib.R.(Segments{isegment}) = Anato * Ref';
Calib.Quat.(Segments{isegment}) = UnitQuaternion(Calib.R.(Segments{isegment}));
% RAnato.(Segments{isegment}) = rpy2r(AngleAnato(isegment,:),'deg','xyz');
% uq= mean(Calib.Participant.Statique.(Segments{isegment}).Quat,1);
% RCalib.(Segments{isegment}) = R(UnitQuaternion(uq));
% Calib.R.(Segments{isegment}) = RCalib.(Segments{isegment})*RAnato.(Segments{isegment})';

% RAnato.(Joints{ijoint}) = rpy2r(AngleAnato(ijoint,:),'deg','xyz');
% 
% if ijoint==1
% uq= mean(Calib.Participant.Statique.(Segments{joint}).Quat,1);
% RCalib.(Joints{ijoint}) = R(UnitQuaternion(uq));
% Calib.R.(Joints{ijoint}) = RCalib.(Joints{ijoint})*RAnato.(Joints{joint})';
% 
% elseif
% end


end



save('Calib.mat','Calib');

load('Table.mat');
%% Build rotated tables for the Frame
for itrial = 1:size(Table.Frame.AccelX.rawdata,2)
    
    for isegment = 1: 1:length(Segments)
    % Apply rotation matrix to Frame data   
    rotAccel = Calib.R.(Segments{isegment}) * [Table.Frame.AccelX.rawdata(:,itrial),Table.Frame.AccelY.rawdata(:,itrial),Table.Frame.AccelZ.rawdata(:,itrial)]';
    rotGyro = Calib.R.(Segments{isegment}) * [Table.Frame.GyroX.rawdata(:,itrial),Table.Frame.GyroY.rawdata(:,itrial),Table.Frame.GyroZ.rawdata(:,itrial)]';
    
    %Integrate into the Table structure
    Table.(Segments{isegment}).AccelX.rotdata(:,itrial) = rotAccel(:,1);
    Table.(Segments{isegment}).AccelY.rotdata(:,itrial) = rotAccel(:,2);
    Table.(Segments{isegment}).AccelZ.rotdata(:,itrial) = rotAccel(:,3);

    Table.(Segments{isegment}).GyroX.rotdata(:,itrial) = rotGyro(:,1);
    Table.(Segments{isegment}).GyroY.rotdata(:,itrial) = rotGyro(:,2);
    Table.(Segments{isegment}).GyroXZ.rotdata(:,itrial) = rotGyro(:,3);
    
    f=@(rowidx)UnitQuaternion([Table.(Segments{isegment}).Quat1.rawdata(rowidx,itrial), ...
        Table.(Segments{isegment}).Quat2.rawdata(rowidx,itrial), ...
        Table.(Segments{isegment}).Quat3.rawdata(rowidx,itrial), ...
        Table.(Segments{isegment}).Quat4.rawdata(rowidx,itrial)]);
   
    
     Table.(Segments{isegment}).Quat.rawdata{itrial} = arrayfun(f,1:size(Table.(Segments{isegment}).Quat1.rawdata(:,itrial),1));
     Table.(Segments{isegment}).Quat.rotdata{itrial} = Calib.Quat.(Segments{isegment})* Table.(Segments{isegment}).Quat.rawdata{itrial} ;
%     uq = arrayfun(f,1:size(Table.(Segments{isegment}).Quat1.rawdata(:,itrial),1));
     
%     rotuq = Calib.Quat.(Segments{isegment}) * uq;
%     rotuq=double(rotuq);
%     
%     
%     
%     Table.(Segments{isegment}).Quat1.rotdata(:,itrial) = rotuq(:,1);
%     Table.(Segments{isegment}).Quat2.rotdata(:,itrial) = rotuq(:,2);
%     Table.(Segments{isegment}).Quat3.rotdata(:,itrial) = rotuq(:,3);
%     Table.(Segments{isegment}).Quat4.rotdata(:,itrial) = rotuq(:,4);

    end

%    trunkuq = [Table.Sternum.Quat1.rotdata(:,itrial), ...
%         Table.Sternum.Quat2.rotdata(:,itrial), ...
%         Table.Sternum.Quat3.rotdata(:,itrial), ...
%         Table.Sternum.Quat4.rotdata(:,itrial)];
%     
%     trunkeul=toeul(UnitQuaternion(trunkuq));
    
end

 save('Table.mat','Table');

for itrial = 1:size(Table.Frame.AccelX.rawdata,2)
%     
 f = @(rowidx)Table.Sternum.Quat.rotdata{itrial}(rowidx)/Table.dArm.Quat.rotdata{itrial}(rowidx);
 Table.Shoulder.Quat{itrial}=arrayfun(f,1:length(Table.Sternum.Quat.rotdata{itrial}));
% 
 end
