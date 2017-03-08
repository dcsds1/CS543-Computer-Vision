function [keyXs, keyYs] = getKeypoints(im, tau)
%im = im2double(imread('hotel.seq0.png'));
%tau = 0.2;
    %im = im2double(im);
    K = 0.04;
    org = im;
    
    dx = [-1 0 1; -2 0 2; -1 0 1]; % Sobel Derivatives
    dy = dx';
    
    % 1. Image derivatives
    Ix = conv2(im, dx, 'same');    
    Iy = conv2(im, dy, 'same');  
    
    % 2. Square of derivatives
    Ix2 = Ix .^ 2;
    Iy2 = Iy .^ 2;
    Ixy = Ix .* Iy;
    
    % 3. Gaussian filter
    G = fspecial('gaussian',[3 3],2).*100;
    Ix2 = imfilter(Ix2, G, 'same');
    Iy2 = imfilter(Iy2, G, 'same');
    Ixy = imfilter(Ixy, G, 'same');
    
    % 4. Cornerness function: compute response at each pixel
    har = ((Ix2.*Iy2) - (Ixy.^2) - K*(Ix2+Iy2).^2);
    pixels = zeros(size(im));
    [h, w] = size(im);
    for i = 1:h
        for j = 1:w
            if har(i, j) < tau
                pixels(i, j) = 0;
            else
                pixels(i, j) = har(i, j);
            end
        end
    end

    % 5. Non-maxima suppression (5 * 5)
    radius = 2;
    sze = 2*radius + 1;
    % find the largest element in a 5*5 window
    mx = ordfilt2(pixels, sze^2, ones(sze)); 
    output = (har == mx);
    
    [keyXs, keyYs] = find(output);
    
    figure, imshow(org),
    hold on;
    plot(keyYs, keyXs, 'g.', 'linewidth', 3);
    hold off;
end