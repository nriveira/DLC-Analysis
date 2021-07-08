fs = 200;
ts = 1/fs;
t = ts:ts:10;
f1 = 10;
f2 = 60;

s1 = sin(2*pi*f1*t);
s2 = 50*sin(2*pi*f2*t);
sig = s1'+s2';

normSig = normalizeEEG(sig, fs);

tic
result1 = get_wavelet_power(normSig, fs, [1 50], 6);
spec1 = mean(result1,2);
toc

tic
result2 = get_wavelet_power(normSig, fs, [1 50], 20);
spec2 = mean(result2,2);
toc

tic
result3 = get_wavelet_power(normSig, fs, [1 50], 50);
spec3 = mean(result3,2);
toc

figure(1); hold on;
plot(1:50, spec1)
plot(1:50, spec2)
plot(1:50, spec3)

legend(["window size = 6", "window size = 20", "window size = 50"])