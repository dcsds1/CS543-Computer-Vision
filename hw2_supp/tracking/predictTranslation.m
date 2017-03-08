function [newX, newY] = predictTranslation(startX,startY,Ix,Iy,im0,im1)
% for a single point, use the gradients and im to compute the new location

% 15 * 15 pixel window
W = [sum(sum(Ix.*Ix)),sum(sum(Ix.*Iy));sum(sum(Ix.*Iy)),sum(sum(Iy.*Iy))];
radius = 7;

% compute the indices
[x, y] = meshgrid(startX - radius:startX +radius, startY - radius: startY + radius);
I_ = interp2(im0, x, y,'*linear');
It = interp2(im1, x, y,'*linear') - I_;

for i = 1:5
    % make sure the point is within the range of the image
    if startX - radius < 0 || startX + radius > size(im0,2) || ...
            startY - radius < 0 || startY + radius > size(im0,1)
        break
    end
    
    % estimate (u,v) according to the equation
    m = -1 * [sum(sum(Ix.*It));sum(sum(Iy.*It))];
    uv = W\m;
    % update (x,y)
    startX = startX+ uv(1);
    startY = startY + uv(2);
    
    % stop when the error is smaller than a threshold
    if norm(uv) < 0.1
        break;
    end
    
    % update It
    [x,y] = meshgrid(startX - radius:startX +radius, startY - radius: startY + radius);
    It = interp2 ( im1, x, y,'*linear') - I_;
    
end
newX = startX;
newY = startY;
end
    
    


