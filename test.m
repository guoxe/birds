%% testing some channel features;
clear;
clc;
I=rgbConvert(imread('videos/frames/scene07576.jpg'), 'gray');
[Gx,Gy]=gradient2(I);
M=sqrt(Gx.^2+Gy.^2);
O=atan2(Gy,Gx);
full=0;
[M1,O1]=gradientMag(I,0,0,0,full);
D=abs(M-M1); 
mean2(D), if(full), o=pi*2; else o=pi; end;
D=abs(O-O1);
D(~M)=0;
D(D>o*.99)=o-D(D>o*.99);
mean2(abs(D));
H1=gradientHist(M1,O1,1,6,0);
figure(1);
montage2(H1);
%H2=gradientHist(M1,O1,2,6,1);
%figure(2);
%montage2(H2);

%% begin experimentation with loading image data
clear;
clc;
load training_data_2017_04_18.mat;
im = imread(strcat('videos/frames/',training_data(1).imfile));
I=im(:,:,1);%same value in all 3 channels so we dont have to convert
x = round(training_data(1).positive(1:4));
y = round(training_data(1).positive(5:8));
%cut out a 20x20 frame around a positive example
b=imcrop(I,'single', [x(1)-20 y(1)-20 39 39]);
%plot the image with first positive example coordinates
imshow(I);
hold on;
plot([x(1)-20 x(1)-20 x(1)+20 x(1) + 20], [y(1) - 20 y(1) + 20 y(1) - 20 y(1) + 20], '*r');
hold off;
figure();
imshow(b);

%%
clear;
clc;
load training_data_merged.mat;
for i=1:size(training_data,2)
    imshow(strcat('videos/frames/',training_data(i).imfile));
    fprintf('element number: %d\n', i);
    hold on;
    pos_x = training_data(i).positive(:,1);
    pos_y = training_data(i).positive(:,2);
    neg_x = training_data(i).negative(:,1);
    neg_y = training_data(i).negative(:,2);
    plot(pos_x, pos_y, '*r');
    plot(neg_x, neg_y, 'ob');
    hold off;
    keydown=waitforbuttonpress();
end

%% test glmfit
clear;
clc;
load training_data_clean.mat;
im = imread(strcat('videos/frames/',training_data(1).imfile));
I=im(:,:,1);%same value in all 3 channels so we dont have to convert
x = round(training_data(1).positive(1:4));
y = round(training_data(1).positive(5:8));
%cut out a 20x20 frame around a positive example
b=imcrop(I,'single', [x(1)-20 y(1)-20 39 39]);
b = reshape(b, [1 1600]);
b = im2double(b);
b = (b-mean(b)) ./ std(b);
c = imcrop(I, 'single', [x(2) - 20 y(2) - 20 39 39]);
c = reshape(c, [1 1600]);
c = im2double(c);
c = (c-mean(c)) ./ std(c);
X = [b c];
Y = ones([1 2]);
B = glmfit(X, Y, 'binomial', 'link', 'logit');


%% test different channels (entropy)
load training_data_merged.mat;
%im = imread(strcat('videos/frames/',training_data(1).imfile));
im = im2double(rgbConvert(imread(strcat('videos/frames/',training_data(i).imfile)),'gray'));

%I = im(:,:,1);
J = entropyfilt(im);
K = rangefilt(im);
L = stdfilt(im);
figure;
imshow(im);
figure;
imshow(J, []);
figure;
imshow(K);
figure;
imshow(L);
figure;
imshow(M);

%% Gradient testing
load training_data_merged.mat;
%im = imread(strcat('videos/frames/',training_data(1).imfile));
im = rgbConvert(imread(strcat('videos/frames/',training_data(i).imfile)),'gray');

[Gx,Gy]=gradient2(im);
M=sqrt(Gx.^2+Gy.^2);
O=atan2(Gy,Gx);
full=0;
[M1,O1]=gradientMag(im,0,0,0,full);
D=abs(M-M1); 
mean2(D), if(full), o=pi*2; else o=pi; end;
D=abs(O-O1);
D(~M)=0;
D(D>o*.99)=o-D(D>o*.99);
mean2(abs(D));
H1=gradientHist(M1,O1,1,6,0);
figure(1);
montage2(H1);
%H2=gradientHist(M1,O1,2,6,1);
%figure(2);
%montage2(H2);


%% testing ROI
clear;
clc;
load training_data_rgb_final.mat;
im = rgbConvert(imread(strcat('videos/rgb_frames/',training_data(1).imfile)),'gray');
figure;
h_im = imshow(im);
set(gca,'position',[0 0 1 1],'units','normalized')

h1 = imellipse;
wait(h1);
mask1 = createMask(h1,h_im);
h2 = imellipse;
wait(h2);
mask2 = createMask(h2,h_im);
h3 = imellipse;
wait(h3)
mask3 = createMask(h3,h_im);
h4 = imellipse;
wait(h4);
mask4 = createMask(h4,h_im);

%new_im1 = bsxfun(@times, im, mask1);
% new_im2 = bsxfun(@times, im, mask2);
% new_im3 = bsxfun(@times, im, mask3);
% new_im4 = bsxfun(@times, im, mask4);


figure;
imshow(new_im1);
set(gca,'position',[0 0 1 1],'units','normalized')
% figure;
% imshow(new_im2);
% figure;
% imshow(new_im3);
% figure;
% imshow(new_im4);

%% gabor testing
clear;
clc;
load training_data_merged.mat;
offset = 20;
im = rgbConvert(imread(strcat('videos/frames/',training_data(1).imfile)),'gray');
pos_x = training_data(1).positive(:,1);
pos_y = training_data(1).positive(:,2);
neg_x = training_data(1).negative(:,1);
neg_y = training_data(1).negative(:,2);
patch = im(pos_y(1)-offset:pos_y(1)+offset-1,pos_x(1)-offset:pos_x(1)+offset-1);
%x=extract_channels(patch,channels,feature_size);


wavelength = 2;
orientation = [0 45 90 135];
g = gabor(wavelength, orientation);

outMag = imgaborfilt(patch,g);

outSize = size(outMag);
outMag = reshape(outMag, [outSize(1:2), 1, outSize(3)]);
figure, montage(outMag, 'DisplayRange', []);

%% image sequencing
clc;
clear;
fps = 8;
imagefiles = dir('videos/demo/*.jpg');%generate a list of all the image files
I = zeros(778, 1125, length(imagefiles));
for i=1:length(imagefiles);
    filename = sprintf('videos/demo/image%d.jpg', i);
    im = rgbConvert(imread(filename),'gray');
    I(:,:,i) = im;
end;
implay(I, fps);

%% testing ekg plot
xp = 1:79;
figure;
subplot(2,2,1);
plot(xp, travel(1,2:80), 'r');
xlabel('Image');
ylabel('Distance(px)');
axis([0 80 0 80]);
title('Cage 1');
subplot(2,2,2);
plot(xp, travel(2,2:80), 'r');
xlabel('Image');
ylabel('Distance(px)');
axis([0 80 0 80]);
title('Cage 2');
subplot(2,2,3);
plot(xp, travel(3,2:80), 'r');
xlabel('Image');
ylabel('Distance(px)');
axis([0 80 0 80]);
title('Cage 3');
subplot(2,2,4);
plot(xp, travel(4,2:80), 'r');
xlabel('Image');
ylabel('Distance(px)');
axis([0 80 0 80]);
title('Cage 4');
