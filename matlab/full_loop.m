% function full_loop()
% build spectrogram
% send to aws for training

%% init 
% clr = jet;

% paths
style_wav_path = 'audio/ben_holech.wav';
content_wav_path = 'audio/tone_440.wav';
style_path = 'png/style.png';
content_path = 'png/content.png';
algo_out_path = 'png/algo_output.png';
algo_out_folder = 'png';
%% make style
[xOrig, fsOrig] = audioread(style_wav_path);
%playback x original
% soundblocking(xOrig, fsOrig);
% make spectrum
fprintf('orig fs %f\n',fsOrig);
[styleTosave,style_t,style_f] = makespect(xOrig,fsOrig);
% save
styleTosave_rgb = cat(3, styleTosave, styleTosave, styleTosave);
imwrite(styleTosave_rgb,style_path,'BitDepth',16);
fprintf('saving size out png %dx%d\n', size(styleTosave,1),size(styleTosave,2));
%% make content
[xOrig, fsOrig] = audioread(content_wav_path);
%playback x original
% soundblocking(xOrig, fsOrig);
% make spectrum
fprintf('orig fs %f\n',fsOrig);
[contentTosave,t,f,mx,mi,ymax,yabs,yphase,h,nfft,fs,y,x,nrm_factor] = makespect(xOrig,fsOrig);
% save
contentTosave_rgb = cat(3, contentTosave, contentTosave, contentTosave);
imwrite(contentTosave_rgb,content_path,'BitDepth',16);
fprintf('saving size out png %dx%d\n', size(contentTosave,1),size(contentTosave,2));
%% send to server and run transfer
send_to_aws(style_path, content_path);
%%
weight=1000; imsize=513; iters=200; init='image'; original_color =0;
run_aws(weight, imsize, iters, init,original_color);
%%
get_aws_image(algo_out_folder);
%% show all spectras
show_spectrum_of_the_three(algo_out_path, content_path, style_path, t, f, style_t, style_f);
[a,b1,c]=fileparts(style_wav_path);
[a,b2,c]=fileparts(content_wav_path)
ttl = ['style: ', b1, ' vs ', 'content: ', b2];
paramstxt = sprintf('weight %d, imsize %d, iters %d, init %s, original_color %d',weight, imsize, iters, init,original_color);
runname = [ttl,'  params-> ',paramstxt];
mysuptitle(runname);
valid_runname = genvarname(runname);
figname = sprintf('results/%s.fig',valid_runname);
savefig(figname);
%% load
bL = loadspect(algo_out_path,contentTosave,t,f);
%% reconstruction
reconstruct(bL,mx,mi,ymax,yabs,yphase,h,nfft,fs,y,x,nrm_factor)
