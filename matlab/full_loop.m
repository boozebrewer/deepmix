% function full_loop()
% build spectrogram
% send to aws for training
%% init 
HOSTNAME = '54.243.26.94';
% paths
style_wav_path = 'scale_fm_6sec.wav';
content_wav_path = 'bach_6sec.wav';
style_path = 'png/style.png';
content_path = 'png/content.png';
algo_out_path = 'png/algo_output.png';
algo_out_folder = 'png';
%params
weight=500; imsize=513; iters=250; init='image'; original_color =0;
con_layers = 'relu4_2';%  Default is relu4_2
sty_layers = 'relu1_1,relu2_1,relu3_1,relu4_1,relu5_1'; % Default relu1_1,relu2_1,relu3_1,relu4_1,relu5_1
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
%% make style
[style_xOrig, style_fsOrig] = audioread(style_wav_path);
%playback x original
% soundblocking(style_xOrig, style_fsOrig);
% make spectrum
fprintf('orig fs %f\n',style_fsOrig);
style_wlen = 256;
style_h = wlen/2;
style_nfft = wlen*4;
[styleTosave,style_t,style_f,style_mx,style_mi,style_ymax,style_yabs,style_yphase,style_h,style_nfft,style_fs,style_y,style_x,style_nrm_factor] = makespect(style_xOrig,style_fsOrig, style_wlen, style_h, style_nfft);
% save
styleTosave_rgb = cat(3, styleTosave, styleTosave, styleTosave);
imwrite(styleTosave_rgb,style_path,'BitDepth',16);
fprintf('saving size out png %dx%d\n', size(styleTosave,1),size(styleTosave,2));

%% send to server and run transfer
send_to_aws(style_path, content_path,HOSTNAME);
%%
% init='image' or 'random'
run_aws(weight, imsize, iters, init,original_color, con_layers, sty_layers, HOSTNAME);
%%
get_aws_image(algo_out_folder,HOSTNAME);
%% show all spectras
show_spectrum_of_the_three(algo_out_path, content_path, style_path, t, f, style_t, style_f);
[a,b1,c]=fileparts(style_wav_path);
[a,b2,c]=fileparts(content_wav_path);
ttl = ['style: ', b1, ' vs ', 'content: ', b2];
paramstxt = sprintf('weight %d, imsize %d, iters %d, init %s, o_c %d, s_lay %s, c_lay %s',weight, imsize, iters, init,original_color, sty_layers, con_layers);
runname = [ttl, '  params-> ', paramstxt];
mysuptitle(runname);
valid_runname = mymakeValidName(runname);
figname = sprintf('results/output/%s.fig',valid_runname);
% savefig(figname);
saveas(gcf,[figname,'.jpg']);
%% load
bL = loadspect(algo_out_path,contentTosave,t,f);
%% reconstruction
xReco = reconstruct(bL,mx,mi,ymax,yabs,yphase,h,nfft,fs,y,x,nrm_factor);
title(runname,'interpreter','none');
figname = sprintf('results/output/%s_time.fig',valid_runname);
% savefig(figname);
saveas(gcf,[figname,'.jpg']);
audiowrite([figname,'.wav'],xReco,fs);
%% play
myplay([figname,'.wav']);
