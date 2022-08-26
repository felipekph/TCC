%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rotina para processar dados de resistividade com loop de amostras.
%
% Desenvolvido pelo professor
%    William D'Andrea Fonseca, Dr. Eng.  / prof. Paulo Mareze, Dr. Eng.
%
% Atualização: 17/05/2022
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Cleaning service
clear; clc; close all
addpath('Matlab_UFSM_Mareze_2')  % Pacote Básico de Estatística e plotagem - EAC / UFSM
addpath('..\processed_data\')
%% Load
load('parameters.mat');
Bl = [parameters.Bl];
%% Input
tic
tipo_bancada = '(bancada nova)';
tipo_med =' Medição comum';          % Colocar ' Medição comum' ou 'Infûencia de montagem' ou 'Efeito da intrumentação'
Plot.figs = 1;                      % Faz plots de figuras
Plot.SaveFig = 1;                   % Grava figuras?
 Save.fig = 1; Save.pdf =1; Save.png = 1;
data.Amostra.Confianca = 95; %[80 95]  % Confianças para cálculo
Modelo  = 'N';                      % 'N' para Normal e 'T' para T-Student
normalTest = 1;                     % Faz teste de normalidade (se data.amostras>= 4)?


%%
[D, PD] = allfitdist(Bl,'PDF');
%save_fig('densidade_prob',1,figure(1),1,1,0,1,300,'',0,0)
close all
%%
Analisar = 30;    % Máximo de amostras para avaliar   

%%% Vetores 
data.Amostra.vol = Bl;   %% dados resistividade volumétrica 
data.Amostra.vol = data.Amostra.vol';
num_med = [num2str(Analisar) ' pares'];
%% Incerteza %%% Considerando distribuição normal

%%% Média Resflu Volumetrica
  Res.Amostra.volCImed1 = stat_conf(data.Amostra.vol,Modelo,data.Amostra.Confianca(1),0,1,'nodB','med');
%   Res.Amostra.volCImed2 = stat_conf(data.Amostra.vol,Modelo,data.Amostra.Confianca(2),0,1,'nodB','med');
%%% Conjunto Resflu Volumetrica   
  Res.Amostra.volCIconj1 = stat_conf(data.Amostra.vol,Modelo,data.Amostra.Confianca(1),0,1,'nodB','conj');
%   Res.Amostra.volCIconj2 = stat_conf(data.Amostra.vol,Modelo,data.Amostra.Confianca(2),0,1,'nodB','conj');

%% Teste de normalidade para - resistividade volumétrica 
warning off
 if normalTest == 1 
    %%%% 
    [h.ad, p.ad] = adtest(data.Amostra.vol); 
      if ~h.ad; A.ad = '\bf '; B.ad = ' aka N'; else;  A.ad = ''; B.ad = A.ad; end
    [h.lili, p.lili] = lillietest(data.Amostra.vol);
      if ~h.lili; A.lili = '\bf '; B.lili = ' aka N'; else;  A.lili = ''; B.lili = A.lili; end
    [h.jb, p.jb] = jbtest(data.Amostra.vol);
      if ~h.jb; A.jb = '\bf '; B.jb = ' aka N'; else;  A.jb = ''; B.jb = A.jb; end
    [h.sw, p.sw, ~] = swtest(data.Amostra.vol,0.05,1);
      if ~h.sw; A.sw = '\bf '; B.sw = ' aka N'; else;  A.sw = ''; B.sw = A.sw; end
 end  
warning on
%% Gráficos - resistividade Volumétrica %({'You can do it','with a cell array'})

% Plot dos valores obtidos - Densidade total
PlotD.Nome = ['Bl (Fator de força magnética) ' ' - ' tipo_med ' - ' num_med]; PlotD.fig = figure('Name',PlotD.Nome);    
PlotD.mean = plot(0:length(data.Amostra.vol)+1,mean(data.Amostra.vol)*ones(length(data.Amostra.vol)+2,1),'LineWidth', 2,'Color',colors(5)); hold on;

%%% 95% 
PlotD.CI95up = plot(0:length(data.Amostra.vol)+1,Res.Amostra.volCImed1.muCI(1)*ones(length(data.Amostra.vol)+2,1),'--','LineWidth', 1.5,'Color',colors(2)); hold on;
PlotD.CI95dw = plot(0:length(data.Amostra.vol)+1,Res.Amostra.volCImed1.muCI(2)*ones(length(data.Amostra.vol)+2,1),'--','LineWidth', 1.5,'Color',colors(2));
PlotD.CI95upC = plot(0:length(data.Amostra.vol)+1,Res.Amostra.volCIconj1.muCI(1)*ones(length(data.Amostra.vol)+2,1),':','LineWidth', 1.5,'Color',colors(2)); hold on;
PlotD.CI95dwC = plot(0:length(data.Amostra.vol)+1,Res.Amostra.volCIconj1.muCI(2)*ones(length(data.Amostra.vol)+2,1),':','LineWidth', 1.5,'Color',colors(2));

%% LIMITE DOS PLOTS EM "Y"

minV = 0.5*min([Res.Amostra.volCIconj1.muCI(1) min(data.Amostra.vol)]);
maxV = 1.1*max([Res.Amostra.volCIconj1.muCI(2) max(data.Amostra.vol)]);

% %%%%%%% Barras
PlotD.b = barcolor(data.Amostra.vol,minV:0.1:1.2*maxV,'bone','down'); xlim([0 length(data.Amostra.vol)+1]); hold on; 

%%%%%%%% Plota novamente para fcar por cima
PlotD.mean = plot(0:length(data.Amostra.vol)+1,mean(data.Amostra.vol)*ones(length(data.Amostra.vol)+2,1),'LineWidth', 2,'Color',colors(5)); hold on;

%%% 95% 
PlotD.CI95up = plot(0:length(data.Amostra.vol)+1,Res.Amostra.volCImed1.muCI(1)*ones(length(data.Amostra.vol)+2,1),'--','LineWidth', 1.5,'Color',colors(2)); hold on;
PlotD.CI95dw = plot(0:length(data.Amostra.vol)+1,Res.Amostra.volCImed1.muCI(2)*ones(length(data.Amostra.vol)+2,1),'--','LineWidth', 1.5,'Color',colors(2));
PlotD.CI95upC = plot(0:length(data.Amostra.vol)+1,Res.Amostra.volCIconj1.muCI(1)*ones(length(data.Amostra.vol)+2,1),':','LineWidth', 1.5,'Color',colors(2)); hold on;
PlotD.CI95dwC = plot(0:length(data.Amostra.vol)+1,Res.Amostra.volCIconj1.muCI(2)*ones(length(data.Amostra.vol)+2,1),':','LineWidth', 1.5,'Color',colors(2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  xlabel ('Medições','FontSize',10); ylabel ('Bl [Tm]'); 
   title({['Bl (fator de força magnética)']; ['Amostra ' ' - ' tipo_med ' - ' num_med]}); PlotD.fig.CurrentAxes.XTick = 0:1:length(data.Amostra.vol)+1; xlim([0 length(data.Amostra.vol)+1]); arruma_fig('%1.0f','%2.3f');
    ax = gca;
ax.XAxis.FontSize = 10;
ax.YAxis.FontSize = 10;
ax.YLabel.FontSize = 12;
ax.XLabel.FontSize = 12;
ax.Title.FontSize= 12;

xlabel ('Medições','FontSize',10)
 %  PlotD.fig2.CurrentAxes.Title.String = PlotD.Nome; PlotD.fig2.CurrentAxes.XTick = 0:1:length(data.Amostra.rhot)+1; 
  % PlotD.fig2.CurrentAxes.YLim = [0.7 1.40]; PlotD.fig2.CurrentAxes.XLim = [0 length(data.Amostra.rhot)+1]; arruma_fig('%1.0f','%2.3f'); 
%%% Legenda %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
warning off 
lgn = legend(['M\''edia, $\bar{X}$: ' strrep(num2str(mean(data.Amostra.vol),'%1.3f'), '.', ',') ' [Tm]'], ...
      [num2str(Res.Amostra.volCImed1.confidence) '$\%$-Med., $\bar{X}\,-$'  strrep(num2str(Res.Amostra.volCImed1.z(1,2),'%3.2f'), '.', ',') '$*S\bar{X}$: ' strrep(num2str(Res.Amostra.volCImed1.muCI(1),'%1.3f'), '.', ',') ' [Tm]'], ... 
      [num2str(Res.Amostra.volCImed1.confidence) '$\%$-Med., $\bar{X}\,+$'  strrep(num2str(Res.Amostra.volCImed1.z(1,2),'%3.2f'), '.', ',') '$*S\bar{X}$: ' strrep(num2str(Res.Amostra.volCImed1.muCI(2),'%1.3f'), '.', ',') ' [Tm]'], ...
      [num2str(Res.Amostra.volCIconj1.confidence) '$\%$-Conj, $\bar{X}\,-$' strrep(num2str(Res.Amostra.volCIconj1.z(1,2),'%3.2f'), '.', ',') '$*S{X}$: '    strrep(num2str(Res.Amostra.volCIconj1.muCI(1),'%1.3f'), '.', ',') ' [Tm]'], ...
      [num2str(Res.Amostra.volCIconj1.confidence) '$\%$-Conj, $\bar{X}\,+$' strrep(num2str(Res.Amostra.volCIconj1.z(1,2),'%3.2f'), '.', ',') '$*S{X}$: '    strrep(num2str(Res.Amostra.volCIconj1.muCI(2),'%1.3f'), '.', ',') ' [Tm]']);    
set(lgn,'interpreter','latex','Location','SouthWest');

set(lgn,...
    'Position',[0.153752276867031 0.131935342944517 0.448571844736233 0.225425955258691],...
    'Interpreter','latex');


warning on
 PlotD.fig.Position = [100 100 585 610]; 
 PlotD.fig.Position = [890 62 585 610]; 
pause(5)

%% Anotações: Teste de normalidade e comparações
if normalTest == 1  && (Plot.figs == 1 || Plot.figs == 2)% Create textbox
PlotD.annot = annotation(PlotD.fig,'textbox',...
    [PlotD.fig.CurrentAxes.Legend.Position(1)+PlotD.fig.CurrentAxes.Legend.Position(3)+0.008 PlotD.fig.CurrentAxes.Legend.Position(2) 0.15 0.13],...
    'String',{'\bf Normal test',[A.ad 'ad = ' num2str(h.ad) B.ad],[A.lili 'lili = ' num2str(h.lili) B.lili],[A.jb 'jb = ' num2str(h.jb) B.jb],[A.sw 'sw= ' num2str(h.sw) B.sw]},...
    'Interpreter','latex', 'FontSize',8, 'FitBoxToText','off', 'BackgroundColor',[1 1 1]); pause(1)
end

%% Dados Amb
% PlotD.annot2 = annotation(PlotD.fig,'textbox',...
%     [PlotD.fig.CurrentAxes.Legend.Position(1)+PlotD.fig.CurrentAxes.Legend.Position(3)+0.165 PlotD.fig.CurrentAxes.Legend.Position(2) 0.15 0.10],...
%     'String',{'\bf Amb',['\bf $\bar{T}$ : ' strrep(num2str(mean(Resflu.temp),'%4.2f'), '.', ','),'\bf $^{\circ}$C'],['\bf $\bar{U}$ : ' strrep(num2str(mean(Resflu.umidade),'%4.2f'), '.', ',') '\bf \\\%'],['\bf $\bar{P}_0$ : ' num2str(mean(Resflu.pressao),'%6.0f') '\bf hPa']},...
%     'Interpreter','latex', 'FontSize',8, 'FitBoxToText','off', 'BackgroundColor',[1 1 1]); pause(1)

%% Salva figura
% if Plot.SaveFig == 1 
% %    Save.fig = 1; Save.pdf = 0; Save.png = 0; 
% %    save_fig(PlotT.Nome,1,PlotT.fig,Save.pdf,Save.png,0,Save.fig,300,'',0,0,0,'opengl');
%    save_fig2(PlotD.Nome,1,PlotD.fig,Save.pdf,Save.png,0,Save.fig,300,'',0,0,0,'opengl');
%    pause(5);
% end

%close all


toc
ylim([3 4])
yticks([3, 3.5, 4]); yticklabels({'3,000', '3,500', '4,000'})
print(gcf, '-dpng', '-r600', '..\..\Figuras\Parametros\Bl_variacao.png')

