close all
clear g
sujets= strcmp(data.Sujet,'S02')|strcmp(data.Sujet,'S03')|strcmp(data.Sujet,'S04')|strcmp(data.Sujet,'S02')|strcmp(data.Sujet,'S06')|...
    strcmp(data.Sujet,'S08')|strcmp(data.Sujet,'S12')|strcmp(data.Sujet,'S13')|strcmp(data.Sujet,'S14');
variable=not(strcmp(data.Variable,'Symétrie Temporelle')|strcmp(data.Variable,'Symmétrie d''accélération'));
% g=gramm('x',data.S_ance,'y',data.Data,'color',data.Sujet,'subset',sujets & variable);
g=gramm('x',data.S_ance,'y',data.Data,'subset',sujets & variable,'group',data.Sujet);
g.geom_line();
g.facet_grid(data.Poussee,data.Variable,'scale','independent')
g.set_line_options('base_size',0.5,'style',{'--'})

g.set_color_options('map',[0 0 0])
g.draw;

g.update('x',data.S_ance,'y',data.Data,'subset',sujets & variable,'group',data.Sujet);
g.geom_point();
g.set_point_options('base_size',8)
%g.facet_grid(data.Poussee,data.Variable,'scale','independent')
g.draw;