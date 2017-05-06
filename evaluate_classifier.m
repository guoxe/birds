clc;
clear;
load model_weights_30x30_6.mat;%load the model weights
load mask1.mat;
load mask2.mat;
load mask3.mat;
load mask4.mat;
load test_data_eval.mat;
sz = 29;
errors = zeros(4,length(training_data(:)));

for i=1:length(training_data(:));
    im = rgbConvert(imread(strcat('videos/frames/',training_data(i).imfile)),'gray');
    pos_x = training_data(i).positive(:,1);
    pos_y = training_data(i).positive(:,2);
    [x,y] = localize(im,mask1,mask2,mask3,mask4,B,sz);
    err = zeros(1,4);
    for j=1:4
        dist = abs([pos_x(j) pos_y(j)] - [x(j) y(j)]);
        err(j) = norm(dist);
    end
    errors(:,i) = err;
end
fprintf('The average error is: %fpx\n', mean(errors(:)));

%% print images that were misclassified
for i=1:length(predictions(:))
    yhat = predictions(i).y;
    if (abs(yhat - Y(i)) >= 0.3)
        continue;
    end
    imshow(predictions(i).image);
    title(sprintf('Expected: %d Actual: %d', Y(i), yhat));
    waitforbuttonpress();
end
