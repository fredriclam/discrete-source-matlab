% Cylinder radius
A = 10;
% Length of cylinder
L = 100;
% Sphere radius
r = 1;
% Percent filled
swissness = 0.2;
% Test number
N = 10;

cylinder_scoring = @(A) score_scm(N,A/2,L,r,swissness,'cylinder');
slab_scoring = @(A) score_scm(N,A,L,r,swissness,'slab');

% test_array = 5:30:305;
% for i = 1:numel(test_array)
%     slab_score(i) = slab_scoring(test_array(i));
% end
% disp(slab_score)
% 
test_array = 10:10:90;
for i = 1:numel(test_array)
    [cylinder_score(i),sites] = cylinder_scoring(test_array(i));
end
disp(cylinder_score)