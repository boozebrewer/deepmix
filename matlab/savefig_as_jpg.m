function savefig_as_jpg(folder)
if nargin==0
    folder=pwd;
end
d=dir([folder,'/*.fig']);
for i=1:length(d)
    h= openfig(d(i).name);
    saveas(h,[d(i).name,'.jpg']);
    close(h);
end