clear; format long; close all; clc;
addpath('Matlab_UFSM_Mareze_2');
addpath('processed_data\');

% load dados.mat
load Hf_semMassa.mat
load Hf_comMassa.mat
load Hf_tweeter.mat
%% SEM MASSA
% Para 95% do desvio padrão do conjunto
Confianca1 = 95;
[abs_CI, abs_conf] = stat_conf(Hf_semMassa','T',Confianca1,0,1,'nodB','conj'); % t-student
abs_inf = eval('abs_CI.muCI(:,1)'); abs_sup = eval('abs_CI.muCI(:,2)');

f.spanLog = [10^-5; freq(2:end)]; f.plot=[100:10000:20000];
figure(11)
Plot.xlabel = 'Frequência [Hz]'; Plot.ylabel = 'Impedância [\Omega]';
Plot.shade1 = shadedErrorBar(f.spanLog, Hf_semMassa', {@mean, @(freq) abs(abs_CI.interval)}, {'Color',[0/255 30/255 255/255],'LineWidth', 3.0}, 1, 0.25, 'log', 0); hold on;      
f.spanPoints=round(logspace(log10(50),log10(5000),50));
set(gcf,'units','normalized','outerposition',[0.1 0.1 0.6 0.8]) %% Maximize
set(legend({'IC para 95\% do desv. pad. do conj., dist. T-Student','M\''edia para 95\%'},'Location','Northwest'), 'interpreter', 'latex')
ylim([0 max(abs_CI.meanInput)+1]); xlim([20 20000]); xlabel(Plot.xlabel); ylabel(Plot.ylabel); grid on; 
set(gcf,'units','points','position',[110,30,805,480])
xt={'20', '100', '1000', '10000'};
set(gca,'xtick',[20 100 1000 10000]); 
set(gca,'xticklabel',xt);
set(gca,'fontsize', 12);
title('Curva de Impedância - Woofer Audiophonic KC Club 6.3 (sem adição de massa)')
% print(gcf, '-dpng', '-r300', '..\Figuras\CI_med_wooferClub_semMassa.png')

%% COM MASSA
% Para 95% do desvio padrão do conjunto
Confianca1 = 95;
[abs_CI, abs_conf] = stat_conf(Hf_comMassa','T',Confianca1,0,1,'nodB','conj'); % t-student
abs_inf = eval('abs_CI.muCI(:,1)'); abs_sup = eval('abs_CI.muCI(:,2)');

f.spanLog = [10^-5; freq(2:end)]; f.plot=[100:10000:20000];
figure(12)
Plot.xlabel = 'Frequência [Hz]'; Plot.ylabel = 'Impedância [\Omega]';
Plot.shade1 = shadedErrorBar(f.spanLog, Hf_comMassa', {@mean, @(freq) abs(abs_CI.interval)}, {'Color',[0/255 30/255 255/255],'LineWidth', 3.0}, 1, 0.25, 'log', 0); hold on;      
f.spanPoints=round(logspace(log10(50),log10(5000),50));
set(gcf,'units','normalized','outerposition',[0.1 0.1 0.6 0.8]) %% Maximize
set(legend({'IC para 95\% do desv. pad. do conj., dist. T-Student','M\''edia para 95\%'},'Location','Northwest'), 'interpreter', 'latex')
ylim([0 max(abs_CI.meanInput)+1]); xlim([20 20000]); xlabel(Plot.xlabel); ylabel(Plot.ylabel); grid on; 
set(gcf,'units','points','position',[110,30,805,480])
xt={'20', '100', '1000', '10000'};
set(gca,'xtick',[20 100 1000 10000]); 
set(gca,'xticklabel',xt);
set(gca,'fontsize', 12);
title('Curva de Impedância - Woofer Audiophonic KC Club 6.3 (com adição de massa)')
% print(gcf, '-dpng', '-r300', '..\Figuras\CI_med_wooferClub_comMassa.png')

%% SEM & COM MASSA
% Para 95% do desvio padrão do conjunto
Confianca1 = 95;
[abs_CI, abs_conf] = stat_conf(Hf_semMassa','T',Confianca1,0,1,'nodB','conj'); % t-student
abs_inf = eval('abs_CI.muCI(:,1)'); abs_sup = eval('abs_CI.muCI(:,2)');

[abs_CI1, abs_conf1] = stat_conf(Hf_comMassa','T',Confianca1,0,1,'nodB','conj'); % t-student
abs_inf1 = eval('abs_CI1.muCI(:,1)'); abs_sup1 = eval('abs_CI1.muCI(:,2)');

f.spanLog = [10^-5; freq(2:end)]; f.plot=[100:10000:20000];
figure(11)
Plot.xlabel = 'Frequência [Hz]'; Plot.ylabel = 'Impedância [\Omega]';
Plot.shade1 = shadedErrorBar(f.spanLog, Hf_semMassa', {@mean, @(freq) abs(abs_CI.interval)}, {'Color',[0/255 30/255 255/255],'LineWidth', 3.0}, 1, 0.25, 'log', 0); hold on;      
Plot.shade1 = shadedErrorBar(f.spanLog, Hf_comMassa', {@mean, @(freq) abs(abs_CI1.interval)}, {'Color',[255/255 30/255 0/255],'LineWidth', 3.0}, 1, 0.25, 'log', 0); hold on;      
f.spanPoints=round(logspace(log10(50),log10(5000),50));
set(gcf,'units','normalized','outerposition',[0.1 0.1 0.6 0.8]) %% Maximize
set(legend({'IC para 95\% do desv. pad. do conj., dist. T-Student (sem massa)','M\''edia para 95\% (sem massa)', ...
    'IC para 95\% do desv. pad. do conj., dist. T-Student (com massa)','M\''edia para 95\% (com massa)'},'Location','Northwest'), 'interpreter', 'latex')
ylim([0 max(abs_CI.meanInput)+1]); xlim([20 20000]); xlabel(Plot.xlabel); ylabel(Plot.ylabel); grid on; 
set(gcf,'units','points','position',[110,30,805,480])
xt={'20', '100', '1000', '10000'};
set(gca,'xtick',[20 100 1000 10000]); 
set(gca,'xticklabel',xt);
set(gca,'fontsize', 12);
title('Curva de Impedância - Woofer Audiophonic KC Club 6.3')
text(65, abs_CI.meanInput(651), {'    f_s = 65 Hz'}, 'FontSize', 10.5, 'Color', 'blue')
text(43.5, abs_CI1.meanInput(436), {'f_s = 43,50 Hz   '}, 'FontSize', 10.5, 'Color', 'red', 'HorizontalAlignment', 'right')
% print(gcf, '-dpng', '-r300', '..\Figuras\CI_med_wooferClub_sem&comMassa.png')

%% TWEETER
% Para 95% do desvio padrão do conjunto
Confianca1 = 95;
[abs_CI, abs_conf] = stat_conf(Hf_tweeter','T',Confianca1,0,1,'nodB','conj'); % t-student
abs_inf = eval('abs_CI.muCI(:,1)'); abs_sup = eval('abs_CI.muCI(:,2)');

f.spanLog = [10^-5; freq(2:end)]; f.plot=[100:10000:20000];
figure(13)
Plot.xlabel = 'Frequência [Hz]'; Plot.ylabel = 'Impedância [\Omega]';
Plot.shade1 = shadedErrorBar(f.spanLog, Hf_tweeter', {@mean, @(freq) abs(abs_CI.interval)}, {'Color',[0/255 30/255 255/255],'LineWidth', 3.0}, 1, 0.25, 'log', 0); hold on;      
f.spanPoints=round(logspace(log10(50),log10(5000),50));
set(gcf,'units','normalized','outerposition',[0.1 0.1 0.6 0.8]) %% Maximize
set(legend({'IC para 95\% do desv. pad. do conj., dist. T-Student','M\''edia para 95\%'},'Location','Northwest'), 'interpreter', 'latex')
ylim([0 max(abs_CI.meanInput)+1]); xlim([20 20000]); xlabel(Plot.xlabel); ylabel(Plot.ylabel); grid on; 
set(gcf,'units','points','position',[110,30,805,480])
xt={'20', '100', '1000', '10000'};
set(gca,'xtick',[20 100 1000 10000]); 
set(gca,'xticklabel',xt);
set(gca,'fontsize', 12);
title('Curva de Impedância - Tweeter Audiophonic 1" Seda')
ylim([3 10])
% print(gcf, '-dpng', '-r300', '..\Figuras\CI_med_wooferClub_tweeter.png')

%% SAVE FIGURE
%save_fig('ABS_TI',1,figure(10),1,1,0,1,600,'log',0,0);

% 
% figure(11)
% semilogx(data.freq,data.abs_normal_corr,'LineWidth',2.0)
% Plot.xlabel = 'Frequência [Hz]'; Plot.ylabel = 'Coef. de Absorção [-]';
% f.spanPoints=round(logspace(log10(50),log10(5000),50));
% set(gcf,'units','normalized','outerposition',[0.1 0.1 0.6 0.8]) %% Maximize
% %set(legend({'IC para 80\% do desv. pad. do conj., dist. T-Student','M\''edia para 80\%'},'Location','Northwest'), 'interpreter', 'latex')
% %lgnd_interp2latex(Plot.legendIcons); %%% Corrigir texto da legenda para LaTex
% ylim([0 1.1]); xlim([100 f.plot(end)]); xlabel(Plot.xlabel); ylabel(Plot.ylabel); grid on; 
% set(gcf,'units','points','position',[110,30,805,480])
% xt={'50','100','250','500','1k','2k','3k','4k','5k'};
% set(gca,'xtick',[50 100 250 500 1000 2000 3000 4000 5000]); 
% yt={'0,00','0,10','0,20','0,30','0,40','0,50','0,60','0,70','0,80','0,90','1,00','1,10'};
% set(gca,'ytick',[0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0,1.1]); 
% set(gca,'xticklabel',xt,'yticklabel',yt);
% set(gca,'fontsize', 12);

%% SAVE FIGURE
%save_fig('ABS_Todos',1,figure(11),1,1,0,1,600,'log',0,0);