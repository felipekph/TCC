clear; format long; close all; clc
addpath('..\Matlab_UFSM_Mareze_2')


load dados.mat
%% Para 80% do desvio padrão do conjunto
Confianca1 = 80;
[abs_CI, abs_conf] = stat_conf(data.abs_normal_corr','T',Confianca1,0,1,'nodB','conj'); % t-student
abs_inf=eval('abs_CI.muCI(:,1)'); abs_sup=eval('abs_CI.muCI(:,2)');

f.spanLog = [10^-5; data.freq(2:end)]; f.plot=[50, 1000:1000:5000];
figure(10)
Plot.xlabel = 'Frequência [Hz]'; Plot.ylabel = 'Coef. de Absorção [-]';
Plot.shade1 = shadedErrorBar(f.spanLog, data.abs_normal_corr', {@mean, @(freq) abs(abs_CI.interval)}, {'Color',[0/255 30/255 255/255],'LineWidth', 3.0}, 1, 0.25, 'log', 0); hold on;      
f.spanPoints=round(logspace(log10(50),log10(5000),50));
set(gcf,'units','normalized','outerposition',[0.1 0.1 0.6 0.8]) %% Maximize
set(legend({'IC para 80\% do desv. pad. do conj., dist. T-Student','M\''edia para 80\%'},'Location','Northwest'), 'interpreter', 'latex')
%lgnd_interp2latex(Plot.legendIcons); %%% Corrigir texto da legenda para LaTex
ylim([-0.0 1.1]); xlim([f.plot(1) f.plot(end)]); xlabel(Plot.xlabel); ylabel(Plot.ylabel); grid on; 
set(gcf,'units','points','position',[110,30,805,480])
xt={'50','100','250','500','1k','2k','3k','4k','5k'};
set(gca,'xtick',[50 100 250 500 1000 2000 3000 4000 5000]); 
yt={'0,00','0,10','0,20','0,30','0,40','0,50','0,60','0,70','0,80','0,90','1,00'};
set(gca,'ytick',[0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1]); 
set(gca,'xticklabel',xt,'yticklabel',yt);
set(gca,'fontsize', 12);
%hold on; semilogx(data.freq,data.abs_normal_corr,'LineWidth',1.0)

%% SAVE FIGURE
%save_fig('ABS_TI',1,figure(10),1,1,0,1,600,'log',0,0);


figure(11)
semilogx(data.freq,data.abs_normal_corr,'LineWidth',2.0)
Plot.xlabel = 'Frequência [Hz]'; Plot.ylabel = 'Coef. de Absorção [-]';
f.spanPoints=round(logspace(log10(50),log10(5000),50));
set(gcf,'units','normalized','outerposition',[0.1 0.1 0.6 0.8]) %% Maximize
%set(legend({'IC para 80\% do desv. pad. do conj., dist. T-Student','M\''edia para 80\%'},'Location','Northwest'), 'interpreter', 'latex')
%lgnd_interp2latex(Plot.legendIcons); %%% Corrigir texto da legenda para LaTex
ylim([0 1.1]); xlim([100 f.plot(end)]); xlabel(Plot.xlabel); ylabel(Plot.ylabel); grid on; 
set(gcf,'units','points','position',[110,30,805,480])
xt={'50','100','250','500','1k','2k','3k','4k','5k'};
set(gca,'xtick',[50 100 250 500 1000 2000 3000 4000 5000]); 
yt={'0,00','0,10','0,20','0,30','0,40','0,50','0,60','0,70','0,80','0,90','1,00','1,10'};
set(gca,'ytick',[0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0,1.1]); 
set(gca,'xticklabel',xt,'yticklabel',yt);
set(gca,'fontsize', 12);

%% SAVE FIGURE
%save_fig('ABS_Todos',1,figure(11),1,1,0,1,600,'log',0,0);