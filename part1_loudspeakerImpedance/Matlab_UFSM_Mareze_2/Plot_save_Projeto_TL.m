%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rotina para plotar curvas de absorção com a região de confiança
%
%
% Desenvolvido pelos professores da Engenharia Acústica da UFSM:
%    William D'Andrea Fonseca, Dr. Eng. e
%    Paulo Henrique Mareze, Dr. Eng.
%
% Atualização: 20/09/2017
%
% Configure as células:
% 1. O que FAZER?
% 2. "Entradas e controle" antes de rodar.
% 3. Se estiver comparando, comente as linhas no plot e legendas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Cleaning service
clc; clear all; close all; format long; feature('DefaultCharacterSet', 'ISO-8859-1');

%% O que FAZER?
PlotFig = 0;
Comparar = 1;

SAVEfig = 1;
TrocaDADOS = 1; CalculaConfianca = 0;

%% Entradas e controle
if PlotFig == 1 || Comparar == 1
pathtoload = 'D:\Meus Documentos\Google Drive\EAC-Projeto-Embraer\Resultados\TL antigo\Influencia da montagem\B1_inf-monatgem-TL-new.mat';
 load(pathtoload); close all;
end
%%% Segundo para comparação
if Comparar == 1
pathtoload2 = 'D:\Meus Documentos\Google Drive\EAC-Projeto-Embraer\Resultados\TL antigo\Influencia da montagem\B2_inf-monatgem-TL-new.mat';
 Amostra2 = load(pathtoload2); close all;
pathtoload3 = 'D:\Meus Documentos\Google Drive\EAC-Projeto-Embraer\Resultados\TL antigo\Medicoes comuns\B_medicao_comum-TL-new.mat';
 Amostra3 = load(pathtoload3); close all;
% pathtoload4 = 'D:\Meus Documentos\Google Drive\EAC-Projeto-Embraer\Resultados\TL novo\Influência da montagem\B2_inf-monatgem-TL_novo-new.mat';
%  Amostra4 = load(pathtoload4); close all; 
end; close all;
%%% Dados de entrada %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist('temperatura')==1 && exist('umidade')==1 && exist('pressao_atm')==1 
 Temperatura = temperatura; Umidade = umidade; Pres_estatica = pressao_atm;
end
if TrocaDADOS == 1
 %%%% Amostra %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 tipo.medicao = 'Perda de transmissão (TL)';
 Amostra.Bancada = '(bancada antiga)';
 Amostra.n = 10;              % Número de amostras para ler: 1,2,3...
 Amostra.Tipo = 'B1';          % A, B, C, ...
%  Amostra.Medicao = 'Medição comum (10 amostras cada)';  % Tipo da medição  
 Amostra.Medicao = 'Comparação';  % Tipo da medição  
 Amostra.Compara = 'Amostras B1, B2 e B (média med. comum)';          % A, B, C, ... 
%%% Frequência %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 f.span=[0:6400];                  % Vetor de frequências
 f.min = 500; f.max = f.span(end); % Frequências para plot/análise
%  f.plot=[f.min, 200, 300, 500, 1000:1000:5000, f.max]; % Eixo das frequências
 f.plot=[f.min, 1000:1000:5000, f.max]; % Eixo das frequências LOG
%  f.plot=[f.min, 1000:1000:6000, f.max]; % Eixo das frequências Linear
Plot.y.limDown = 0; Plot.y.limUp = 16; 
 %%%% Intervalo de confiança - Incerteza %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if CalculaConfianca == 1
 Confianca = 80; % Usar 80%, 90%, 95%, 98%,... ou qualuer número de 1-99.99
 %%% Média e desvio padrao do Matlab %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 [Amostra.AlphaCI,~] = stat_conf(Amostra.AlphaData,'N',Confianca);
 Amostra.AlphaMedia = mean(Amostra.AlphaData); Amostra.AlphaDesvio = std(Amostra.AlphaData); 
end
 %%% Plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 Plot.Tipo = 'log'; % 'lin' ou 'log' ou ['linear' 'log']
 Plot.Preciy = '% 2.2f'; Plot.Precix = '% 4.0f'; % Prec. dos eixso dos plots 
 Plot.xlabel = 'Frequência [Hz]'; Plot.ylabel = 'Coef. de Absorção [-]';
 %%% Save %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
%% Plot curvas individuais + intervalo de conf. para polulação Amostras.n
if PlotFig == 1
color = [0/255 0/255 0/255]; 
Nome = [Amostra.Medicao ' ' Amostra.Bancada ' - Amostra ' Amostra.Tipo ' - Repeticoes ' num2str(Amostra.n) ' - freq.' num2str(f.plot(1)) '-' num2str(f.plot(end))];
Plot.fig = figure('Name',[Amostra.Medicao ' - Absorção amostra ' Amostra.Tipo]); 
if strcmp(Plot.Tipo,'lin')
    Plot.shade1 = shadedErrorBar(f.span, Amostra.TLMediadB, {@mean, @(freq) abs(Amostra.TLCI.intervaldB)}, {'Color',color,'LineWidth', 2.0}, 0, 0.20, 'lin', 0);
    for n=1:Amostra.n, hold on; Plot.plot(n) = plot(f.span,Amostra.TLDatadB(n,:),'LineWidth', 1.5);
    end;
    Plot.shade1 = shadedErrorBar(f.span, Amostra.TLMediadB, {@mean, @(freq) abs(Amostra.TLCI.intervaldB)}, {'Color',color,'LineWidth', 2.0}, 0, 0.20, 'lin', 0);    
