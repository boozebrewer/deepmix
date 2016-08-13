function show_spectrum_plot( content_path, t, f)

content = double(imread(content_path));
if size(content,3) == 3
    content = sum(content,3);
    content = content/max(content(:));
else
    content = content./2^16;
end


%% plot


% colorbar;
% content
subplot(132);
imagesc([t(1),t(end)],[f(1),f(end)], content);
set(gca,'YDir','normal')
title('content');
xlabel('[Sec]');
ylabel('[Hz]')


end