g = gabor(2,[0 10 20 30 40 50 60 70 80 90 100 110 120 130 140 150 160 170]);
figure;
subplot(3,6,1)
for p = 1:length(g)
    subplot(3,6,p);
    imshow(real(g(p).SpatialKernel),[]);
    %lambda = g(p).Wavelength;
    theta  = g(p).Orientation;
    title(sprintf('theta = %d',theta));
end