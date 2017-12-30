%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  function  [ I, Ixx, Iyy, Ixy, Gxx, Gyy, Gxy, Hdense, Hnonmax, Corners] = 
%                                                            harris_corner(Igray, parameters )
%  purpose :    Harris Corner Detector
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  input   arguments
%     Igray:          grayscale input image, value range: 0-255
%       parameters:     struct containing the following elements:
%		parameters.sigma1: sigma for the first Gaussian filtering
%		parameters.sigma2: sigma for the second Gaussian filtering
%       parameters.k: coefficient for harris formula
%       parameters.threshold: corner threshold
%
%  output   arguments
%     I:              grayscale input image, value range: 0-1
%     Ixx:            squared input image filtered with derivative of gaussian in
%                     x-direction
%     Iyy:            squared input image filtered with derivative of gaussian in
%                     y-direction
%     Ixy:            Multiplication of input image filtered with
%                     derivative of gaussian in x- and y-direction
%     Gxx:            Ixx filtered by larger gaussian
%     Gyy:            Iyy filtered by larger gaussian
%     Gxy:            Ixy filtered by larger gaussian
%     Hdense:         Result of harris calculation for every pixel. Array
%                     of same size as input image. Values normalized to 0-1
%     Hnonmax:        Binary mask of non-maxima suppression. Array of same
%                     size as input image. 1 where values are NOT
%                     suppressed, 0 where they are.
%     Corners:        n x 3 matrix containing all detected corners after
%                     thresholding and non-maxima suppression. Every row
%                     vector represents a corner with the elements
%                     [y, x, d] (d is the result of the harris calculation)
%
%   Author: Johan Lewenhaupt
%   MatrNr: 1624242
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [I, Ixx, Iyy, Ixy, Gxx, Gyy, Gxy, Hdense, Hnonmax, Corners] = harris_corner(Image, parameters)
I = double(Image); 
M = max(I(:)); I= I./M;

kernel_width = 2 * round(3 * parameters.sigma1) + 1;
h = fspecial('gaussian', [kernel_width kernel_width], parameters.sigma2);
h_horizontal = [-1 0 1; -1 0 1; -1 0 1]; h_vertical = [1 1 1; 0 0 0; -1 -1 -1];

Ix = conv2(I, h_horizontal,'same');    Ixx = Ix.^2;
Iy = conv2(I, h_vertical,'same');  Iyy = Iy.^2;
Ixy = Ix.*Iy;

Gxx = conv2(Ixx, h,'same');
Gyy = conv2(Iyy, h,'same');
Gxy = conv2(Ixy, h,'same');

[r, c] = size(I); Hdense = zeros(r, c);

Hdense = (Gxx.*Gyy-Gxy.^2)-parameters.k*(Gxx+Gyy).^2;
M_Hdense = max(Hdense(:));
Hdense = Hdense./M_Hdense;

[r, c] = size(Gxy); Hnonmax = zeros(r, c);
for i = 2:r-1
    for j = 2:c-1
        if Hdense(i,j) > parameters.threshold && Hdense(i,j) > Hdense(i-1,j-1) && Hdense(i,j) > Hdense(i-1,j) && Hdense(i,j) > Hdense(i-1,j+1) && Hdense(i,j) > Hdense(i,j-1) && Hdense(i,j) > Hdense(i,j+1) && Hdense(i,j) > Hdense(i+1,j-1) && Hdense(i,j) > Hdense(i+1,j) && Hdense(i,j) > Hdense(i+1,j+1)
            Hnonmax(i,j) = 1;
        end
    end
end

[cols, rows] = find(Hnonmax == 1);

d = zeros(size(rows)); 
for k = 1:d
    d(k) = Hdense(rows(k),cols(k));
end


Corners = [rows, cols, d];
end

