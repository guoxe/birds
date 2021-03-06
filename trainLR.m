%% Load training set and use it to train LR
clear;
clc;
load('training_data_merged.mat');
size = 19;
feature_size = size^2;
channels = 8;

X = zeros(16*length(training_data(:)), feature_size*channels);
labels = zeros(16,1);
labels(1:4) = 1;
Y = repmat(labels, [length(training_data(:)) 1]);

for i=1:length(training_data(:));
    im = rgbConvert(imread(strcat('videos/frames/',training_data(i).imfile)),'gray');
    img_channels = extract_channels(im);
    pos_boxes = zeros(4,feature_size*channels);
    neg_boxes = zeros(12,feature_size*channels);
    pos_x = round(training_data(i).positive(:,1));
    pos_y = round(training_data(i).positive(:,2));
    neg_x = round(training_data(i).negative(:,1));
    neg_y = round(training_data(i).negative(:,2));
    for j=1:4;
        patch = extract_patch(img_channels,pos_y(j),pos_x(j),size);
        pos_boxes(j,:) = patch;
    end;
    for j=1:12;
        patch = extract_patch(img_channels,neg_y(j),neg_x(j),size);
        neg_boxes(j,:) = patch; 
    end;

    boxes = [pos_boxes;neg_boxes];
    X((i-1)*16 +1:16*i,:) = boxes;
end;
%fit a regularized logistic model to our data.
options = statset('UseParallel',true);
[B0, FitInfo] = lassoglm(X,Y,'binomial','NumLambda',100,'CV', 10, 'link','logit','Alpha',0.15,'Options', options);
indx = FitInfo.Index1SE;
B1 = B0(:,indx);
cnst = FitInfo.Intercept(indx);
B = [cnst;B1];
save('model_weights_19x19_8.mat', 'B');
