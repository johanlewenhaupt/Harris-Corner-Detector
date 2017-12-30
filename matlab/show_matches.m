function show_matches(Igray, Igray2, Corners, Corners_2, matchesAB)

hold off
[h,w] = size(Igray);
Img = [Igray, Igray2];
imshow(Img); hold on
scatter(Corners(:,1)  ,Corners(:,2), 'xr');
scatter(Corners_2(:,1)+w,Corners_2(:,2), 'xr');

for i = 1:size(matchesAB,1);
    y = [Corners(matchesAB(i,1),2), Corners_2(matchesAB(i,2),2)]; 
    x = [Corners(matchesAB(i,1),1), Corners_2(matchesAB(i,2),1)+w]; 
    plot(x,y, 'g');
end
end