%% Load training set and use it to train SVM
load('training_data_final.mat');
size = 39;

%x = [training_data(1).positive(1:4)];
%y = [training_data(1).positive(5:8)];
im = imread(strcat('videos/frames/',training_data(1).imfile));
im = im(:,:,1);
%figure;
%imshow(im);
%b = imcrop(im, 'single', [x(1)-20 y(1)-20 size size]);
%figure;
%imshow(b);

%xb = reshape(b, 1,1600);
X = zeros(1, (1600*1600));
%X = [];
y = zeros(1, 1600);
%y = [];
%pos_boxes = [];

for i=1:length(training_data(:));
    pos_boxes = zeros(1,6400);
    pos_x = training_data(i).positive(:,1);
    pos_y = training_data(i).positive(:,2);
    neg_x = training_data(i).negative(:,1);
    neg_y = training_data(i).negative(:,2);    
    for  j=1:4;
        n = ((j-1)*1600) + 1; 
        box = reshape(imcrop(im, 'single', [pos_x(j)-20 pos_y(j)-20 size size]), 1, 1600);
        pos_boxes(n:1600*j) = box; 
    end;
    for j=1:12;
        
    end;
    X((i-1)*6400 + 1 : 6400*i) = pos_boxes;
end;
    