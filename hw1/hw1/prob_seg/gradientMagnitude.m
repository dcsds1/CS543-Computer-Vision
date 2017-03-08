function [mag, theta] = gradientMagnitude(im, sigma)
im = imgaussfilt(im, sigma);
[x,y,z]=size(im);
c = cell(3,2); % 3 channels, each has a mag and a dir
for channel = 1: 3
    imc = im(:,:,channel);
    [Gx, Gy] = imgradientxy(imc);
    c{channel, 1} = sqrt(Gx.^2 + Gy.^2); % gradient for each channel
    c{channel, 2} = atan2(-Gy, Gx); % orientation for each channel
end

% calculating the orientation
theta = zeros(x, y);
for row = 1:x
    for col = 1:y
        [m, i] = max([c{1, 1}(row, col), c{2, 1}(row, col), c{3, 1}(row, col)]);
        theta(row, col) = c{i, 2}(row, col);
    end
end

% calculating the gradient
mag = sqrt(c{1, 1}.^2 + c{2, 1}.^2 + c{3, 1}.^2);
end
