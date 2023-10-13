im=rgb2gray(imread("1.jpg"));
subplot(2,2,1)
imshow(im)
%compute edge map
edgemap=edge(im,'sobel',0.15,'nothinning');
subplot(2,2,2)
imshow(edgemap)
%hough transform
[accumulator, thetaV, rhoV] = hough(edgemap,'rhoResolution', 2, 'thetaResolution', 0.5);
subplot(2,2,3)
imshow(imadjust(mat2gray(accumulator)), 'XData', thetaV,'YData', rhoV)
daspect('auto')
xlabel('\theta')
ylabel('\rho')
%finding peaks
peaks = houghpeaks(accumulator,12,'Threshold',0.25*max(accumulator(:)),'NHoodsize',[5 5],'Theta',thetaV);
hold on
plot(round(thetaV(peaks(:,2))), rhoV(peaks(:,1)), 's', 'color', 'red')
hold off
subplot(2,2,4)
imshow(im)
%finding the lines corresponding to peaks
lines = houghlines(edgemap, thetaV, rhoV, peaks, 'FillGap', 25);
hold on
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1), xy(:,2), 'linewidth', 3, 'color', 'y')
end