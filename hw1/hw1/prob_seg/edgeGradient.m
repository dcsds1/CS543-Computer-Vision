function bmap=edgeGradient(im)
[mag, theta] = gradientMagnitude(im,2.5);
%bmap= edge(rgb2gray(im), 'canny').*mag;
% size(mag)
% size(theta)
bmap = nonmax(mag,theta);
end