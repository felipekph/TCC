function [fs, index] = find_fs(data, freq_vector, vargin)

    if vargin < 3
        index = find(data == max(data(1:find(freq_vector == 300))));
        fs = freq_vector(index);
    else
        index = find(data == max(data(1:find(freq_vector == 3000))));
        fs = freq_vector(index);
end
