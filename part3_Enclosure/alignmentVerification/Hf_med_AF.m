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
    
%     freq_ticks = [10 31.5 63 100 200 315 500 1000 2000 4000 8000 16000]; 
%     
%     for i=1:30
%         text=sprintf('Medição %d', i);
%         semilogx(freq, 3.2./(abs(Hf(find(freq==2), i))).*abs(Hf(:, i)), '--', 'DisplayName', text);  grid on; hold on
%         xlabel('Frequência [Hz]', 'FontSize', 12)
%         ylabel('Curva de Impedância [\Omega]', 'FontSize', 14)
%         title('Curva de impedância Woofer KC Club 6.3 (com massa)', 'FontSize', 14)
%         legend show
%         legend('Location', 'northwest', 'NumColumns', 2, 'FontSize', 14)
%         xlim([1 20000])
%         xticks(freq_ticks)
%         set(gca,'XTickLabel',string(freq_ticks),'fontsize',18)
%     end
%     
%      print(gcf, '-dpng', '-r600', 'curva_impedancia_com_massa_ruido_branco.png')
