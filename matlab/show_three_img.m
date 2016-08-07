function show_three_img(algo_out_path, content_path, style_path)
algo = (imread(algo_out_path));
content = (imread(content_path));
style = (imread(style_path));

%% plot
figure;
% style
figure('units','normalized','outerposition',[0 0 1 1]);
subplot(131);
imshow(style);
axis on;
title('style');
% content
subplot(132);
imshow(content);
axis on;
title('content');
% transfer
subplot(133);
imshow(algo);
axis on;
title('algo');

end