function xReco = reconstruct(bLoadedNoised,mx,mi,ymax,yabs,yphase,h,nfft,fs,y,x,nrm_factor)
%% reconstract

ylogReconst = bLoadedNoised*mx+mi;
yAbsReconst = 10.^(ylogReconst/10) * ymax;


% check max error
maxErr = max(max(abs(yAbsReconst-yabs)));
fprintf('max error (yAbsReconst-yabs) %g\n',maxErr);
% frame = 5;
% figure;plot(yabs(:,frame))
% hold on;plot(yReconst(:,frame))

% add phase
% yphase = yphase + 10*randn(size(yphase));
% yphase = 3*rand(size(yAbsReconst,1),size(yAbsReconst,2));
% yphase = yphase(1:size(yAbsReconst,1),1:size(yAbsReconst,2));
yAbsRecoPlusPhase = yAbsReconst .* exp(1i*yphase);
% check max error
maxErr = max(max(abs(yAbsRecoPlusPhase-y)));
fprintf('max error (yAbsRecoPlusPhase-y) %g\n',maxErr);
% reconstruct istft
[xReco, tRec] = istft(yAbsRecoPlusPhase, h, nfft, fs);
xReco = xReco(:);
xReco = xReco/max(abs(xReco(:))) * nrm_factor;
[xReco,x] = trncxy(xReco,x);

win_len = nfft/4;
xReco_t = trim_edges(xReco, win_len);
x_t = trim_edges(x, win_len);

maxErr = max(max(abs(x_t-xReco_t)));
fprintf('max error (x-xReco) %g\n',maxErr);

figure('units','normalized','outerposition',[0 0 1 1]);
plot(x),hold all;plot(xReco);
legend('original content','reconstructed');
title('reconstruction');

%% play
% soundblocking(x, fs);
% soundblocking(xReco, fs);