elseif strcmp(Plot.Tipo,'log')
    if f.span(1)==0; f.spanLog = [10^-5 f.span(2:end)]; else f.spanLog = f.span; end;
    Plot.shade2 = shadedErrorBar(f.spanLog, Amostra.TLMediadB, {@mean, @(freq) abs(Amostra.TLCI.intervaldB)}, {'Color',color,'LineWidth', 2.0}, 1, 0.20, 'log', 0);    
    for n=1:Amostra.n, hold on; Plot.plot(n) = semilogx(f.spanLog,Amostra.TLDatadB(n,:),'LineWidth', 1.5); 
    end; 
    Plot.shade2 = shadedErrorBar(f.spanLog, Amostra.TLMediadB, {@mean, @(freq) abs(Amostra.TLCI.intervaldB)}, {'Color',color,'LineWidth', 2.0}, 1, 0.20, 'log', 0);        
end
ylim([Plot.y.limDown Plot.y.limUp]); xlim([f.min f.max]); % Eixo da absorção e eixo das frequências
xlabel(Plot.xlabel); ylabel(Plot.ylabel); grid on; 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%% COMPARA médias %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if Comparar == 1
color = [0/255 0/255 0/255]; color1 = [51/255 102/255 255/255]; color2 = [255/255 0/255 102/255]; % NEW: 1 E 4 OLD: 2 e 3
color3 = [255/255 0/255 0/255]; color4 = [0/255 30/255 255/255]; color5 = [0/255 236/255 44/255]; color6 = [236/255 211/255 0/255]; 
Nome = [tipo. medicao ' - ' Amostra.Medicao ' ' Amostra.Bancada ' - Amostras ' Amostra.Tipo ' - Repeticoes ' num2str(Amostra.n) ' - freq.' num2str(f.plot(1)) '-' num2str(f.plot(end))];
Plot.fig = figure('Name',[Amostra.Medicao ' - Absorção amostra ' Amostra.Tipo ' - ' tipo.medicao]); 
if strcmp(Plot.Tipo,'lin')
    Plot.shade1 = shadedErrorBar(f.span, Amostra.TLData, {@mean, @(freq) abs(Amostra.TLCI.interval)}, {'Color',color1,'LineWidth', 3.0}, 0, 0.22, 'lin', 0); hold on;
    Plot.shade2 = shadedErrorBar(f.span, Amostra2.Amostra.TLData, {@mean, @(freq) abs(Amostra2.Amostra.TLCI.interval)}, {'Color',color2,'LineWidth', 3.0}, 0, 0.22, 'lin', 0);    
elseif strcmp(Plot.Tipo,'log')
    if f.span(1)==0; f.spanLog = [10^-5 f.span(2:end)]; else f.spanLog = f.span; end;
    Plot.shade1 = shadedErrorBar(f.spanLog, Amostra.TLMediadB, {@mean, @(freq) abs(Amostra.TLCI.intervaldB)}, {'Color',color2,'LineWidth', 2.0}, 1, 0.22, 'log', 0); hold on;
    Plot.shade3 = shadedErrorBar(f.spanLog, Amostra2.Amostra.TLMediadB, {@mean, @(freq) abs(Amostra2.Amostra.TLCI.intervaldB)}, {'Color',color1,'LineWidth', 2.0}, 1, 0.22, 'log', 0); hold on;           
    Plot.shade2 = shadedErrorBar(f.spanLog, Amostra3.Amostra.TLMediadB, {@mean, @(freq) abs(Amostra3.Amostra.TLCI.intervaldB)}, {'Color',color,'LineWidth', 2.0}, 1, 0.22, 'log', 0); hold on;        
