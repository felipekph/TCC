clear all; format long; clc; close all; %#ok<CLALL>

% addpath("codigos_auxiliares\")

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
[ch, idx] = addAnalogOutputChannel(s, 'cDAQ1Mod3', 'ao1', 'voltage'); % ao0 - analog output canal 0

sens_mic = 0.04873; %sensibilidade em V/Pa - mic
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
                            'samplingRate', Fs, 'stopMargin', 0.1, 'freqRange', [20 Fs/2]);
        queueOutputData(s, sweep_excitacao.timeData); [Recording, t] = s.startForeground; %para gerar o ruído atraves da plana NI (tempo medicao=tempo de geracao)
        clear sound;

    end
end
    disp('End');

%%

%% post-processing (ITA)

x = sens_voltage .* Recording(:, 2);
% x = sweep_excitacao.timeData;
y = sens_mic .* Recording(:, 1);

input = itaAudio(x, 51200, 'time');
output = itaAudio(y, 51200, 'time');

ir = output.freqData ./ input.freqData;
ir = itaAudio(ir, 51200, 'freq');

ir.plot_freq;
ir.plot_time;

%% windowing
% estimative = 
% first_reflection = 0; % [ms]

% ir_windowed = ita_time_window(ir,[0 first_reflection],@hann,'time');

% ir_windowed = itaAudio(ir_windowed, 51200, 'time');
% ir_windowed.plot_freq