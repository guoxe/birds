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
im = imread(strcat('videos/frames/',training_data(1).imfile));
%im = im2double(rgbConvert(imread(strcat('videos/frames/',training_data(i).imfile)),'gray'));

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

%% region of interest experimentation
load training_data_merged.mat;
im = imread(strcat('videos/frames/',training_data(1).imfile));
    imshow(im);
    h = imellipse;
    position = wait(h);
   