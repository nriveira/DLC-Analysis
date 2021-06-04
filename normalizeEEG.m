function [ normSignal, sig, modelfit, mu] = normalizeEEG( rSignal , fs)
% normalizeEEG normalizes an EEG signal to a variance of 1 and a mean of 0.
% It does this by using the standard deviation and mean of the signal as
% calculated by a guassian model fit after the signal has been cleaned of
% 60Hz noise (notch filter) and baseline drift (high pass filter).
%
% [ normSignal, sig, modelfit, mu] outputs provide:
%
% normSignal: normalized signal
% sig: the standard deviation of the model fit
% modelFit: a output describing how well the guassian fit the data where 1
% is a perfect fit and 0 is the worst fit on the planet yourDataSucks.
% mu: the mean of the guassian fit
%
% example:
%
% [basePath merlinPath cookieMonster] = getUserPath();
% edffile = '/Volumes/cookieMonster/jonesLab_data/sleep_and_seizures/EEG_data/RQ/EDFs/Ronde_4.edf';
% handles = read_EDF_mj(edffile);
% EDFSignalMat = handles.D.edf.signalMat;
% signal = EDFSignalMat(:,1);
% fs = 256;
% [ normSignal, sig, modelfit, mu] = normalizeEEG( signal , fs)
%
% JP 2017

% apply filter to signal
filtSignal = rSignal;
% filtSignal = highPassChebyshev1Filt_EEG(filtSignal, fs); % high pass filter above 2Hz


% normalize each of the first 5 channels of the EEG to the set the variance in each channel to 1
tempSignal = rSignal;
set(0,'DefaultFigureVisible','off');
% fit a guassian model to the signal
hfit = histfit(tempSignal, floor(sqrt(length(tempSignal))), 'normal');
yk = hfit(1).YData;
xk = hfit(1).XData;
guessInd = find(yk == max(yk));
guessInd = guessInd(1);
guess = [xk(guessInd), std(tempSignal), max(yk)];
guess_mu = guess(1);
guess_sigma = guess(2);
guess_A = guess(3);
% [guess, fval] = fminsearch( 'fitgauss', guess, [], xk, yk, 1);
% hold on;
[mu, sig, amp] = deal(  guess(1), guess(2), guess(3) ); 
est = amp.*exp(-(xk-mu).^2./sig.^2);
%bar(xk, yk);
%plot(xk, est, 'g');
%title('Hist/Fit', 'interpreter', 'none');
%ylabel('sqrt(length(EEGsignal))');
%xlabel('Current (pA)');
%hold off;

% calculate model fit
auc = trapz(xk, est);
aud = trapz(xk, yk);

modelfit = 1- ((aud - auc) / aud);

tempSignal = filtSignal - mu;
tempSignal = tempSignal / sig;
normSignal = tempSignal;

% close window after plot
close all

end

