% paths
content_wav_path = 'audio/scale_sin_6sec.wav';
content_path = 'png/content.png';
%% make content
[xOrig, fsOrig] = audioread(content_wav_path);
%playback x original
% soundblocking(xOrig, fsOrig);
% make spectrum
fprintf('orig fs %f\n',fsOrig);
wlen = 256;
h = wlen/2;
nfft = wlen*4;
[contentTosave,t,f,mx,mi,ymax,yabs,yphase,h,nfft,fs,y,x,nrm_factor] = makespect(xOrig,fsOrig, wlen, h, nfft);
% save
contentTosave_rgb = cat(3, contentTosave, contentTosave, contentTosave);
imwrite(contentTosave_rgb,content_path,'BitDepth',16);
fprintf('saving size out png %dx%d\n', size(contentTosave,1),size(contentTosave,2));

%% show spectrum
show_spectrum_plot( content_path, t, f);
