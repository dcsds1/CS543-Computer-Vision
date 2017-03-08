function bmap= edgeOrientedFilters(im)
[mag, theta] = orientedFilterMagnitude(im);
mag=mag.^0.7;
%bmap= edge(rgb2gray(im), 'Canny').*mag;
bmap = nonmax(mag,theta);
end