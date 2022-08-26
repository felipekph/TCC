clear all; format long; clc; close all; %#ok<CLALL>

%% Carrega os dispositivos da NI e seta a frequ�ncia de amostragem, resolu��o espectral, NFFT e tempo de medi��o (em s).

% addpath("codigos_auxiliares/") 

d = daq.getDevices;
s = daq.createSession('ni');
s.Rate = 51200; % Taxa de amostragem para a NI.
Fs = s.Rate; % Taxa de amostragem.
deltaf = 0.1; % Resolucao do eixo de frequencias, em Hz.
NFFT = (1/deltaf)*Fs; % N�mero de pontos da FFT.
% s.DurationInSeconds = 30; % Tempo de dura��o da medi��o, em segundos.

%% Seta os canais 0 e 1 da NI para canais de entrada

% [ch, idx] = addAnalogInputChannel(s, 'cDAQ1Mod1', [0, 1, 2], 'voltage'); % Canal 0, Canal 1 e Canal 2
[ch, idx] = addAnalogOutputChannel(s, 'cDAQ1Mod2', 'ao0', 'voltage'); % ao0 - analog output canal 0

% channels = d.Subsystems.ChannelNames

sens1 = 1;% %sensibilidade V/V
calscale1 = 1/sens1;

sens2 = 1;% %sensibilidade V/V
calscale2 = 1/sens2;

sens3 = 1;
calscale3 = 1/sens3;

%% Especifica��es sobre o sinal de medi��o

trec = 60; % Tempo de grava��o, em segundos;
nbits = 16; % A NI 9234 � 24 bits por�m a NI 9263 � 16 bits;
ruido = 1; % ru�do branco-1; sweep-2;
Ts = trec; % %Tempo de gera��o do som;

%%
fprintf('Cada medi��o ter� uma dura��o de %d segundos \n', trec)

for nn = 1:5%numero de medias
    
    %% Medi��o sem massa

    disp('------------------------------------------------------------------------------------------------')
    input('D� Enter para come�ar com a medi��o do sistema!\n'); 
    disp('------------------------------------------------------------------------------------------------')
    text = sprintf('A medi��o da FRF do crossover est� come�ando!', nn);
    disp(text);
    disp('N�o esque�a de anotar a temperatura atual e umidade relativa!')
       
    if ruido == 1
        
        ts = 0:1/Fs:Ts-1/Fs;
        rNoise = dsp.ColoredNoise('Color', 'white', 'SamplesPerFrame', Ts*Fs, 'NumChannels', 1); %white, blue, brown
        xs = rNoise(); clear pinkNoise;
        xs = xs./(max(xs)); 
        queueOutputData(s, xs); [Recording, t] = s.startForeground; %para gerar o ru�do atraves da plana NI (tempo medicao=tempo de geracao)
        clear sound;

        day = datetime('today');
        fname = sprintf('medicao_crossover_FRF_%d_%s_ruido_branco_%ds', nn, day, trec); 
        
    end

    if ruido == 2
     
        sweep_excitacao = ita_generate_sweep('fftDegree', Fs*trec,'mode', 'exp', ...
                            'samplingRate', Fs,'stopMargin', 0.2,'freqRange', [20 Fs/2]);
        queueOutputData(s, sweep_excitacao.timeData); [Recording, t] = s.startForeground; %para gerar o ru�do atraves da plana NI (tempo medicao=tempo de geracao)
        clear sound;

        day = datetime('today');
        fname = sprintf('medicao_crossover_FRF_%d_%s_sweep_%ds', nn, day, trec); 
        
    end
    
%
    disp('A medi��o acabou!');

    %% C�lculos e salva dados

    % Sinais no tempo
    x = calscale2 .* Recording(:, 1); % Canal 1 - Resistor
    y = calscale1 .* Recording(:, 2); % canal 2 - Woofer LPF
    z = calscale3 .* Recording(:, 3); % Canal 3 - Tweeter HPF

    % Estimativa da FRF e coer�ncia
    a = 2;
    b = 1;
    [Hf_LPF, freqh] = tfestimate(x, y, hanning(NFFT), NFFT/a, b*NFFT, Fs);
    [Hf_HPF, freqh] = tfestimate(x, z, hanning(NFFT), NFFT/a, b*NFFT, Fs);

    [coe_LPF, freqc] = mscohere(x, y, hanning(NFFT), NFFT/a, b*NFFT, Fs);
    [coe_HPF, freqc] = mscohere(x, z, hanning(NFFT), NFFT/a, b*NFFT, Fs);

    % Salvando dados (fname � definido dentro dos ruidos para ter os nomes certos para cada caso)

    text = sprintf('Salvando o arquivo %s\n', fname);
    path = ['Dados/com_falante/' fname];
 
    disp('------------------------------------------------------------------------------------------------')
    disp(text)
    disp(path)
    disp('------------------------------------------------------------------------------------------------')
    save(path);

    % Plots
% 
    figure('Name', 'Sinais no tempo')
    plot(t, Recording(:, 1), 'k', t, Recording(:, 2), 'r', t, Recording(:, 3), 'b'); grid on; %hold on;
    xlabel('Tempo [s]'); ylabel('Amplitude [V]')
    input_text = sprintf('Entrada: %.2f V_{rms}', rms(Recording(:, 1)));
    woofer_text = sprintf('Woofer: %.2f V_{rms}', rms(Recording(:, 2)));
    tweeter_text = sprintf('Tweeter: %.2f V_{rms}', rms(Recording(:, 3)));
    legend(input_text, woofer_text, tweeter_text)

    figure('Name', 'Fun��o de transfer�ncia')
    semilogx(freqh, 20*log10(abs(Hf_LPF)));  grid on; hold on
    semilogx(freqh, 20*log10(abs(Hf_HPF)));
    xlabel('Frequ�ncia [Hz]')
    ylabel('Fun��o de Transfer�ncia [dB]')
    legend('LPF', 'HPF')
    xlim([20 20000])
    ylim([-50 20])
% 
%     figure('Name', 'Coer�ncia LPF')
%     semilogx(freqh, coe_LPF);  grid on; hold on
%     xlabel('Frequ�ncia [Hz]')
%     ylabel('Coer�ncia [-]')
%     xlim([0 20000])
%     ylim([0.5 1]) 
% 
%     figure('Name', 'Coer�ncia HPF')
%     semilogx(freqh, coe_HPF);  grid on; hold on
%     xlabel('Frequ�ncia [Hz]')
%     ylabel('Coer�ncia [-]')
%     xlim([0 20000])
%     ylim([0.5 1]) 

end