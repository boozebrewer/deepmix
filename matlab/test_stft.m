
% test stft

% clr = jet;
clr = gray;
% music program (stochastic non-stationary signal)
% [xOrig, fsOrig] = wavread('track.wav');   
load benmtlb;
xOrig = mtlb;
fsOrig = Fs;
newFs = 7350;
[P,Q] = rat(newFs/fsOrig);
abs(P/Q*fsOrig-newFs)
x = resample(xOrig,P,Q);
fs = newFs;


x = x(:, 1);                       
xmax = max(abs(x));                 
x = x/xmax; 

% signal parameters
xlen = length(x);                   
t = (0:xlen-1)/fs;                  

% define analysis and synthesis parameters
% wlen = 1024;
wlen=512;
h = wlen/4;
nfft = wlen;

% perform time-frequency analysis and resynthesis of the original signal
[stftOut, f, t_stft] = stft(x, wlen, h, nfft, fs);
[x_istft, t_istft] = istft(stftOut, h, nfft, fs);
x_istft = x_istft(:);
% check max error
maxErr = max(max(abs(x(1:length(x_istft))-x_istft)));
fprintf('max error (x_istft-x) %g\n',maxErr);

% prepare spectrogram
y = stftOut;
yabs = abs(y);
yphase = angle(y);
yflip = yabs(end:-1:1,:);
ymax = max(yflip(:));
yn = yflip./ymax;
ylog = 10*log10(yn);
ylog(ylog<-40)=-50;
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
%% plot
figure(1);
subplot(121);
imagesc([t(1),t(end)],-[f(end),f(1)],bLoaded);
colormap(clr);
colorbar;


%% add noise
a=-0;
b=-a;
bLoadedNoised = bLoaded.*(1+(a+b*rand(size(bLoaded))));
%% plot noised
figure(1);
subplot(122);
imagesc([t(1),t(end)],-[f(end),f(1)],bLoadedNoised);
colormap(clr);
colorbar;
%% reconstract

ylogReconst = bLoadedNoised*mx+mi;
yReconst = 10.^(ylogReconst/10) * ymax;
yRecoFlip = yReconst(end:-1:1,:);

% check max error
maxErr = max(max(abs(yRecoFlip-yabs)));
fprintf('max error (yRecoFlip-yabs) %g\n',maxErr);
figure;plot(yabs(:,1))
hold on;plot(yRecoFlip(:,1))

% add phase
yRecoFlipPlusPhase = yRecoFlip .* exp(1i*yphase);
% check max error
maxErr = max(max(abs(yRecoFlipPlusPhase-y)));
fprintf('max error (yRecoFlipPlusPhase-y) %g\n',maxErr);
% reconstruct istft
[xReco, tRec] = istft(yRecoFlipPlusPhase, h, nfft, fs);
xReco = xReco(:);
maxErr = max(max(abs(x(1:length(xReco))-xReco)));
fprintf('max error (x(1:length(xReco))-xReco) %g\n',maxErr);



%% play
% soundsc(x,fs);
% soundsc(xReco,fs);