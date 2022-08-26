%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Código de exemplo de como configurar os eixos dos gráficos com 
%%% mesma precisão e vírgula em vez de ponto
%%% Prof. William D'A. Fonseca, Dr. Eng. - will.fonseca@eac.ufsm.br
%%% 
%%% Exemplos de export_fig adicionados
%%% 
%%% Last update: 20/09/2016
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Cleaning service
close all; clear all;

%% Configurações de entrada
% Precisões dos eixos
Plot.Preciy = '% 3.2f'; Plot.Precix = '% 4.3f';

%% Processamento de teste
%% Especificação do sinal
   fs = 8000; dt = 1/fs;       % Amostras por segundo e segundo por amostra
   TempoFinal = 0.25;
   t = (0:dt:TempoFinal-dt)';  % Tempo
%%% Cosseno
   fc = 60;                    % Frequência em Hertz
   dado = cos(2*pi*fc*t);

%% Plot linear SEM correção
linear = figure('Name','Linear original'); 
 plot(t,dado); 
 xlabel('Tempo (segundos)'); ylabel('Amplitude'); title('Sinal no tempo');
 legend('Cosseno','Location','Northeast');  
 xlim([t(1) t(end)]);

 %% Plot linear COM correção
linearCorr = figure('Name','Linear original CORRIGIDO'); 
 plot(t,dado); 
 xlabel('Tempo (segundos)'); ylabel('Amplitude'); title('Sinal no tempo');
 legend('Cosseno','Location','Northeast');  
 xlim([t(1) t(end)]);
 
 
 %% Ajusta plot
%%% Intervalo de dados no eixo y - VIA GET %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ytick.GetNum = (get(linearCorr.CurrentAxes,'YTick'))'; ytick.GetLabel = get(linearCorr.CurrentAxes,'YTickLabel'); 
%%% Troca ponto por vírgula e ajusta precisão %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [ytick.NewLabel,~]=sep_convert(ytick.GetNum,Plot.Preciy,'virgula',0); 
%%% Aplica no gráfico as opções do eixo y %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    set(linearCorr.CurrentAxes,'YTick',ytick.GetNum); set(linearCorr.CurrentAxes,'YTickLabel',ytick.NewLabel);
%%% Intervalo de dados no eixo x %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xtick.GetNum = (get(linearCorr.CurrentAxes,'XTick'))'; xtick.GetLabel = get(linearCorr.CurrentAxes,'XTickLabel'); 
%%% Troca ponto por vírgula e ajusta precisão %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [xtick.NewLabel,~]=sep_convert(xtick.GetNum,Plot.Precix,'virgula',0); 
%%% Aplica no gráfico as opções do eixo x %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(linearCorr.CurrentAxes,'XTick',xtick.GetNum); set(linearCorr.CurrentAxes,'XTickLabel',xtick.NewLabel)
 