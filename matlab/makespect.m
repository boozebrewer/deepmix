function [yTosave,t,f,mx,mi,ymax,yabs,yphase,h,nfft,fs,y,x] =  makespect(xOrig,fsOrig)
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
end