function [mag,theta] = orientedFilterMagnitude(im)
filter_wavelength = 2;
filter_angles = [0 10 20 30 40 50 60 70 80 90 100 110 120 130 140 150 160 170];
gaborArray = gabor(filter_wavelength,filter_angles);
%num_filters = length(filter_wavelength) * length(filter_angles);
%[x, y, z] = size(im);
filtered_im = {};
orientation = repmat(filter_angles, length(filter_wavelength), 1).*pi/180;
orientation = orientation(:)';

for i=1:3
    % gaborMag is (x,y,num_filters)
    gaborMag = imgaborfilt(im(:,:,i),gaborArray);
    filtered_im = [filtered_im, gaborMag];
end

mag = sqrt(filtered_im{1}.^2 + filtered_im{2}.^2 + filtered_im{3}.^2);

% for j=1:num_filters
%     [Gmag, orientation(:,:,j)] = imgradient(mag(:,:,j));
% end
[mag,index]= max(mag,[],3);
theta= orientation(index);
end