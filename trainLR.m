%% Load training set and use it to train SVM
clear;
clc;
load('training_data_merged.mat');
size = 19;
feature_size = (size+1)^2;
channels = 8;
offset = (size+1)/2;

X = zeros(16*length(training_data(:)), feature_size*channels);
labels = zeros(16,1);
labels(1:4) = 1;
Y = repmat(labels, [length(training_data(:)) 1]);

for i=1:length(training_data(:));
    im = rgbConvert(imread(strcat('videos/frames/',training_data(i).imfile)),'gray');
    pos_boxes = zeros(4,feature_size*channels);
    neg_boxes = zeros(12,feature_size*channels);
    pos_x = round(training_data(i).positive(:,1));
    pos_y = round(training_data(i).positive(:,2));
    neg_x = round(training_data(i).negative(:,1));
    neg_y = round(training_data(i).negative(:,2));
    for j=1:4;
        patch = im(pos_y(j)-offset:pos_y(j)+offset-1,pos_x(j)-offset:pos_x(j)+offset-1);
        x=extract_channels(patch,channels,feature_size);
        pos_boxes(j,:) = x;
    end;
    for j=1:12;
        patch = im(neg_y(j)-offset:neg_y(j)+offset-1,neg_x(j)-offset:neg_x(j)+offset-1);
        x=extract_channels(patch,channels,feature_size);
        neg_boxes(j,:) = x; 
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
save('model_weights_20x20_8.mat', 'B');
