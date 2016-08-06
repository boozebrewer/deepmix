function full_loop()
% build spectrogram
% send to aws for training

%% init 
% clr = jet;
coclr = gray();
% paths
style_wav_path = 'audio/ben_matlab.wav';
content_wav_path = 'audio/matlab.wav';
style_path = 'png/style.png';
content_path = 'png/content.png';
algo_out_path = 'png/algo_output.png';

%% make style
[xOrig, fsOrig] = wavread(style_wav_path);
%playback x original
% soundblocking(xOrig, fsOrig);
% make spectrum
fprintf('orig fs %f\n',fsOrig);
[styleTosave,t,f,mx,mi,ymax,yabs,yphase,h,nfft,fs,y,x] = makespect(xOrig,fsOrig);
% save
imwrite(styleTosave,style_path,'BitDepth',16);
fprintf('saving size out png %dx%d\n', size(styleTosave,1),size(styleTosave,2));
%% make content
[xOrig, fsOrig] = wavread(content_wav_path);
%playback x original
% soundblocking(xOrig, fsOrig);
% make spectrum
fprintf('orig fs %f\n',fsOrig);
[contentTosave,t,f,mx,mi,ymax,yabs,yphase,h,nfft,fs,y,x,nrm_factor] = makespect(xOrig,fsOrig);
% save
imwrite(contentTosave,content_path,'BitDepth',16);
fprintf('saving size out png %dx%d\n', size(contentTosave,1),size(contentTosave,2));
%% send to server and run transfer
send_to_aws(style_path, content_path);
%%
weight=1; imsize=513; iters=200; init='random';
run_aws(weight, imsize, iters, init);
%%
get_aws_image();
%% load
bL = loadspect(algo_out_path,contentTosave,t,f,coclr);
%% reconstruction
reconstruct(bL,mx,mi,ymax,yabs,yphase,h,nfft,fs,y,x,nrm_factor);