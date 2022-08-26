function [Le_1kHz, Le_10kHz, Le_20kHz] = L_estimate(Hf, freq, re)

    hf_sliced = Hf(find(freq == 250):end);
    freq_sliced = freq(find(freq == 250):end);

    Le_f = abs(sqrt(abs(hf_sliced).^2 - re^2)) ./ (2 * pi .* freq_sliced);
    
    % return values in mH
    Le_1kHz = 10^3 * Le_f(find(freq_sliced == 1000));
    Le_10kHz = 10^3 * Le_f(find(freq_sliced == 10000));
    Le_20kHz = 10^3 * Le_f(find(freq_sliced == 20000));

end
