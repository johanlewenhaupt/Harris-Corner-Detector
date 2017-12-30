    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  function  matchesAB = match_descriptors(descriptorsA, descriptorsB)
%  purpose :    Find matches for patch descriptors
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  input   arguments
%     descriptorsA:   patch descriptors of first image. m x n matrix
%                     containing m descriptors of length n
%     descriptorsB:   patch descriptors of second image. m x n matrix
%                     containing m descriptors of length n
%
%  output   arguments
%     matchesAB:      k x 2 matrix representing the k successful matches.
%                     Each row vector contains the indices of the matched
%                     descriptors of the first and the second image.
%
%   Author: Johan Lewenhaupt
%   MatrNr: 1624242
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function matchesAB = match_descriptors(descriptors_1, descriptors_2, Corners, Corners_2)

[rows, cols] = size(descriptors_1);
[rows2, cols2] = size(descriptors_2);

if rows2<rows
    rows = rows2;
end

x1 = descriptors_1;
x2 = descriptors_2;
if size(x1,1)>size(x2,1)
    x2 = descriptors_1;
    x1 = descriptors_2;
end

d = [];

matchesAB = [];
count = [];
x3 = x2;
for i = 1:rows
    count = [];
    mat1 = x1(i,:); mat1 = double(mat1); n1 = norm(mat1);
    for j = 1:rows
        mat2 = x3(j,:); mat2 = double(mat2); n2 = norm(mat2);
        a = abs(n1-n2);
        d = [d; a];
        if a == min(d(:))
            count = [count; j];
        end 
    end
    [d_sort, index] = sort(d);
    d1 = d_sort(1); d2=d_sort(2);
    if d1/d2 < 0.8
        %if abs(Corners(count(end),2)-Corners_2(i,2)) < 20  %another condition
            matchesAB =[matchesAB; count(end), i];
            x3(count(end),:) = [zeros(1, size(x3,2))];  %to make sure we dont match a point twice
        %end
    end
    d = [];
end
end