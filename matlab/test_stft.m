
% test stft
clear all;
% clr = jet;
clr = gray;
% music program (stochastic non-stationary signal)
[xOrig, fsOrig] = wavread('ben_matlab.wav');   
% load benmtlb;
% xOrig = mtlb;
% fsOrig = Fs;

fprintf('orig fs %f\n',fsOrig);
soundsc(xOrig,fsOrig);

newFs = 8000;
[P,Q] = rat(newFs/fsOrig);
abs(P/Q*fsOrig-newFs);
x = resample(xOrig,P,Q);
fs = newFs;
fprintf('new fs %f\n',fs);

x = x(:, 1);                       
xmax = max(abs(x));                 
x = x/xmax; 

% signal parameters
xlen = length(x);                   
t = (0:xlen-1)/fs;                  

% define analysis and synthesis parameters
wlen=512;
h = wlen/8;
nfft = wlen*4;

% perform time-frequency analysis and resynthesis of the original signal
[stftOut, f, t_stft] = stft(x, wlen, h, nfft, fs);
[x_istft, t_istft] = istft(stftOut, h, nfft, fs);
x_istft = x_istft(:);
x_istft = x_istft/max(x_istft);
% check max error
[x_istft,x] = trncxy(x_istft,x);
maxErr = max(max(abs(x_istft-x)));
fprintf('max error (x_istft-x) %g\n',maxErr);

%% prepare spectrogram
% y = resample(stftOut,2,1);
y = stftOut;
yabs = abs(y);
yphase = angle(y);

ymax = max(yabs(:));
yn = yabs./ymax;
ylog = 10*log10(yn);
% ylog(ylog<-40)=-50;
mi = min(ylog(:));
ylog2 = ylog - mi;
mx = max(ylog2(:));
ylog3 = ylog2./mx;
% save
imwrite(ylog3,'yn.png','BitDepth',16);
% load
bLoaded = double(imread('yn.png'));
bLoaded = bLoaded./2^16;
% check max error
maxErr = max(max(abs(ylog3-bLoaded)));
fprintf('max error (ylog3-bLoaded) %g\n',maxErr);

fprintf('size out png %dx%d\n', size(bLoaded,1),size(bLoaded,2));
%% plot
figure(1);
% subplot(121);
imagesc([t(1),t(end)],[f(1),f(end)],bLoaded);
set(gca,'YDir','normal')
title('png');
colormap(clr);
colorbar;


%% add noise
a=-0;
b=-a;
bLoadedNoised = bLoaded.*(1+(a+b*rand(size(bLoaded))));

%% plot noised
% figure(1);
% subplot(122);
% imagesc([t(1),t(end)],-[f(end),f(1)],bLoadedNoised);
% title('noised');
% colormap(clr);
% colorbar;
%% reconstract

ylogReconst = bLoadedNoised*mx+mi;
yReconst = 10.^(ylogReconst/10) * ymax;


% check max error
maxErr = max(max(abs(yReconst-yabs)));
fprintf('max error (yRecoFlip-yabs) %g\n',maxErr);
% frame = 5;
% figure;plot(yabs(:,frame))
% hold on;plot(yReconst(:,frame))

% add phase
yRecoPlusPhase = yReconst .* exp(1i*yphase);
% check max error
maxErr = max(max(abs(yRecoPlusPhase-y)));
fprintf('max error (yRecoPlusPhase-y) %g\n',maxErr);
% reconstruct istft
[xReco, tRec] = istft(yRecoPlusPhase, h, nfft, fs);
xReco = xReco(:);
[xReco,x] = trncxy(xReco,x);
maxErr = max(max(abs(x-xReco)));
fprintf('max error (x-xReco) %g\n',maxErr);


%% play
% soundsc(x,fs);
% soundsc(xReco,fs);