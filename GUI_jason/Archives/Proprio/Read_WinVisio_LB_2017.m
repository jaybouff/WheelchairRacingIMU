%Fonction pour lire des fichier provenant de WinVisio

%-------------------------------------------------------------------------%
% Fonction pour lire des fichier provenant de WinVisio
%
% Entrées
%   data: data
%   nb_canaux: nb de canaux acquis
%   Frequence: Frequence d'acquisitions
%   nb_Samples: nb d'echantillons
%   filename: nom du fichier de données bruttes ouvert
%
% Sorties
%   aucune
% Martin Noel
% 31 mars 2009
% revision 16 fevrier 2010
%revision #2 par LB 26 nov 2012
%-------------------------------------------------------------------------%

function Read_WinVisio_LB
% profile on
count=0; %number of files transformed
choice=1;
   while choice==1
    count=count+1;
    %---------------------------------------------------------------------------%
    [filename,pathfile]=uigetfile('*.*','Choisir fichier WinVisio (donnees brutes)');
    [fid,message]=fopen([pathfile,filename],'r','l'); %little-endian byte ordering
    %---------------------------------------------------------------------------%

    h=waitbar(1/7,'Patience...');
    %---------------------------------------------------%
    %On scan le fichier du début à la fin
    %---------------------------------------------------%
    fseek(fid,0,'bof');
    str_doc=fscanf(fid,'%c',inf);
    str_doc;
    Saut_Ligne= strfind(str_doc, 10); %On determine les positions des sauts de lignes

    TAG_RAW_ANALOG_DATA= strfind(str_doc, '[RAW ANALOG DATA]');
    nb_saut=1;
    test_Raw_Data=find(Saut_Ligne>TAG_RAW_ANALOG_DATA);
    depart_RAW_ANALOG_DATA=Saut_Ligne(test_Raw_Data(nb_saut));


    %=====================================================%
    % Lecture dans RAW ANALOG DATA
    %=====================================================%
    waitbar(2/7,h,'Patience...');
    %------------------------------------------------------%
    %On determine le nombre de signaux acquis
    %------------------------------------------------------%
    nb_saut=1;
    depart_nb_canaux=Saut_Ligne(test_Raw_Data(nb_saut));

    fseek(fid,depart_RAW_ANALOG_DATA,'bof');
    str_nb_canaux=fread(fid,50,'char');
    str_nb_canaux=char(str_nb_canaux');

    %On va chercher les caractères qu'il y a apres "=" et " ".
    p_egal_1=find(str_nb_canaux==61); %On determine la position du "="
    p_egal_2=find(str_nb_canaux==13); %On determine la position du saut de ligne
    nb_canaux=str2num(str_nb_canaux([p_egal_1+1: p_egal_2(1)]));

    waitbar(3/7,h,'Patience...');
    %------------------------------------------------------%
    %On determine la fréquence d'échantillonnage
    %------------------------------------------------------%
    nb_saut=2;
    depart_Frequence=Saut_Ligne(test_Raw_Data(nb_saut));

    fseek(fid,depart_Frequence,'bof');
    str_nb_canaux=fread(fid,50,'char');
    str_nb_canaux=char(str_nb_canaux');

    %On va chercher les caractères qu'il y a apres "=" et " ".
    p_egal_1=find(str_nb_canaux==61); %On determine la position du "="
    p_egal_2=find(str_nb_canaux==13); %On determine la position du saut de ligne
    frequence_acquisition=str2num(str_nb_canaux([p_egal_1+1: p_egal_2(1)]));
    waitbar(4/7,h,'Patience...');
    %------------------------------------------------------%
    %On determine le nombre de samples
    %------------------------------------------------------%
    nb_saut=3;
    depart_Samples=Saut_Ligne(test_Raw_Data(nb_saut));

    fseek(fid,depart_Samples,'bof');
    str_nb_canaux=fread(fid,50,'char');
    str_nb_canaux=char(str_nb_canaux');

    waitbar(5/7,h,'Patience...');
    %On va chercher les caractères qu'il y a apres "=" et " ".
    p_egal_1=find(str_nb_canaux==61); %On determine la position du "="
    p_egal_2=find(str_nb_canaux==13); %On determine la position du saut de ligne
    nb_Samples=str2num(str_nb_canaux([p_egal_1+1: p_egal_2(1)]));

    waitbar(6/7,h,'Patience...');
    %-----------------------------------------------------%
    % On va lire les data
    %-----------------------------------------------------%
    %On determine le départ des data
    nb_saut=8;
    depart_DATA=Saut_Ligne(test_Raw_Data(nb_saut));

    fseek(fid,depart_DATA+8,'bof'); %On va à la position de départ des data
    data=fscanf(fid, '%f %*s',[nb_canaux inf]); % (%*s) permet de passer par dessus les virgules, ne lit pas la premiere ligne parce que c'est considéré comme un caractère 

    waitbar(7/7,h,'Patience...');

    % %On génère un vecteur temps
    % fseek(fid,depart_DATA,'bof'); 
    % DataL1=fgetl(fid);
    % SpaceDataL1=strfind(DataL1,' ');
    % Data1=str2num(DataL1(1:SpaceDataL1(1)));
    % TpsInit=Data1;
    % 
    % temps(1)=TpsInit;
    % h=waitbar(0,'Patience garçon');
    % for i=2:size(data,2)
    %     temps(i)=temps(end)+(1/frequence_acquisition);
    %     waitbar(i/size(data,2),h,'Patience garçon')
    % end
    % 
    % data(end+1,:)=temps;



    %----------------%
    % Enregistrer
    %----------------%
    cd(pathfile); %On va dans le repertoire du sujet traité

    % Enregistrement des données
    filename = strrep(filename,'.raw','.mat')
    [outfn,outpn]=uiputfile([filename]);
    save([outpn,outfn],'data','nb_canaux','frequence_acquisition','nb_Samples','filename');
    choice=menu('Process another Winvision file?','yes','no');
    end; %while

    %% combined data

delete('CombinedData.mat')
tout=dir ('*.mat');

choice=menu('Do you want to combine data files?','yes','no');
if choice==1 %combine temp_n files
    for k=1:length(tout)
        filename=(tout(k,1).name);
        load (filename, 'data');
        eval(['data_',num2str(k),'=data;']); 
    end

    data=data_1;
    for i=2:length(tout)
        data=eval(['[data data_',num2str(i),']']); 
    end
    save('CombinedData','data');
end
close(h)
%profile viewer







