% Clear desktop of figure windows
close all

% Parameters
H = 0.07
SIGMA_FACTOR = 0.02

% Read in image and display
f = imread('liver_cells_gray.tif');
f = im2double(f);
figure, imshow(f), axis off, title('Image of liver cells')

% Smooth image
fs = imgaussfilt(f,SIGMA_FACTOR*size(f,1));
figure, imshow(fs), axis off, title('Image after smoothing')

% Compute gradient
gs = imgradient(fs);
figure, imshow(gs,[]), axis off, title('Gradient magnitude')

% Suppress regional minima 
gsm=imhmin(gs,H);
figure, imshow(gsm,[]), axis off
title('Gradient magnitude after suppression of regional minima')

% Apply watershed segmentation
Lsm=watershed(gsm);
ridgessm = Lsm == 0;
title_str = strcat('Detected watershed lines: H = ', num2str(H),...
    ', SIGMA\_FACTOR = ', num2str(SIGMA_FACTOR))
figure, imshow(ridgessm+f), axis off, title(title_str)
