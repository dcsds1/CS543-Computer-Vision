ge = imread('GeYou.jpeg');
gimage = im2double(rgb2gray(ge));
gimage = gimage(1:480, 1:640, :);
a = {}; % save gaussian pyramid
b = {}; % save laplacian pyramid

figure
ha = tight_subplot(2,5,[.01 .03],[.1 .01],[.01 .01]);
axes(ha(1));
imshow(gimage);
a = [a, gimage];

for i = 2: 5
    % gaussian
    tmp = imgaussfilt(gimage, 2); % smooth
    gimage = tmp(1:2:end, 1:2:end, :); % downsample
    a = [a, gimage];
    axes(ha(i));
    imshow(gimage);
    
    % laplacian
    laimage = zoom(gimage); % upsample
    laimage = imgaussfilt(laimage, 2); % smooth
    laimage = a{i-1}-laimage;
    b = [b, laimage];
    axes(ha(i+4));
    imshow(mat2gray(laimage));

end

% plotting fft
figure
hb = tight_subplot(2,5,[.01 .03],[.1 .01],[.01 .01]);
axes(hb(1));
f(a{1});
for i = 2:5
   axes(hb(i));
   f(a{i});
   axes(hb(i+4));
   f(b{i-1})
end

function output = zoom(img)
[r,c] = size(img);
output = zeros(2*r,2*c); 
for x = 1:r 
    for y = 1:c
        j = 2*(x-1) + 1; 
        i = 2*(y-1) + 1; 
        output(j,i) = img(x,y); %// Top-left
        output(j+1,i) = img(x,y); %// Bottom-left
        output(j,i+1) = img(x,y); %// Top-right
        output(j+1,i+1) = img(x,y); %// Bottom-right
    end
end
end

function f(i)
    fg = fft2(i);
    fg = fftshift(fg);
    fftimpow = log(abs(fg+eps));
    sv = sort(fftimpow(:));  
    minv = sv(round(0.005*numel(sv)));  maxv = sv(round(0.999*numel(sv)));
    imagesc(fftimpow, [minv maxv]), colormap jet, axis image
    colorbar
end