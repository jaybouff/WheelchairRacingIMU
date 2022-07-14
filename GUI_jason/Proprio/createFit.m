function [Seuil]= createFit (data,nom)
% trace les sigmoides pour déterminer seuil et zone incertitude
%% lecture

% [filename, pathname] = uigetfile('*.*','Selection du fichier');   
% nom=fullfile(pathname,filename);
% data = xlsread(nom,'Prism');

xData = data(:,1);
yData = data(:,2);

clearvars data;
%% Parameters
ft = fittype( 'a/(a+exp(-b*x))', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Robust = 'off';
opts.StartPoint = [0 1];

%% Fit model 
[fitresult, gof, output] = fit( xData, yData, ft, opts );
val=coeffvalues(cfit(fitresult));
a=val(1);b=val(2);

% Plot fit with data.
figure('name',nom);
h = plot( fitresult, xData, yData );hold on;
legend( h, nom, 'Sigmoide', 'Location', 'NorthEast' );
xlabel (nom)
grid on
savefig (nom)
waitforbuttonpress
close (figure (1))

%% Calcul de la tangente

x=0:0.001:max(xData);
y=a./(a+exp(-b*x));

% d1y = gradient(y,x);                                           
% 
% x_infl = interp1(d1y, x, max(d1y));
% disp (x_infl);
% y_infl = interp1(x, y, x_infl);                                
% pente  = interp1(x, d1y, x_infl);                               
% intcpt = y_infl - pente*x_infl;                                
% tngt = pente*x + intcpt; 

%% Plot
figure (2)
hold on 
plot(xData,yData,'*b')
% plot(x, y)                      
% plot(x, tngt, '-r', 'LineWidth',1)                              
% plot(x_infl, y_infl, '+k','MarkerSize',10)                                      
hold off
grid
% eval(['legend(''y(x)'',''Sigmoide'',''Tangent : ',num2str(pente),'*x + ',num2str(intcpt),''', ''Location'',''E'')'])
axis([0 15 0 1])
waitforbuttonpress
close (figure (2))

Seuil=x(find(y>0.5,1,'first')) %x_infl;
% ZoneIncertitude=1/pente;



