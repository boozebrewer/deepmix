function savefig_as_jpg(folder)
if nargin==0
    fl='results/jpgs';
    mkdir(fl);
    folder='results';
end
d=dir([folder,'/*.fig']);
for i=1:length(d)
    h= openfig(d(i).name);
    h.PaperPositionMode = 'auto';
    print(fullfile(fl,[d(i).name,'.jpg']),'-dpng','-r300')
%     saveas(h,[d(i).name,'.jpg']);
    close(h);
end