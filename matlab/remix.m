content_basename = 'bach_english_suite_2_prelude';
style_basename = 'chirp';

style_wav_path = fullfile('audio',sprintf('%s.wav',style_basename));
content_wav_path = fullfile('audio',sprintf('%s.flac',content_basename));

mix_interval_sec = 6; 

[xOrig, fsOrig] = audioread(content_wav_path);
track_length_sec = size(xOrig,1)/fsOrig;
bin_size = mix_interval_sec*fsOrig;
mix_count = 2; %fix(track_length_sec/mix_interval_sec);
[xTrans,fsTrans] = deal(cell(1,mix_count));
for j=1:mix_count
    excerpt_basename = sprintf('%s_%d',content_basename,j);
    excerpt_transfer_basename = sprintf('%s_%d_tr',content_basename,j);
    audiowrite(fullfile('audio',sprintf('%s.wav',excerpt_basename)),xOrig(bin_size*(j-1)+1:bin_size*j,:),fsOrig)
    full_loop(style_basename,excerpt_basename,excerpt_transfer_basename)
    [xTrans, fsTrans] = audioread(fullfile('results',sprintf('%s.wav',excerpt_transfer_basename)));
end

xTrans_total = cell2mat(xTrans);
sound(xTrans_total)