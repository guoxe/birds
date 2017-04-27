%% Load training set and use it to train SVM
clear;
clc;
load('training_data_merged.mat');
size = 19;
feature_size = (size+1)^2;
channels = 2;

X = zeros(16*length(training_data(:)), feature_size*channels);
labels = zeros(16,1);
labels(1:4) = 1;
Y = repmat(labels, [length(training_data(:)) 1]);

for i=1:length(training_data(:));
    im = rgbConvert(imread(strcat('videos/frames/',training_data(i).imfile)),'gray');
    pos_boxes = zeros(4,feature_size*channels);
    neg_boxes = zeros(12,feature_size*channels);
    pos_x = training_data(i).positive(:,1);
    pos_y = training_data(i).positive(:,2);
    neg_x = training_data(i).negative(:,1);
    neg_y = training_data(i).negative(:,2);
    for j=1:4;
        I = imcrop(im,'single', [pos_x(j)-20 pos_y(j)-20 size size]);
        x=extract_channels(I,channels,feature_size);
        pos_boxes(j,:) = x;
    end;
    for j=1:12;
        I = imcrop(im,'single', [neg_x(j)-20 neg_y(j)-20 size size]);
        x=extract_channels(I,channels,feature_size);
        neg_boxes(j,:) = x;
    end;

    boxes = [pos_boxes;neg_boxes];
    X((i-1)*16 +1:16*i,:) = boxes;
end;
%fit a logistic model using glmfit
%[B,dev] = glmfit(X, Y, 'binomial');
[B0,FitInfo] = lassoglm(X,Y,'binomial','NumLambda',150,'CV',15, 'link', 'logit', 'Alpha', 0.35);
indx = FitInfo.Index1SE;
B1 = B0(:,indx);
cnst = FitInfo.Intercept(indx);
B = [cnst;B1];
save('model_weights.mat', 'B');
