%===================================================
% Machine Vision and Cognitive Robotics (376.054)
% Exercise 2a: Harris Corners
% Daniel Wolf 2015
% Automation & Control Institute, TU Wien
%
% Tutors: machinevision@acin.tuwien.ac.at
%===================================================
clear all; close all;
figure(1); clf
debug_corners = true;   % <<< change to reduce output when you're done

% read image
Igray = rgb2gray(imread('jag.jpg'));
Igray2 = rgb2gray(imread('jag.jpg')); Igray2 = imresize(Igray2,size(Igray));

% parameters <<< try different settings!
harris.sigma1 = 10;
harris.sigma2 = 2;
harris.threshold = 0.2;
harris.k = 0.04;

%1. Harris corner detector
[I, Ixx, Iyy, Ixy, Gxx, Gyy, Gxy, Hdense, Hnonmax, Corners] = harris_corner(Igray, harris);
%[I_2, Ixx_2, Iyy_2, Ixy_2, Gxx_2, Gyy_2, Gxy_2, Hdense_2, Hnonmax_2, Corners_2] = harris_corner(Igray2, harris);
% shows detec   ted corners
show_corners(I, Ixx, Iyy, Ixy, Gxx, Gyy, Gxy, Hdense, Hnonmax, Corners, debug_corners);

figure, imshow(I); hold on, plot(Corners(:,1),Corners(:,2),'r.');
%{
%2. Patch descriptors

[interest_points_1, descriptors_1] = patch_descriptor(I, Corners, 5);
[interest_points_2, descriptors_2] = patch_descriptor(I_2, Corners_2, 5);

%3 Match descriptors

[matchesAB] = match_descriptors(descriptors_1, descriptors_2, Corners, Corners_2);

figure, show_matches(I, I_2, Corners, Corners_2, matchesAB)
%}