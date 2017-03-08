fprintf('object2 - object2t:\n')
T1 = align_shape(imread('object2.png')>0, imread('object2t.png')>0);
title('object2 - object2t');

fprintf('\nobject2 - object1:\n')
T2 = align_shape(imread('object2.png')>0, imread('object1.png')>0);
title('object2 - object1');

fprintf('\nobject2 - object3:\n')
T3 = align_shape(imread('object2.png')>0, imread('object3.png')>0);
title('object2 - object3');
