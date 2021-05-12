for m = 23:length(mouse)
    D = [];
    
    D.name = mouse(m).name;
    
    for d = 1:length(mouse(m).day)   
        D.day(d).name = mouse(m).day(d).name;
        for b = 1:length(mouse(m).day(d).begin)
            D.day(d).begin(b).name = mouse(m).day(d).begin(b).name;
            D.day(d).begin(b).freq = mouse(m).day(d).begin(b).freq;
            
            [eeg, sig, modelfit, mu] = normalizeEEG(mouse(m).day(d).begin(b).interictalEEG, mouse(m).day(d).begin(b).freq);
            D.day(d).begin(b).wavelet_power = get_wavelet_power(eeg, mouse(m).day(d).begin(b).freq, [25 50], 6)';
        end
    end
    name = strcat('./analyzedClips/', mouse(m).day(d).name,'.mat');
    save(name, 'D', '-v7.3');
end