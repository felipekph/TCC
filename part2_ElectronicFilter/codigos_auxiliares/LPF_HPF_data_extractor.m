function [Hf_med, coe_med, freq] = LPF_HPF_data_extractor()

    path_list = dir(uigetdir(pwd, 'Escolha a pasta com os arquivos das medições!'))

    for i = 3:length(path_list)

        path = [path_list(i).folder '/' path_list(i).name '/'];
        file = load(path);
        
        aux_hf_lpf = file.Hf_LPF;
        aux_coe_lpf = file.coe_LPF;

        aux_hf_hpf = file.Hf_HPF;
        aux_coe_hpf = file.coe_HPF;

        if i == 3

            Hf_LPF = zeros(length(aux_hf_lpf), length(path_list)-3);
            coe_LPF = zeros(length(aux_coe_lpf), length(path_list)-3);
            
            Hf_HPF = zeros(length(aux_hf_hpf), length(path_list)-3);
            coe_HPF = zeros(length(aux_coe_hpf), length(path_list)-3);
            
            freq = file.freqh;

        end

        Hf_LPF(:, i-2) = file.Hf_LPF;
        coe_LPF(:, i-2) = file.coe_LPF;

        Hf_HPF(:, i-2) = file.Hf_HPF;
        coe_HPF(:, i-2) = file.coe_HPF;

    end

end
