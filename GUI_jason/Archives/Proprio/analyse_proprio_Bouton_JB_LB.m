function resultat=analyse_proprio_Bouton_LB



clear all 
load('Table_data.mat');


Direction=menu('Quelle est la direction du champ de force?','Flexion plantaire (r?sistif)','Flexion dorsale (assistif)');

STIM=find(Cycle_Table(:,5)==1);
CTRL=find(Cycle_Table(:,5)==0);
reponse(1:length(STIM))=nan;
CF(1:length(STIM))=nan;
maxdeltaF(1:length(STIM))=nan;
maxF(1:length(STIM))=nan;
erreur_max(1:length(STIM))=nan;
numcycle=size(Cycle_Table,1);

chan_ENCO=find(strcmp(chan_name,'ENCO')==1);
chan_COUPLE=find(strcmp(chan_name,'COUPLE')==1);
chan_CONSF=find(strcmp(chan_name,'CONS_F')==1);
chan_Response=find(strcmp(chan_name,'Response')==1);


for i=1:length(STIM)
    if STIM(i)<length(Cycle_Table(:,3))
    reponse(i)=sum(Cycle_Table(STIM(i):STIM(i)+1,4));
    else
    reponse(i)=nan;
    end
    
    if Cycle_Table(STIM(i),3)==0
        reponse(i)=nan;
    end
end


%% synchronize data on pushoff
figure(1)
clf
s=['plot(Table',num2str(chan_ENCO),'(500:end,:))'];eval(s);
hold on
title('Put the cursor in the middle of the pushoff (y axis)');
[x,syncthreshold]=ginput(1)
syncthreshold=round(syncthreshold(1));


for i=1:size(Cycle_Table,1);
    s=['temp=find(round(Table',num2str(chan_ENCO),'(500:end-1,i))==syncthreshold & diff(Table',num2str(chan_ENCO),'(500:end,i))<0);'];eval(s);
    
    if temp>0
        synctiming(i)=temp(1)+499;
    else
        synctiming(i)=nan;
    end
    
end
  
%Validate synchronisation
    % For baseline1
    
    %Procedure Baseline
    figure(1)
    clf
    
   for i=1:numcycle
        
       if isnan(synctiming(i))==0
        s=['plot(','Table',num2str(chan_ENCO),'(synctiming(i):end,i));'];
        h(i)=eval(s);
        
        hold on;
       else
           h(i)=nan;
       end
        
   end
        set(h(:),'color','b')
        a=axis;
        axis([0 1500 a(3) a(4)])
        
            xlabel('click in the white space when finished');
    
    bad_cycles=[];
    count=0;
    over=0;
    
    while not(over)
        
        waitforbuttonpress;
        hz=gco;
        [bad]=find(h==hz);
        
        if not(isempty(bad))
            set(h(bad),'color','r','linewidth',2);
            ylabel(bad);
            set(h(bad),'color','r','marker','o')
            
            uistack(h(bad),'top')
            
            
            confirmation=menu('Non valide?','oui','non');
            
            switch confirmation
                case confirmation==1
                    
                    delete(h(bad))
                    count=count+1;
                    bad_cycles(count)=bad;
                    
                otherwise
                    
                    set(h(bad),'color','b','linewidth',0.5);
                    
            end %SWITCH
            
        else
            over=1;
        end; %if
    end;
    

    Cycle_Table(bad_cycles,3)=-1;
    
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% end synchronisation on pushoff

%% resultats
j=1;
baselinesync(1:750,1:length(CTRL))=nan;
dureecycle=size(Table1,1);

for i=1:length(CTRL)
    if Cycle_Table(CTRL(i),3)==1
    
    cyclesbaseline(j)=CTRL(i);
    s=['baselineENCOsync(1:dureecycle-synctiming(CTRL(i))+1,j)=Table',num2str(chan_ENCO),'(synctiming(CTRL(i)):end,CTRL(i));'];eval(s);
    s=['baselineCOUPLEsync(1:dureecycle-synctiming(CTRL(i))+1,j)=Table',num2str(chan_COUPLE),'(synctiming(CTRL(i)):end,CTRL(i));'];eval(s);
    j=j+1;
    end
end
    
ref_ENCO=mean(baselineENCOsync,2);
ref_COUPLE=mean(baselineCOUPLEsync,2);




figure(2);

for i=1:length(STIM)
     % ***********ATTENTION MODIFIE PAR LB POUR REMETTRE GONIO A ZERO AU
    % maxCF
    
    
      %definit le max de deviation gonio apres le max de configne en force
 
