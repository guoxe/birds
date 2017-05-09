clc;
clear;
load model_weights_31x31_6.mat;%load the model weights
load mask1_2.mat;
load mask2_2.mat;
load mask3_2.mat;
load mask4_2.mat;
load test_data_set.mat;
sz = 31;
plotIm = true;
errors = zeros(4,length(training_data(:)));
pointsX = [];
pointsY = [];
imagefiles = dir('videos/frames_demo/*.jpg');%generate a list of all the image files
for i=1:length(imagefiles);
    im = rgbConvert(imread(strcat('videos/frames_demo/',imagefiles(i).name)),'gray');
    pos_x = training_data(i).positive(:,1);
    pos_y = training_data(i).positive(:,2);
    [x,y] = localize(im,mask1,mask2,mask3,mask4,B,sz);
    err = zeros(1,4);
    for j=1:4;
        dist = abs([pos_x(j) pos_y(j)] - [x(j) y(j)])
        err(j) = norm(dist);
    end
    errors(:,i) = err;
    % Plot image with ground truth and classifier result.
    if (plotIm)
        fig = figure;
        imshow(im);
        set(gca,'position',[0 0 1 1],'units','normalized');
        hold on;
        for k=1:4;
            plot(pos_x(k, 1), pos_y(k, 1), 'b+', 'Markersize', 4);
            plot(x(k, 1), y(k, 1), 'r+', 'Markersize',4);
        end;
        fname = sprintf('image%d', i);
        print(fig, fname, '-djpeg');
        close all;
    end;
end;
fprintf('The average error is: %fpx\n', mean(errors(:)));
