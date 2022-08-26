clear all; clc; close all;
%%

function [Hf_med, coe_med, freq] = Hf_med_AF()

    path_list = dir(uigetdir(pwd, 'Escolha a pasta com os arquivos de medições para realizar a média'));

    for i = 3:length(path_list) % Os caminhos para os arquivos começam na linha 3 do path_list

        path = [path_list(i).folder '\' path_list(i).name '\']
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