%     Plot.shade4 = shadedErrorBar(f.spanLog, Amostra4.Amostra.TLMediadB, {@mean, @(freq) abs(Amostra4.Amostra.TLCI.intervaldB)}, {'Color',color4,'LineWidth', 2.0}, 1, 0.22, 'log', 0); hold on;            
end    
ylim([Plot.y.limDown Plot.y.limUp]); xlim([f.min f.max]); % Eixo da absorção e eixo das frequências
xlabel(Plot.xlabel); ylabel(Plot.ylabel); grid on; 
end
%% Legenda e título %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if PlotFig == 1
Plot.leg = [{['Conf.: ' num2str(Amostra.TLCI.calc.alpha) '\\\%' ... 
    ' - $\bar{A}\,\pm$ ' strrep(num2str(Amostra.TLCI.z(1,2),'%3.2f'), '.', ',') ...
    '$\,\sigma/\sqrt{n}$'],'M\''edia'}, Amostra.Nomes'];
end
if Comparar == 1
Plot.leg = [{[Amostra.Tipo ' Conf.: ' num2str(Amostra.TLCI.calc.alpha) '\\\%' ... 
    ' - $\bar{A}\,\pm$ ' strrep(num2str(Amostra.TLCI.z(1,2),'%3.2f'), '.', ',') ...
    '$\,\sigma/\sqrt{n}$'],['M\''edia ' Amostra.Tipo]} ...
    {[Amostra2.Amostra.Tipo ' Conf.: ' num2str(Amostra2.Amostra.TLCI.calc.alpha) '\\\%' ... 
    ' - $\bar{A}\,\pm$ ' strrep(num2str(Amostra2.Amostra.TLCI.z(1,2),'%3.2f'), '.', ',') ...
    '$\,\sigma/\sqrt{n}$'],['M\''edia ' Amostra2.Amostra.Tipo]} ...  
    {[Amostra3.Amostra.Tipo ' Conf.: ' num2str(Amostra3.Amostra.TLCI.calc.alpha) '\\\%' ... 
    ' - $\bar{A}\,\pm$ ' strrep(num2str(Amostra3.Amostra.TLCI.z(1,2),'%3.2f'), '.', ',') ...
    '$\,\sigma/\sqrt{n}$'],['M\''edia ' Amostra3.Amostra.Tipo]} ...  
%     {[Amostra4.Amostra.Tipo ' NOVA - Conf.: ' num2str(Amostra4.Amostra.TLCI.calc.alpha) '\\\%' ... 
%     ' - $\bar{A}\,\pm$ ' strrep(num2str(Amostra4.Amostra.TLCI.z(1,2),'%3.2f'), '.', ',') ...
%     '$\,\sigma/\sqrt{n}$'],['M\''edia ' Amostra4.Amostra.Tipo]} ...      
    ];
end

if exist('temperatura')==1
    Plot.tilte = ['Amostra ' Amostra.Tipo ' - ' Amostra.Medicao ...
      ' - Temperatura: ' strrep(num2str(Temperatura,'%4.2f'), '.', ',') ...
      ' [ºC], Umidade: ' strrep(num2str(Umidade,'%4.2f'), '.', ',') ' [%],' ...
      ' Pressão estática: ' num2str(Pres_estatica,'%6.0f')];
else
    if Comparar == 1
        Plot.tilte = [tipo.medicao ' ' Amostra.Bancada ' - ' Amostra.Compara ' - ' Amostra.Medicao];   
    else
        Plot.tilte = [tipo.medicao Amostra.Bancada ' - Amostra ' Amostra.Tipo ' - ' Amostra.Medicao]; 
    end
end
  
Plot.legend = legend(Plot.leg); set(Plot.legend,'Interpreter','latex','Location','Northwest'); % 'Southeast' 'Northwest'
title(Plot.tilte); 
%% Ajusta plot
%% Intervalo de dados no eixo y - VIA GET %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ytick.GetNum = (get(gca,'YTick'))'; ytick.GetLabel = get(gca,'YTickLabel'); 
%%% Troca ponto por vírgula e ajusta precisão %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ytick.NewLabel=sep_convert(ytick.GetNum,Plot.Preciy,'virgula',0); 
%%% Aplica no gráfico as opções do eixo y %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    set(gca,'YTick',ytick.GetNum); set(gca,'YTickLabel',ytick.NewLabel);
%% Intervalo de dados no eixo x %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xtick.Num = f.plot'; xtick.Cell = num2cell(xtick.Num); 
xtick.OldLabel = num2cell(xtick.Num); 
%%% Troca ponto por vírgula e ajusta precisão %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    xtick.NewLabel=sep_convert(xtick.Num,Plot.Precix,'virgula',0); 
    B = sep_convert(xtick.Num,'%3.1f','virgula',1);
    xtick.NewLabel{1,end} = B{1,end}; xtick.NewLabel{1,end-1} = B{1,end-1}; clear B;
%%% Aplica no gráfico as opções do eixo x %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(gca,'XTick',xtick.Num); set(gca,'XTickLabel',xtick.NewLabel)
%% Tamanho %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Plot.width = 1077; Plot.height=630; set(gcf,'color','white');
set(gcf,'units','pixels','position',[100,100,Plot.width,Plot.height]);

%% Save %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if SAVEfig == 1 
  Save.fig = 1; Save.pdf = 1; Save.png = 1;   
  save_fig(Nome,1,Plot.fig,Save.pdf,Save.png,0,Save.fig,300,Plot.Tipo,0,0);
%   export_fig(Plot.fig,sprintf('%s', Nome), '-pdf', '-r300', '-q99', '-bookmark', '-transparent', '-painters');  
end
%% Farewell
disp('Tudo OK, see you later...')
