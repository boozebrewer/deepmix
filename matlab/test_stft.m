
% test stft
clearvars;
close all;
% clr = jet;
clr = gray;

% selector = 'yn.png';
selector = 'test.png';

% music program (stochastic non-stationary signal)
% [xOrig, fsOrig] = wavread('ben_matlab.wav');   
load mtlb;xOrig = mtlb;fsOrig = Fs;
% load('myhandel');xOrig = mtlb;fsOrig = Fs;

fprintf('orig fs %f\n',fsOrig);
%playback x original
soundblocking(xOrig, fsOrig);


%% make spectrograms
[yTosave,t,f,mx,mi,ymax,yabs,yphase,h,nfft,fs,y,x] = makespect(xOrig,fsOrig);

%% load
bL = loadspect(selector,yTosave,t,f,clr);
%% reconstruction
reconstruct(bL,mx,mi,ymax,yabs,yphase,h,nfft,fs,y,x);