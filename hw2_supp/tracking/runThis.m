IMG_DIR = './images/';
IMG_PREFIX = 'hotel.seq';

% Keypoint Selection
im = im2double(imread('hotel.seq0.png'));
[keyXs,keyYs] = getKeypoints (im, 0.5);
title('Detected Keypoints');

keypoints_num = length(keyXs);

lost_points = zeros(keypoints_num, 1);
translationX = zeros(keypoints_num, 51);
translationX(:,1) = keyXs;
translationY = zeros(keypoints_num, 51);
translationY(:,1) = keyYs;
initXs = keyXs;
initYs = keyYs;

% Track keypoints through all the frames
fprintf('Calculating trajectory\n');
for i = 1 : 50
    % read 2 frames from file
    im0_ = fullfile(IMG_DIR, [IMG_PREFIX, sprintf('%d.png', i - 1)]);
    im1_ = fullfile(IMG_DIR, [IMG_PREFIX, sprintf('%d.png', i)]);
    
    im0 = im2double(imread(im0_));
    im1 = im2double(imread(im1_));
    
    [newXs, newYs] = predictTranslationAll(initXs,initYs,im0,im1);
    lost_points = lost_points | (newXs == 0);
    translationX(:,i+1) = newXs;
    translationY(:,i+1) = newYs;
    initXs = newXs;
    initYs = newYs;
end

% Pick 20 keypoints to draw the 2D path
valid_points = find(1-lost_points);
rand_idx = randi([1,length(valid_points)],1,20);
rand_idx = valid_points(rand_idx);

% draw the 2D path
figure;
imshow(im);
title('Path');
hold on;
for i = 1:51
    X = translationX(rand_idx,i);
    Y = translationY(rand_idx,i);
    plot(X, Y, 'g.','linewidth',3);
end

% draw the points that move out of frame
figure;
imshow(im);
title('Points moved out of frame');
hold on;
fprintf('start to print lost points\n');
for j= 1:51
    X = translationX(lost_points,j);
    Y = translationY(lost_points,j);
    ptr = (X>0)&(Y>0);
    plot(X(ptr),Y(ptr),'g.','linewidth',3);
end