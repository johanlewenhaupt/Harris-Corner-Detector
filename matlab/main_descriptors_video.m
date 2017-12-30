%===================================================
% Machine Vision and Cognitive Robotics (376.054)
% Exercise 2: Image Descriptor with Harris Corners
% Daniel Wolf 2015
% Automation & Control Institute, TU Wien
%
% Tutors: machinevision@acin.tuwien.ac.at
%===================================================

figure(1), clf;

%check the supported formats and driver first

% UNCOMMENT THE FOLLOWING LINES IF YOU'RE USING WINDOWS
%windows 
%info = imaqhwinfo('winvideo', 1);
%info.SupportedFormats'
%vid = videoinput('winvideo', 1, 'YUYV_640x480');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% COMMENT THE FOLLOWING LINES OUT IF YOU'RE USING WINDOWS
%linux
info = imaqhwinfo('linuxvideo', 1);
info.SupportedFormats'
vid = videoinput('linuxvideo', 1, 'YUYV_640x480');  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Isrc = getsnapshot(vid);
IgrayA = rgb2gray(ycbcr2rgb(Isrc));  % check the format 

% parameters <<< try different settings!
harris.sigma1 = 0.8;
harris.sigma2 = 1.5;
harris.threshold = 0.05;
harris.k = 0.04;
descriptor_window_size = 5;

% Harris corner detector
[ I, Ixx, Iyy, Ixy, Gxx, Gyy, Gxy, Hdense, Hnonmax, Corners] = harris_corner(IgrayA, harris);
% Create descriptors
[interest_points_A descriptorsA] = patch_descriptor(I, Corners, descriptor_window_size);

% Add exit button to figure
H = uicontrol('Style', 'PushButton',  'String', 'Exit',  'Callback', 'delete(gcbf)');

while ishandle(H)

    Isrc = getsnapshot(vid);
    IgrayB = rgb2gray(ycbcr2rgb(Isrc));
    
    % Harris corner detector
    [ I, Ixx, Iyy, Ixy, Gxx, Gyy, Gxy, Hdense, Hnonmax, Corners] = harris_corner(IgrayB, harris);
    % Create descriptor
    [interest_points_B descriptorsB] = patch_descriptor(I, Corners, descriptor_window_size);

    % Match descriptors
    matchesAB = match_descriptors(descriptorsA, descriptorsB);

    % Display results
    show_matches(IgrayA, IgrayB, interest_points_A, interest_points_B, matchesAB)

end;

delete(vid);
