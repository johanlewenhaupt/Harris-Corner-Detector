%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  function  [interest_points descriptors] = patch_descriptor(I, Corners, dsize)
%  purpose :    Calculate the patch descriptor around each corner
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  input   arguments
%     I:              Input grayscale image, value range: 0-1
%     Corners:        n x 3 matrix containing all detected corners. Every
%                     row vector represents a corner with the elements
%                     [y, x, d] (d is the result of the harris calculation)
%     dsize:          Scalar value defining the width and height of the
%                     patch around each corner to consider for the
%                     descriptor.
%
%  output   arguments
%     interest_points: k x 2 matrix containing the image coordinates [y,x]
%                     of the corners. Corners too close to the image
%                     boundary to cut out the image patch should not be
%                     contained.
%     descriptors:    k x dsize^2 matrix containing the patch descriptors.
%                     Each row vector stores the concatenated column
%                     vectors of the image patch around each corner.
%                     Corners too close to the image boundary to cut out
%                     the image patch should not be contained. 
%
%   Author: Johan Lewenhaupt
%   MatrNr: 1624242
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [interest_points, descriptors] = patch_descriptor(I, Corners, dsize)

[rows, cols] = size(I);
interest_points = []; descriptors = [];
test = floor(dsize/2);
up = ceil(dsize/2);

%find surrounding pixels
SIZE=size(I);
LENGTH=length(SIZE);
[c1{1:LENGTH}]=ndgrid(1:dsize);
c2(1:LENGTH)={up};
offsets=sub2ind(SIZE,c1{:}) - sub2ind(SIZE,c2{:});

for i = 1:size(Corners,1)
    if (Corners(i,1)-test>=1) && (Corners(i, 1)+test<=rows) && (Corners(i,2)-test>=1) && (Corners(i,2)+test<=cols)
        interest_points = [interest_points; Corners(i, 1) Corners(i, 2)];
        j = sub2ind(size(I),Corners(i, 1), Corners(i, 2));
        pixel_matrix = I(j+offsets); pixel_array = pixel_matrix(:);
        descriptors = [descriptors; pixel_array'];
    end
end
end