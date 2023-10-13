%reading the image
im=im2double(imread("cygnusloop.tif"));
%compute feature 1
localmean=filter2(ones(9)/81,im,"same");
%compute feature 2
localstd=stdfilt(im,ones(9));

% figure
% imshow(localmean)
% figure
% imshow(localstd)

f=[localmean(:),localstd(:)];
k=3;
%k-means clustering
[idx,c]=kmeans(f,3);
%reconstruct image
fseg=zeros(size(im));
for i = 1:3,
   fseg(idx==i)=i;
end
%display image
fseg=mat2gray(fseg);
figure, imshow(fseg), axis off
