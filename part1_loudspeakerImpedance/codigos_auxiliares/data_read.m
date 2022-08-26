function [Hf_med, coe_med, freq] = Hf_med_AF()

    path_list = dir(uigetdir(pwd, 'Escolha a pasta com os arquivos de medições para realizar a média'));

    for i = 3:length(path_list) % Os caminhos para os arquivos começam na linha 3 do path_list

        path = [path_list(i).folder '/' path_list(i).name '/'];
        file = load(path);

        % Struct auxiliar para Hf e coe
        aux_hf = file.Hf;
        aux_coe = file.coe;

        if i == 3

           Hf = zeros(length(aux_hf), length(path_list)-3);
           coe = zeros(length(aux_coe), length(path_list)-3);
           freq = file.freqh;

        end

        Hf(:, i-2) = aux_hf;
        coe(:, i-2) = aux_coe; 

    end

    % Cálculo da média

    Hf_med = mean(Hf, 2);
    coe_med = mean(coe, 2);
    
    freq_ticks = [20 100 10000]; 
    
    for i=1:30
        text=sprintf('Medição %d', i);
        semilogx(freq, 3.2./(abs(Hf(find(freq==2), i))).*abs(Hf(:, i)), '--', 'DisplayName', text);  grid on; hold on
        xlabel('Frequência [Hz]', 'FontSize', 14)
        ylabel('Impedância [\Omega]', 'FontSize', 14)
        title('Curva de Impedância - Tweeter Audiophonic KC Club 1"', 'FontSize', 14)
        legend show
        legend('Location', 'southoutside', 'NumColumns', 6, 'FontSize', 14)
        xlim([20 20000]), ylim([3 10])
        xticks(freq_ticks)
        set(gca,'XTickLabel',string(freq_ticks),'fontsize',18)
        set(gcf,'units','normalized','outerposition',[0.1 0.1 0.6 0.8])
    end
    
     print(gcf, '-dpng', '-r300', 'curva_impedancia_tweeter_ruido_branco.png')
