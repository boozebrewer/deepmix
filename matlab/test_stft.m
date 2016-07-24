
% test stft
clearvars;
% clr = jet;
clr = gray;
% music program (stochastic non-stationary signal)
[xOrig, fsOrig] = wavread('ben_matlab.wav');   
% load mtlb;xOrig = mtlb;fsOrig = Fs;

fprintf('orig fs %f\n',fsOrig);
%playback x original
soundblocking(xOrig, fsOrig);


newFs = 8000;
[P,Q] = rat(newFs/fsOrig);
abs(P/Q*fsOrig-newFs);
x = resample(xOrig,P,Q);
fs = newFs;
fprintf('new fs %f\n',fs);

x = x(:, 1);                       
xmax = max(abs(x));                 
x = x/xmax *0.9; 

% signal parameters
xlen = length(x);                   
t = (0:xlen-1)/fs;                  

% define analysis and synthesis parameters
wlen=256;
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
yTosave = ylog2./mx;
% save
imwrite(yTosave,'yn.png','BitDepth',16);
fprintf('saving size out png %dx%d\n', size(yTosave,1),size(yTosave,2));

%% load
bLoaded = double(imread('test.png'));
if size(bLoaded,3) == 3
    bLoaded = sum(bLoaded,3);
    bLoaded = bLoaded/max(bLoaded(:));
else
    bLoaded = bLoaded./2^16;
end
% check max error
maxErr = max(max(abs(yTosave-bLoaded)));
fprintf('max error (yTosave-bLoaded) %g\n',maxErr);

%% plot
figure(1);
subplot(121);
imagesc([t(1),t(end)],[f(1),f(end)],yTosave);
set(gca,'YDir','normal')
title('png to save');
colorbar;

subplot(122);
imagesc([t(1),t(end)],[f(1),f(end)],bLoaded);
set(gca,'YDir','normal')
title('png loaded');
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

%% reconstruction
reconstruct(bLoadedNoised,mx,mi,ymax,yabs,yphase,h,nfft,fs,y,x);