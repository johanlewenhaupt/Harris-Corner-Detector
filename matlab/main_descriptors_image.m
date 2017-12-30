%===================================================
% Machine Vision and Cognitive Robotics (376.054)
% Exercise 2a: Harris Corners
% Daniel Wolf, 2015
% Automation & Control Institute, TU Wien
%
% Tutors: machinevision@acin.tuwien.ac.at
%===================================================

figure(1), clf

% read images
IgrayA = rgb2gray(imread('desk/Image-00.jpg'));
IgrayB = rgb2gray(imread('desk/Image-01.jpg'));

% parameters <<< try different settings!
harris.sigma1 = 0.8;
harris.sigma2 = 1.5;
harris.threshold = 0.05;
harris.k = 0.04;
descriptor_window_size = 5;

% Harris corner detector
[ I, Ixx, Iyy, Ixy, Gxx, Gyy, Gxy, Hdense, Hnonmax, Corners] = harris_corner(IgrayA, harris);
% Create descriptors
[interest_pointsA descriptorsA] = patch_descriptor(I, Corners, descriptor_window_size);

% Harris corner detector
[ I, Ixx, Iyy, Ixy, Gxx, Gyy, Gxy, Hdense, Hnonmax, Corners] = harris_corner(IgrayB, harris);
% Create descriptors
[interest_pointsB descriptorsB] = patch_descriptor(I, Corners, descriptor_window_size);

% Match descriptors
matchesAB = match_descriptors(descriptorsA, descriptorsB);

% Display results
show_matches(IgrayA, IgrayB, interest_pointsA, interest_pointsB, matchesAB)

drawnow();
