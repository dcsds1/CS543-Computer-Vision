function T = align_shape(im1, im2)
iteration = 10;

tic;

% According to the equation given in class,
% we first compute the initial transformation

% x and y indices of on-zero points in im1 and im2
[row1, col1] = find(im1); 
[row2, col2] = find(im2); 

% mean of x and y indices in im1 and im2
mean1 = [mean(row1), mean(col1)]; 
mean2 = [mean(row2), mean(col2)]; 

% standard deviation of x and y indices in im1 and im2
delta1 = [std(row1), std(col1)]; 
delta2 = [std(row2), std(col2)];

% initial transformation (using the equation given in class)
T = [1, 0, mean2(1); 0, 1, mean2(2); 0, 0, 1] * ...
    [delta2(1), 0, 0; 0, delta2(2), 0; 0, 0, 1] * ...
    [1/delta1(1), 0, 0; 0, 1/delta1(2), 0; 0, 0, 1] * ...
    [1, 0, -mean1(1); 0, 1, -mean1(2); 0, 0, 1];
T = T(1:2, 1:3);

p1 = [row1, col1, ones(size(row1))];
p2 = [row2, col2];

for iter = 1:iteration
    p1_transformed = (T * p1')'; % transform the first image points using T
    im_align = zeros(size(im1));
    
    % change all coordinates less than 1 to 1
    for i = 1:size(p1_transformed, 1)
        ix = round(p1_transformed(i, 1)); 
        iy = round(p1_transformed(i,2));
        if ix>0 && ix<=size(im2,1) && iy>0 && iy<=size(im2,2)
            im_align(ix,iy) = 1;
        end
    end
    
    error = evalAlignment(im_align, im2);
    
    % Search for cloest point
    nnidx = knnsearch(p2, p1_transformed);    
    nnp2 = p2(nnidx, :); % target is the cloest matched points

    % Affine Transformation
    A = zeros(size(p1) * 2);
    for i = 1:size(p1, 1)
        A(2*i-1,1:3) = p1(i,:);
        A(2*i, 4:6) = p1(i,:);
    end
    nnp2 = nnp2';
    b = nnp2(:);
    T = A\b;
    T = reshape(T, [3,2])';
end

t = toc;
fprintf(1,'The runtime is %f second\n',t);
fprintf(1,'The Final Error is %f\n', error);
figure(); imshow(displayAlignment(im1, im2, im_align));
end