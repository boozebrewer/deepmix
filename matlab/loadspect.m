function bL = loadspect(output_path,yTosave,t,f)
%% load
bLoaded = double(imread(output_path));
if size(bLoaded,3) == 3
    bLoaded = sum(bLoaded,3);
    bLoaded = bLoaded/max(bLoaded(:));
else
    bLoaded = bLoaded./2^16;
end
% check max error
maxErr = max(max(abs(yTosave-bLoaded)));
fprintf('max error (yTosave-bLoaded) %g\n',maxErr);

%% plot
figure;
subplot(121);
imagesc([t(1),t(end)],[f(1),f(end)],yTosave);
set(gca,'YDir','normal')
title('original png');
colorbar;

subplot(122);
imagesc([t(1),t(end)],[f(1),f(end)],bLoaded);
set(gca,'YDir','normal')
title('png loaded');
colorbar;


%% add noise
a=-0;
b=-a;
bLoadedNoised = bLoaded.*(1+(a+b*rand(size(bLoaded))));

%% plot noised
% figure(1);
% subplot(122);
% imagesc([t(1),t(end)],-[f(end),f(1)],bLoadedNoised);
% title('noised');
% colormap(clr);
% colorbar;

bL = bLoadedNoised;
