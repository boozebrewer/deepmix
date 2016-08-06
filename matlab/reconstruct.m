function reconstruct(bLoadedNoised,mx,mi,ymax,yabs,yphase,h,nfft,fs,y,x)
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
yAbsRecoPlusPhase = yAbsReconst .* exp(1i*yphase);
% check max error
maxErr = max(max(abs(yAbsRecoPlusPhase-y)));
fprintf('max error (yAbsRecoPlusPhase-y) %g\n',maxErr);
% reconstruct istft
[xReco, tRec] = istft(yAbsRecoPlusPhase, h, nfft, fs);
xReco = xReco(:);
xReco = xReco/max(xReco(:)) * 0.9;
[xReco,x] = trncxy(xReco,x);
maxErr = max(max(abs(x-xReco)));
fprintf('max error (x-xReco) %g\n',maxErr);

figure;
plot(x),hold all;plot(xReco);
title('reconstruction');

%% play
soundblocking(x, fs);
soundblocking(xReco, fs);