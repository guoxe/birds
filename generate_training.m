clc;
clear;
<<<<<<< HEAD
imagefiles = dir('videos/rgb_frames/*.jpg');
fig = figure()
data_idx = 1;
for i=5003:length(imagefiles)                  
    currentfile = imagefiles(i).name;
    imagesc(imread(strcat('videos/rgb_frames/',currentfile)));
=======
imagefiles = dir('videos/frames_demo/*.jpg');
fig = figure()
data_idx = 1;
for i=1:length(imagefiles)                  
    currentfile = imagefiles(i).name;
    imagesc(imread(strcat('videos/frames_demo/',currentfile)));
>>>>>>> 760adb5375559bc6b3932fffe58df143a04f6995
    keydown = waitforbuttonpress();
    if (keydown ~= 0) %skip the image
        k = get(fig, 'CurrentCharacter');
        %disp(k);
        if (strcmp(k,'q') == 1)
            break;
        else
            continue;
        end
    else
       %start by capturing positive examples
        title('Click on the birds for positive examples');
        [x,y] = ginput(4);
        hold on;
        plot(x,y,'*');
        hold off;
        s = struct('positive', [x y], 'imfile', currentfile);
        title('click outside the birds for negative examples');
        [x,y] = ginput(12); %gather negative examples for images
        hold on;
        plot(x,y,'or');
        hold off;
        s.negative = [x y];
        pause(0.5);
        training_data(data_idx) = s;
        data_idx = data_idx + 1;
        disp(data_idx);
    end
end
<<<<<<< HEAD
save('test_data_rgb.mat', 'training_data');
=======
save('test_data_set2.mat', 'training_data');
>>>>>>> 760adb5375559bc6b3932fffe58df143a04f6995
close(fig);