clc;
clear;
imagefiles = dir('videos/frames_demo/*.jpg');
fig = figure()
data_idx = 1;
for i=1:length(imagefiles)                  
    currentfile = imagefiles(8).name;
    imagesc(imread(strcat('videos/frames_demo/',currentfile)));
    keydown = waitforbuttonpress();
    if (keydown ~= 0) %skip the image
        k = get(fig, 'CurrentCharacter');
        disp(k);
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
save('test_data_set2.mat', 'training_data');
close(fig);