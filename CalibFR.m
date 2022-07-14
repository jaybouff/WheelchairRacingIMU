clear all

load('Calib.mat');
load('Table.mat');

%% Constant

Anato = [1,0,0;
    0,1,0;
    0,0,1];

%Design filter
Ordre = 2;
Fc1 = 4;
Fs = 256;
Fc2 = [0.2, 4];

[b1,a1] = butter(Ordre,Fc1/(Fs/2)); % et on crée le filtre
[b2,a2] = butter(Ordre,Fc2/(Fs/2)); % et on crée le filtre

%% Bâtir vecteur pour la gravité
Gravity = mean(filtfilt(b1,a1,Calib.fauteuil.Statique.Accel));
Ref(1:3,2) = Gravity ./norm(Gravity);


%% Bâtire vecteur pour le wheelie
ROMFRWheelie=  max(filtfilt(b2,a2,Calib.fauteuil.Wheelie.Gyro))-min(filtfilt(b2,a2,Calib.fauteuil.Wheelie.Gyro)); 

Ref(1:3,1) = cross(Ref(1:3,2),-1*ROMFRWheelie ./norm(ROMFRWheelie));
Ref(1:3,3) = cross(Ref(1:3,1),Ref(1:3,2));


%Define rotation matrix
Calib.Rfauteuil = Anato * Ref';


save('Calib.mat','Calib');

%% Build rotated tables for the Frame
for itrial = 1:size(Table.Frame.AccelX.rawdata,2)
    
    % Apply rotation matrix to Frame data   
    rotAccel = (Calib.Rfauteuil * [Table.Frame.AccelX.rawdata(:,itrial),Table.Frame.AccelY.rawdata(:,itrial),Table.Frame.AccelZ.rawdata(:,itrial)]')';
    rotGyro = (Calib.Rfauteuil * [Table.Frame.GyroX.rawdata(:,itrial),Table.Frame.GyroY.rawdata(:,itrial),Table.Frame.GyroZ.rawdata(:,itrial)]')';
    
    %Integrate into the Table structure
    Table.Frame.AccelX.rotdata(:,itrial) = rotAccel(:,1);
    Table.Frame.AccelY.rotdata(:,itrial) = rotAccel(:,2);
    Table.Frame.AccelZ.rotdata(:,itrial) = rotAccel(:,3);

    Table.Frame.GyroX.rotdata(:,itrial) = rotGyro(:,1);
    Table.Frame.GyroY.rotdata(:,itrial) = rotGyro(:,2);
    Table.Frame.GyroXZ.rotdata(:,itrial) = rotGyro(:,3);

    
    
end

 save('Table.mat','Table');


