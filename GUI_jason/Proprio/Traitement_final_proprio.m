%Traitement final proprio
clear
load('ProprioAnalValidated.mat', 'resultat');

%% Traitement dCouple

% Tri par ordre croissant
Tabletemp_dCouple=sortrows (resultat, -3);
Tabletemp_dCouple=abs(Tabletemp_dCouple);

% supprime les lignes nan
n=size(Tabletemp_dCouple(isnan(Tabletemp_dCouple)),2);
Tabletemp_dCouple=Tabletemp_dCouple(n+1:end,:);

% moyenne glissante sur 3
for i=1:(size(Tabletemp_dCouple,1)-3);
    dCouple(i,1)=mean(Tabletemp_dCouple(i:i+3,3));
    dCouple(i,2)=round(mean(Tabletemp_dCouple(i:i+3,6)));
end

% figure (1)
% plot (dCouple(:,1), dCouple(:,2),'.','MarkerSize',20)
% title('dCouple')
% waitforbuttonpress
% close (figure (1))

%% Traitement dENCO

% Tri par ordre croissant
Tabletemp_dENCO=sortrows (resultat, -5);
Tabletemp_dENCO=abs(Tabletemp_dENCO);

% supprime les lignes nan
n=size(Tabletemp_dENCO(isnan(Tabletemp_dENCO)),2);
Tabletemp_dENCO=Tabletemp_dENCO(n+1:end,:);

% moyenne glissante sur 3
for i=1:(size(Tabletemp_dENCO,1)-3);
    dENCO(i,1)=mean(Tabletemp_dENCO(i:i+3,3));
    dENCO(i,2)=round(mean(Tabletemp_dENCO(i:i+3,6)));
end

% figure (2)
% plot (dENCO(:,1), dENCO(:,2),'.','MarkerSize',20)
% title('dENCO')
% waitforbuttonpress
% close (figure (2))


%% Sigmoïdes
nom='dCouple';
[Seuil_dCouple, pente_dCouple,ZoneIncertitude_dCouple]=createFit(dCouple,nom);
nom='dENCO';
[Seuil_dENCO, pente_dENCO,ZoneIncertitude_dENCO]=createFit(dENCO,nom);


%% Exportation
save ('FinalData','dCouple', 'dENCO','Seuil_dCouple', 'pente_dCouple', 'ZoneIncertitude_dCouple','Seuil_dENCO', 'pente_dENCO','ZoneIncertitude_dENCO');


