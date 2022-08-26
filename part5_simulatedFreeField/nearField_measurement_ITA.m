clear all; format long; clc; close all; %#ok<CLALL>

addpath("codigos_auxiliares\")

%% 

d = daq.getDevices;
s = daq.createSession('ni');
Fs = 51200; % Freq de amostragem
s.Rate = Fs;
deltaf = 1; % resolucao do eixo de frequencias, em Hz (deta f)
Nfft = (1/deltaf)*Fs; % numero de pontos da FFT
trec = 6; % tempo de medicao em segundos
s.DurationInSeconds = trec;

% [ch,idx] = addAnalogInputChannel(s,'cDAQ1Mod1',0,'IEPE'); % canal 0, até 3
[ch, idx] = addAnalogInputChannel(s, 'cDAQ1Mod1',  'ai0',  'Microphone');
[ch, idx] = addAnalogInputChannel(s, 'cDAQ1Mod1', 'ai1', 'voltage');
[ch, idx] = addAnalogInputChannel(s, 'cDAQ1Mod1', 'ai2', 'voltage');
[ch, idx] = addAnalogOutputChannel(s, 'cDAQ1Mod2', 'ao1', 'voltage'); % ao0 - analog output canal 0

sens_mic = 0.04898; %sensibilidade em V/Pa - mic
sens_voltage = 10;
s.Channels(1).Sensitivity = sens_mic; 
s.Channels(1).MaxSoundPressureLevel = 125; %dB
%% Definição e geração dos sinais de excitação

ruido = 2; %aleat-1; sweep-2; 

for nn = 1:1%numero de medias

    disp('Two seconds to start of recording')
    pause(2)
    disp('Started!')

    if ruido==2 

        sweep_excitacao = ita_generate_sweep('fftDegree', Fs*trec, 'mode', 'exp', ...
                            'samplingRate', Fs, 'stopMargin', 0.1, 'freqRange', [20 20000]);
        queueOutputData(s, sweep_excitacao.timeData); [Recording, t] = s.startForeground; %para gerar o ruído atraves da plana NI (tempo medicao=tempo de geracao)
        clear sound;

    end

    if ruido==3

        f1=2000; f2=2000.001; % Para geração de um seno em 250 Hz.
        [sweepf, sweepf_fs, sweepf_t] = sweepsine(trec, f1, f2, Fs);
        sweepf = sweepf.*0.9; % para não clipar
        queueOutputData(s, sweepf); [Recording, t] = s.startForeground; %para gerar o ruído atraves da plana NI (tempo medicao=tempo de geracao)
    end
end
    disp('End');
%% post-processing (ITA)

x = sens_voltage .* Recording(:, 2);
% x = sweep_excitacao.timeData;
y = sens_mic .* Recording(:, 1);

input = itaAudio(x, 51200, 'time');
output = itaAudio(y, 51200, 'time');

ir = output.freqData ./ input.freqData;
ir = itaAudio(ir, 51200, 'freq');

% ir.plot_freq;
% xlim([20 20000])
% % ir.plot_time;

rms_w = rms((Recording(:, 2) * 10) .* (Recording(:, 3) * 10))