function [newXs , newYs] = predictTranslationAll(startXs,startYs,im0,im1)
% cpmpute Ix, Iy, then compute translation for each keypoint

% compute gradients first
[Ix, Iy] = gradient(im0);
newXs = startXs;
newYs = startYs;
radius = 7;
for i = 1: length(startXs)
    startX = startXs(i);
    startY = startYs(i);
    % check if points in range
    if(startX - 7)<= 0 || (startX + 7)> size(im0,2)|| ...
            (startY - 7)<= 0||(startY+7)>size(im0,1)
        newXs(i) = 0;
        newYs(i) = 0;
    else    
        % for computing I when (x,y,u,v) are not integers
        [x,y] = meshgrid(startX - radius: startX + radius, startY - radius: startY + radius);
        Ix_ = interp2(Ix, x, y,'*linear');
        Iy_ = interp2(Iy, x, y,'*linear');

        % then compute translation for each keypoint
        [x, y] = predictTranslation(startX,startY,Ix_,Iy_,im0,im1);
        newXs(i) = x;
        newYs(i) = y;
    end
end
end
