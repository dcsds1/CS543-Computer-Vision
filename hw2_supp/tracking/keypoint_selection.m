im = imread('hotel.seq0.png');
%im = im2double(im);

%create a mask for detecting the vertical/horizontal edges
verticalMask = [-1 0 1;-2 0 2;-1 0 1]*0.25;
horizontalMask = [-1 -2 -1;0 0 0;1 2 1]*0.25;

%Create a mask for Gaussian filter(used to improve the result)
gaussianFilter = [1 4 1;4 7 4;1 4 1].*(1/27);

%The sensitivity factor used in the Hariis detection algorithm for sharp
%corners
K = 0.04;

%get the gradient of the image [Ix, Iy]
Ix = conv2(im,verticalMask);
Iy = conv2(im,horizontalMask);

%get the input arguments of the harris formula
Ix2 = Ix.*Ix;
Iy2 = Iy.*Iy;
Ixy = Ix.*Iy;

%apply the gaussian filter to the arguments
Ix2 = conv2(Ix2,gaussianFilter);
Iy2 = conv2(Iy2,gaussianFilter);
Ixy = conv2(Ixy,gaussianFilter);

%Enter the arguments into the formula
C = (Ix2.*Iy2) - (Ixy.^2) - K*(Ix2+Iy2).^2;

thresh = 200;
radius = 2;
sze = 2*radius + 1;
mx = ordfilt2(C, sze^2, ones(sze));

%make mask to exclude points on borders
bordermask = zeros(size(C));
bordermask(radius + 1: end - radius, radius + 1: end - radius) = 1;

%Find Maxima, threshold, and apply bordermask
cimmx = (C == mx) & (C > thresh) & bordermask;
[r, c] = find(cimmx);

figure, imshow(im),
hold on;
plot(c, r, '+');
hold off;

