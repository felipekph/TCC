function b = barcolor(data,scale,usecolormap,colormapdirection,gcaFig)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Função para plotar gráfico de barras com cores proporcionais a uma escala
% de cores
% 
% Desenvolvido pelo professor da Engenharia Acústica 
%                                William D'Andrea Fonseca, Dr. Eng.
%
% Última atualização: 17/01/2018
% Compatível com Matlab R2016b
%
% data: vetor com os valores.
% scale: vetor com a escala de valores para os dados de cor (deve ter pelo 
% menos o tamanho de "data").
% usecolormap: tipo da escala de cores (dica: para encontrar mais escalas 
% escreva "doc colormap" no Command Window).
% colormapdirection: se 'up' usa a direção normal, se 'down' inverte a direção
%
% Exemplos: 
% b = barcolor(dados,1:0.1:2,'copper');
% b = barcolor(dados,1:0.1:2,'copper','down');
% barcolor(dados)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Check inputs
% Check the number of input arguments
narginchk(1,5);
if nargin < 2
    usecolormap = 'copper'; 
    step = abs(mean(data)/100);
    scale = 0.9*min(data):step:1.2*max(data); colormapdirection = 'up'; 
    gcaFig = gca;
end
if nargin < 5, gcaFig = gca; end
if isempty(data), error('O vetor de entrada está vazio ou eu não consigo entendê-lo... faça verificação...'); end
%% Test
% close all; 
% data=0:0.1:1; data = Tortu.run; scale = 1.2:0.01:2; usecolormap = 'pink'; colormapdirection = 'up';
%% Processamento
cmap = []; eval(['cmap = colormap(' usecolormap '(length(scale)));']); 
if strcmp(colormapdirection,'down'), cmap = flipud(cmap); end
figure(1); hold on; 
for n = 1:length(data)
    [~,ix] = min(abs(scale-data(n)));  % Find the nearest value
    b = bar(gcaFig,n,data(n),'FaceColor',cmap(ix,:));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EOF