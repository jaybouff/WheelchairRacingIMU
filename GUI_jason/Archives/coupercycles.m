function coupercycles
%cette fonction blasbla
%plusieurs ligbes

%ici ca parait plus



%%debut

load('tempdata.mat');

%% couper cycles et creer tables
%choisir un canal de trig 
choice=menu('choose sync channel',name);
ftrigChannel=zdata(choice,:); %HC


%definir le seuil de trigger
figure(2);
plot(ftrigChannel(1:20000));
xlabel('definir le seuil d activation');
ypos=ginput(1);
disp(ypos);
ypos=ypos(2);
disp(ypos);

thepos=[];
%fonction decoupage
steppos=find(ftrigChannel>ypos);
plot(diff(steppos));
xlabel('definir le seuil d activation');
ypos=ginput(1);
disp(ypos);
ypos=ypos(2);
disp(ypos);

thepos=find(diff(steppos)>ypos);
close;
 
% creer tables

for j=1:size(name,2)
    s=['table_',char(name(j)),'=[];'];eval(s);
    table_temp=[];
    
    h = waitbar(0,['Processing ',char(name(j)),'Please wait...']);
    waitbar(j/size(name,2),h);
    for i=1:size(thepos,2)-1
        onset=steppos(thepos(i));
        temp=zdata(j,onset:onset+1500); %HC
        table_temp=[table_temp;temp];
    end;%i
    s=['table_',char(name(j)),'=table_temp;'];eval(s);    
    close(h);
    
end; %j

save('tabledata.mat','table*');
