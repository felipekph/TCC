input = zeros(length(Vn005)-1, 1);
tw = zeros(length(Vn005)-1, 1);
% woofer = zeros(length(Vn005)-1, 1);

for i=1:length(Vn005)

%     input(i, 1) = str2num(Vn001(i+1));
%     tw(i, 1) = str2num(Vn004(i+1));
%     woofer(i, 1) = str2num(Vn005(i+1, 2), 1);
    freq(i, 1) = str2num(Vn005(i, 1));
    woofer(i, 1) = str2num(Vn005(i, 2));

end

semilogx(freq, 20*log10(abs(woofer)))