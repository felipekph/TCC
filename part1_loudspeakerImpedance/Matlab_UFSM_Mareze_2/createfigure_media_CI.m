function createfigure_media_CI(YData1, XData1, X1, Y1)
%CREATEFIGURE(YDATA1, XDATA1, X1, Y1)
%  YDATA1:  patch ydata
%  XDATA1:  patch xdata
%  X1:  vector of x data
%  Y1:  vector of y data

%  Auto-generated by MATLAB on 26-Oct-2017 22:02:34

% Create figure
figure1 = figure('Name','Medi��o comum Tubo de imped�ncia G',...
    'Color',[1 1 1]);

% Create axes
axes1 = axes('Parent',figure1,...
    'YTickLabel',{'0,00','0,10','0,20','0,30','0,40','0,50','0,60','0,70','0,80','0,90','1,00'},...
    'YTick',[0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1],...
    'XMinorTick','on',...
    'XTickLabel',{'100','1000','2000','3000','4000','5,0 k','6,4 k'},...
    'XScale','log',...
    'XTick',[100 1000 2000 3000 4000 5000 6400]);
%% Uncomment the following line to preserve the X-limits of the axes
% xlim(axes1,[100 6400]);
%% Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes1,[0 1]);
box(axes1,'on');
grid(axes1,'on');
hold(axes1,'on');

% Create patch
patch('Parent',axes1,...
    'DisplayName','Conf.: 80\\\% - $\bar{A}\,\pm$ 1,28$\,\sigma/\sqrt{n}$',...
    'YData',YData1,...
    'XData',XData1,...
    'FaceAlpha',0.2,...
    'EdgeColor','none');

% Create semilogx
semilogx(X1,Y1,'DisplayName','M\''edia','LineWidth',3,'Color',[0 0 0]);

% Create xlabel
xlabel('Frequ�ncia [Hz]');

% Create ylabel
ylabel('Coef. Absor��o [-]');

% Create title
title('Tubo de imped�ncia (bancada nova) - Amostra G - Medi��o comum');

% Create legend
legend1 = legend(axes1,'show');
set(legend1,'Location','northwest','Interpreter','latex',...
    'FontName','Cambria Math');

