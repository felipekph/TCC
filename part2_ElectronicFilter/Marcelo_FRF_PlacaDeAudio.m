%% CODIGO PARA MEDIR FRF (BYPASS) DO PREAMPLIFICADOR

% Autor: Marcelo Santos Brites
% Data: 4/08/2021
% Modificações: Felipe Eduardo Petry | 23/01/22

close all; clear all; clc;

%% DEFININDO OS PARÂMETROS DE MEDIÇÃO E CRIANDO O SINAL DE EXCITACAO (SWEEP)
% Aqui é definido os parâmetros de medição, canal de entrada e saída e
% criado o sinal sweep e depois salva-se o sinal de excitação.

% Parâmetros da medição
med_fftd = 18;
Fs = 51200;
freq_range = [20 Fs/2];

% Canal de entrada e saída
channel_in = 1;                    % Canal de entrada - Se mais de 1 canal colocar entre [] 
channel_out = 1;                   % Canal de saida

% Cria e guarda o sinal de excitação
sweep_excitacao = ita_generate_sweep('fftDegree', 19,'mode', 'exp', ...
    'samplingRate', Fs,'stopMargin', 1,'freqRange', freq_range);

% Guarda o sinal de excitação
save('Dados/sweep_excitacao.mat', 'sweep_excitacao')

%%

uiwait(msgbox('Conecte a saida da interface na entrada da interface e clique em OK'));

%% Medindo o bypass da interface de audio
% Primeiramente é feita uma medição de bypass da interface de áudio a ser
% utilizada, a fim de remover posteriormente as influências da mesma na
% medição propriamente dita.
% Obs: Deve-se ir modificando o valor de out_amp_bp até um pouco antes do
% sinal clipar. Dessa forma, obtem-se um ótimo SNR para a medição.

out_amp_bp = -1;                      % Output amplification

bp = itaMSPlaybackRecord;
bp.outputChannels = channel_out;   % Canal de saída
bp.inputChannels = channel_in;     % Canal de entrada 
bp.freqRange = freq_range;         % Faixa de frequência de medição
bp.fftDegree = med_fftd;           % FFTDegree da medição
bp.precision = 'double';           % Precisão
bp.outputamplification = out_amp_bp;  % Amplificação de saída
bp.excitation = sweep_excitacao;   % Sinal de excitação
med_bp = bp.run;                  % Variável que salva os dados

% Obtenção da resposta ao impulso
bypass_presonus = med_bp/sweep_excitacao;

% Guarda dados
save('Dados/med01_bp.mat', 'med_bp')
save('Dados/bypass01_presonus.mat', 'bypass_presonus')

% Plots

med_bp.plot_time                        %take a look (time)
med_bp.plot_freq                        %take a look (frequency)

bypass_presonus.plot_time;		%take a look (time)
bypass_presonus.plot_freq;		%take a look (frequency)

%%

uiwait(msgbox('Conecte a saida da interface na entrada do circuito e a saida do circuito na entrada da interface e clique em OK'));

%% Medindo frf do circuito
% Começa-se fazendo a medição do sistema, depois obtem-se a resposta ao
% impulso e, por fim, é removida as influências da interface de áudio na
% resposta final.
% Obs: Deve-se ir modificando o valor de out_amp até um pouco antes do
% sinal clipar. Dessa forma, obtem-se um ótimo SNR para a medição.

out_amp = -1;

medicao = itaMSPlaybackRecord ;
medicao.outputChannels = channel_out;   % Canal de saída
medicao.inputChannels = channel_in;     % Canal de entrada 
medicao.freqRange = freq_range;         % Faixa de frequência de medição
medicao.fftDegree = med_fftd;           % FFTDegree da medição
medicao.precision = 'double';           % Precisão
medicao.outputamplification = out_amp;  % Amplificação de saída
medicao.excitation = sweep_excitacao;   % Sinal de excitação
frf_med = medicao.run;                  % Variável que salva os dados

% Resposta ao impulso do sistema sem correção da interface
FRF = frf_med/sweep_excitacao;

% Resposta ao impulso do sistema com correção
FRF_corrigida = FRF/bypass_presonus;

% Guarda dados

save('Dados/frf_med01.mat', 'frf_med')
save('Dados/FRF.mat', 'FRF', 'FRF_corrigida')

% Plots

frf_med.plot_time;
frf_med.plot_freq;                       

FRF.plot_time;
FRF.plot_freq;

FRF_corrigida.plot_time;
FRF_corrigida.plot_freq;		