if Cycle_Table(STIM(i),3)==1
    %plot results
    clf;
    subplot(4,1,2);
    s=['a=Table',num2str(chan_CONSF),'(synctiming(STIM(i)):end,STIM(i));'];eval(s);
    plot(a,'r');
    hold on;
    themaxCF=find(abs(a)>=0.7); %ATTENTION: plus le max, mais le seuil de debut du CF
    CF(i)=a(themaxCF(1));
    zz=axis;
    plot([themaxCF(1) themaxCF(1)],[zz(3) zz(4)],'r:');
    ylabel('Consigne');
    
    ref_ENCO=ref_ENCO-ref_ENCO(themaxCF(1));
    subplot(4,1,1);
    hold on;
    plot(ref_ENCO);
    hold on;
    tempSTIM(1:750)=nan;
    s=['tempSTIM=Table',num2str(chan_ENCO),'(synctiming(STIM(i)):end,STIM(i));'];eval(s);
    tempSTIM=tempSTIM-tempSTIM(themaxCF(1));
    plot(tempSTIM,'r');
    
    if length(tempSTIM)<length(ref_ENCO)
        delta=tempSTIM-ref_ENCO(1:length(tempSTIM));
    else
        delta=tempSTIM(1:length(ref_ENCO))-ref_ENCO;
    end
        
    plot(delta,'g');
    ylabel('Gonio');

    

    
    %retour en arriere et trouve le max de deviation APRES le max de
    %consigne en force
   
    %ICI!!!!!********
%     subplot(4,1,1);
%     x=find(isnan(delta)==0);
%     
%     if Direction==1
%     themax=find(delta(themaxCF+1:x(end))==min(delta(themaxCF+1:x(end)))); %themax=find((delta(themaxCF+1:end))==max(abs(delta(themaxCF+1:end)))); chang? par JB remove abs
%     elseif Direction==2
%     themax=find(delta(themaxCF+1:x(end))==max(delta(themaxCF+1:x(end))));  
%     end
%         
%     themax=themax+themaxCF;
%     zz=axis;
%     plot([themax(1) themax(1)],[zz(3) zz(4)],'r:');
% 
%     erreur_max(i)=delta(themax);
%     xlabel(erreur_max(i));

    
    
    
    subplot(4,1,3);
    s=['a=Table',num2str(chan_COUPLE),'(synctiming(STIM(i)):end,STIM(i));'];eval(s);

    
    plot(ref_COUPLE);
    hold on;
    
    plot(a,'r');
    
    if length(a)<length(ref_COUPLE)
    deltaF=a-ref_COUPLE(1:length(a));
    else
        deltaF=a(1:length(ref_COUPLE))-ref_COUPLE;
        
    end
    
    plot(deltaF,'g');
    ylabel('Force');
    
    if Direction==1
    maxdeltaF(i)=min(deltaF(themaxCF+1:x(end)));
    maxF(i)=min(a(themaxCF+1:x(end)));
    
    elseif Direction==2
        
    maxdeltaF(i)=max(deltaF(themaxCF+1:x(end)));
    maxF(i)=max(a(themaxCF+1:x(end)));
    end
    
    
    subplot(4,1,4);
    s=['a=[Table',num2str(chan_Response),'(1:end,STIM(i)),Table',num2str(chan_Response),'(1:end,STIM(i)+1)];'];eval(s);
    title(num2str(reponse(i)))
    hold on

    plot(a);
    ylabel('reponse');
    
    
   

k=waitforbuttonpress;

end%if;
end %for
resultat(:,1)=CF';
resultat(:,3)=maxdeltaF';
resultat(:,2)=maxF';
resultat(:,4)=erreur_max';
resultat(:,5)=reponse';

%fn=strrep(fn,'.mat','.xls');
xlswrite('AnalProprio',resultat);


%% analyse


% figure(3);
% clf;
% plot(resultats(1,:),resultats(2,:),'o');
% ylabel('dev cheville');
% xlabel('consigne en force');
% 
% figure(4);
% clf;
% plot(resultats(3,:),resultats(2,:),'o');
% ylabel('dev cheville');
% xlabel('force appliquee');
% 
% figure(5);
% clf;
% plot(resultats(1,:),resultats(3,:),'o');
% ylabel('force appliquee');
% xlabel('consigne en force');
% 
% figure(6);
% clf;
% plot(resultats(2,:),resultats(5,:),'o');
% ylabel('EMG change');
% xlabel('dev cheville');
% 
% 
% resultats=resultats';
% xlswrite(fn,resultats);
