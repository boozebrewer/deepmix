function show_spectrum_of_the_three(algo_out_path, content_path, style_path, t, f, style_t, style_f)

algo = double(imread(algo_out_path));
if size(algo,3) == 3
    algo = sum(algo,3);
    algo = algo/max(algo(:));
else
    algo = algo./2^16;
end

content = double(imread(content_path));
if size(content,3) == 3
    content = sum(content,3);
    content = content/max(content(:));
else
    content = content./2^16;
end

style = double(imread(style_path));
if size(style,3) == 3
    style = sum(style,3);
    style = style/max(style(:));
else
    style = style./2^16;
end


%% plot
% style
figure('units','normalized','outerposition',[0 0 1 1]);
subplot(131);
imagesc([style_t(1),style_t(end)],[style_f(1),style_f(end)], style);
set(gca,'YDir','normal')
title('style');
xlabel('[Sec]');
ylabel('[Hz]')

% colorbar;
% content
subplot(132);
imagesc([t(1),t(end)],[f(1),f(end)], content);
set(gca,'YDir','normal')
title('content');
xlabel('[Sec]');
ylabel('[Hz]')

% colorbar;
% transfer
subplot(133);
imagesc([t(1),t(end)],[f(1),f(end)], algo);
set(gca,'YDir','normal')
title('transfer');
xlabel('[Sec]');
ylabel('[Hz]');

% colorbar;

end