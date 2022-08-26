function lgnd_interp2latex(legendIcons)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rotina para corrigir itens da legenda para interpreter Latex
%
% Desenvolvido pelo professor William D'Andrea Fonseca, Dr. Eng.
%
% Atualização: 13/11/2017
%
% Exemplo:
% [Plot.legend, Plot.legendIcons] = legend(Plot.leg); 
% Plot.PatchInLegend = findobj(Plot.legendIcons, 'type', 'patch'); set(Plot.PatchInLegend, 'FaceAlpha', 0.3);
% lgnd_interp2latex
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Correction
for q = 1:length(legendIcons)
    % if icon is text field, change intepreter to latex and fix labeling
    if isprop(legendIcons(q), 'Interpreter')
        set(legendIcons(q), 'Interpreter', 'latex');
    end
end

end