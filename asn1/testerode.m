a=imread("letterA.tif");
se=ones(9);
ae22=imerodeconv_22(a,se);
ae=imerode(a,se);

%Compare the two images visually
subplot(1,3,1)
imshow(ae22);
subplot(1,3,2)
imshow(ae);
subplot(1,3,3)
imshow(ae22~=ae);

%Compare the two images numerically
if(ae22==ae)
    disp("The two images are identical.")
end

% c=imread("letterC.tif");
% se=ones(41,1);
% ce22=imdilateconv_22(c,se);
% ce=imdilate(c,se);
% 
% %Compare the two images visually
% subplot(1,3,1)
% imshow(ce22);
% subplot(1,3,2)
% imshow(ce);
% subplot(1,3,3)
% imshow(ce22~=ce);
% 
% %Compare the two images numerically
% if(ce22==ce)
%     disp("The two images are identical.")
% end










