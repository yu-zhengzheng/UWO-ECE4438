function [g, NR] = regiongrow(f,dI)
%REGIONGROW Image segmentation using region growing.
%   [g,NR] = REGIONGROW(f, dI) where:
%   f is the input uint8 graylevel image,
%   dI is range of intensities about seed value to include in regions -
%   normalized to range [0.0, 1.0],
%   g is the segmented image resulting from region growing, with each
%      region labeled by a different integer,
%   NR is the number of regions,

% Generally not good to have 'close all' in a function, it I did this to
% clean up the desktop
close all

% Best to convert to type double for later subtraction operation
% Gray levels are normalized to range [0.0, 1.0]
f = im2double(f);
figure, imshow(f)
title('Select one point in each filling using the mouse then press RETURN or ENTER')

% Interactively obtain seeds
[seedcol, seedrow, seedrgb]=impixel;
seedgl = seedrgb(:,1);  % Take any column since R=G=B for gray-level images

% Form seed image (call it 'marker' as in morphological reconstruction)
marker = false(size(f));
for K = 1:length(seedgl)
    marker(seedrow(K), seedcol(K)) = true;
end
% You may want to uncomment line below to see what the marker image looks
% like and to debug your code
% figure, imshow(marker), title('Marker Image')

% Form mask image: all pixels that are within dI of seed gray-level values
% Could combine with above loop but separated loops for clarity
mask = false(size(f));
for K = 1:length(seedgl)
   seedgl_cur = seedgl(K);
   % Consider all pixels within +/- dI of normalized seed intensity value
   S = abs(f - seedgl_cur) <= dI; % Re-use variable S.
   mask = mask | S;
end
% You may want to uncomment line below to see what the mask image looks
% like and to debug your code
% figure, imshow(mask), title('Mask Image')

% Use function imreconstruct with SI as the marker image to obtain the
% regions corresponding to each seed in S. Function bwlabel assigns a
% different integer to each connected region.
[g,NR] = bwlabel(imreconstruct(marker,mask));
