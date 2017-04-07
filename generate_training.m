imagefiles = dir('videos/frames/*.jpg');
for i=1:length(imagefiles)
    currentfile = imagefiles(i).name;
    imagesc(imread(strcat('videos/frames/',currentfile)));
    [x,y] = ginput(4);
end