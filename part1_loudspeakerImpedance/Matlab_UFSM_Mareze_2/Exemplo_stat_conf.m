%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exemplo de utilização da função stat_conf
% 
% Desenvolvido pelo professor da Engenharia Acústica 
%                                William D'Andrea Fonseca, Dr. Eng.
%
% Última atualização: 13/11/2017
%
% Necessários: funções 'shadedErrorBar' e 'lgnd_interp2latex'.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Cleaning service
close all; clear all; clc

%% Carrega dados para teste ou gera aleatório
%%% Gera aleatório
% y = awgn(sigmf(0:6400,[0.0017 3000]),50); Amostra.AlphaData = repmat(sigmf(0:6400,[0.0017 3000]),30,1);
% Amostra.AlphaData(1:4,:) = [y./21; y./11; y./77; y./99];

%%% Carrega     
%pathtoload = 'E:\GDRIVE\EAC-Projeto-Embraer\Resultados\Tubo de Impedancia - Velho\Medicoes Extras (estatistica)\e_medicao_comum_extras-tubo_velho-new.mat';
pathtoload ='E:\GDRIVE\EAC-Projeto-Embraer\Medições\Tubo de impedância novo\PontoMat_Medições extras\B_medicao_comum-tubo_novo_extra-new.mat';
load(pathtoload); close all;
%% Calcula intervalo de confiança %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Para 80% do desvio padrão da media do conjunto
% Confianca1 = 80;
% Amostra.AlphaCI1 = stat_conf(Amostra.AlphaData,'N',Confianca1,0,1,'nodB','med');
%% Para 80% do desvio padrão do conjunto
Confianca1 = 80;
Amostra.AlphaCI80 = stat_conf(Amostra.AlphaData,'N',Confianca1,0,1,'nodB','conj');

%% Para 95% do desvio padrão do conjunto
Confianca2 = 95;
Amostra.AlphaCI95 = stat_conf(Amostra.AlphaData,'N',Confianca2,0,1,'nodB','conj');
%% Plot
f.spanLog = [10^-5 1:6400]; f.plot=[100, 1000:1000:5000, 6400];
 Plot.xlabel = 'Frequência [Hz]'; Plot.ylabel = 'Coef. de Absorção [-]';
 
 %%% Plot de média + IC para 80% do desvio padrao da média
 Plot.shade2 = shadedErrorBar(f.spanLog, Amostra.AlphaData, {@mean, @(freq) abs(Amostra.AlphaCI95.interval)}, {'Color',[255/255 0/255 102/255],'LineWidth', 2.0}, 1, 0.35, 'log', 0); hold on;       
 Plot.shade1 = shadedErrorBar(f.spanLog, Amostra.AlphaData, {@mean, @(freq) abs(Amostra.AlphaCI80.interval)}, {'Color',[0/255 30/255 255/255],'LineWidth', 2.0}, 1, 0.35, 'log', 0); hold on;      
 
 set(gcf,'units','normalized','outerposition',[0 0 1 1]) %% Maximize
 [Plot.legend, Plot.legendIcons] = legend({'IC para 95\% do desv. pad. do conjunto, dist. Normal','M\''edia para 95\%','IC para 80\% do desv. pad. do conjunto, dist. Normal','M\''edia para 80\%'},'Location','Northwest');
 Plot.PatchInLegend = findobj(Plot.legendIcons, 'type', 'patch'); set(Plot.PatchInLegend, 'FaceAlpha', 0.40);
 lgnd_interp2latex(Plot.legendIcons); %%% Corrigir texto da legenda para LaTex
 ylim([0 1.0]); xlim([f.plot(1) f.plot(end)]); xlabel(Plot.xlabel); ylabel(Plot.ylabel); grid on; 
 set(gcf,'units','points','position',[110,30,805,480])
 xt={'100','500','1000','2000','3000','4000','5,0 k','6,4 k'};
 set(gca,'xtick',[100 500 1000 2000 3000 4000 5000 6400]); 
 yt={'0,00','0,10','0,20','0,30','0,40','0,50','0,60','0,70','0,80','0,90','1,00'};
 set(gca,'ytick',[0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1]); 
 set(gca,'xticklabel',xt,'yticklabel',yt);
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%