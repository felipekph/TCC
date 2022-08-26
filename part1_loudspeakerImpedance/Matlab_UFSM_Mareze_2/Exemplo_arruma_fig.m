%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exemplo de utiliza��o do arruma_fig e save_fig
% 
% Desenvolvido pelo professor da Engenharia Ac�stica 
%                                William D'Andrea Fonseca, Dr. Eng.
%
% �ltima atualiza��o: 12/09/2017
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Cleaning service
close all; clear all;

%% Configura��es de entrada
% Precis�es dos eixos
Preciy = '% 3.2f'; Precix = '% 1.1f';

% Par�metros de fonte do gr�fico e de exporta��o
font='Arial'; fontsize=14; SavePDF = 0; % 0 ou 1

%% Processamento de teste
npts = 0:0.1:4*pi; dado = 2*sin(npts); 

Plot.Nome = 'Sinal do dom�nio do tempo';
Plot.fig = figure('Name',Plot.Nome); 
Plot.plot = plot(npts,dado(1,1:end)); Plot.ax = Plot.fig.CurrentAxes;

grid on; xlim([npts(1) npts(end)]); ylim([-2 +2]);
set(gca,'FontName',font,'FontSize',fontsize,'GridLineStyle','--','LineWidth',0.1);
title (Plot.Nome, 'FontName',font,'FontSize', fontsize);
xlabel ('Tempo (s)', 'FontName',font,'FontSize',fontsize);
ylabel ('Amplitude (V)', 'FontName',font,'FontSize',fontsize);
%% Arruma eixos
arruma_fig(Precix,Preciy);

%% Salvar?
if SavePDF == 1 
    save_fig('Plot_de_teste');
end