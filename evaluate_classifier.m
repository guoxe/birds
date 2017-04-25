clc;
clear;
load model_weights.mat;
load test_data_eval.mat;
size=39;
channels=3;
feature_size=1600;
labels = zeros(16,1);
labels(1:4)=1;
Y = repmat(labels, [length(training_data(:)) 1]); %generate the correct class labels, 1 is bird
Yhat = zeros(16*length(training_data(:)),1);

for i=1:length(training_data(:));
    im = rgbConvert(imread(strcat('videos/frames/',training_data(i).imfile)),'gray');
    pos_labels = zeros(4,1);
    neg_labels = zeros(12,1);
    pos_x = training_data(i).positive(:,1);
    pos_y = training_data(i).positive(:,2);
    neg_x = training_data(i).negative(:,1);
    neg_y = training_data(i).negative(:,2);
    for j=1:4;
        I = imcrop(im,'single', [pos_x(j)-20 pos_y(j)-20 size size]);
        x=extract_channels(I,channels,feature_size);
        pos_labels(j) = glmval(B,x,'logit');
    end;
    for j=1:12;
        I = imcrop(im,'single', [neg_x(j)-20 neg_y(j)-20 size size]);
        x=extract_channels(I,channels,feature_size);
        neg_labels(j) = glmval(B,x,'logit');
    end;
    Yhat((i-1)*16 +1:16*i,1) = [pos_labels;neg_labels];
end
Yhat = round(Yhat);
wrong_predictions = length(find(Y-Yhat ~= 0));
fprintf('Accuracy: %f\n', (length(Y)-wrong_predictions)/length(Y));