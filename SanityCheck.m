fs = 200;
ts = 1/fs;
t = ts:ts:10000;
f1 = 10;
f2 = 60;

s1 = 10*sin(2*pi*f1*t);
s2 = 100*sin(2*pi*f2*t);
sig = s1+s2;

normSig = normalizeEEG(sig, fs);
result = get_wavelet_power(normSig, fs, [1 50], 6);