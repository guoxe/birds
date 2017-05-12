clc;
clear;
load model_weights_27x27_6.mat;%load the model weights
load mask1_2.mat;
load mask2_2.mat;
load mask3_2.mat;
load mask4_2.mat;
load test_data_set.mat;
sz = 31;
x = zeros(1,4);
y = zeros(1,4);
plotIm = false;
plotGraph = false;
plotEKG = true;
errors = zeros(4,length(training_data(:)));
travel = zeros(4,length(training_data(:)));
imagefiles = dir('videos/frames_demo/*.jpg');%generate a list of all the image files
for i=1:length(imagefiles);
    xOld = x;
    yOld = y;
    disp(i);
    im = rgbConvert(imread(strcat('videos/frames_demo/',imagefiles(i).name)),'gray');
    pos_x = training_data(i).positive(:,1);
    pos_y = training_data(i).positive(:,2);
    [x,y] = localize(im,mask1,mask2,mask3,mask4,B,sz);
    err = zeros(1,4);
    trav = zeros(1,4);
    for j=1:4;
        travelDist = abs([x(j) y(j)] - [xOld(j) yOld(j)]);
        dist = abs([pos_x(j) pos_y(j)] - [x(j) y(j)]);
        err(j) = norm(dist);
        trav(j) = norm(travelDist);
    end
    travel(:,i) = trav;
    errors(:,i) = err;
    % Plot image with ground truth and classifier result if plotIm is set
    % to true.
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
if (plotGraph)
    xp = 1:length(imagefiles);
    figure;
    plot(xp,errors(1,:), 'b');
    hold on;
    plot(xp,errors(2,:), 'r');
    plot(xp,errors(3,:), 'g');
    plot(xp,errors(4,:), 'y');
    title('Graph of errors');
    xlabel('Image');
    ylabel('Error');
    legend('cage 1', 'cage 2', 'cage 3', 'cage 4');
end;
if (plotEKG)
    xp = 1:length(imagefiles)-1;
    figure;
    subplot(2,2,1);
    plot(xp, travel(1,2:length(imagefiles)-1), 'r');
    xlabel('Image');
    ylabel('Distance(px)');
    axis([0 80 0 80]);
    title('Cage 1');
    subplot(2,2,2);
    plot(xp, travel(2,2:length(imagefiles)-1), 'r');
    xlabel('Image');
    ylabel('Distance(px)');
    axis([0 80 0 80]);
    title('Cage 2');
    subplot(2,2,3);
    plot(xp, travel(3,2:length(imagefiles)-1), 'r');
    xlabel('Image');
    ylabel('Distance(px)');
    axis([0 80 0 80]);
    title('Cage 3');
    subplot(2,2,4);
    plot(xp, travel(4,2:length(imagefiles)-1), 'r');
    xlabel('Image');
    ylabel('Distance(px)');
    axis([0 80 0 80]);
    title('Cage 4');
end;

