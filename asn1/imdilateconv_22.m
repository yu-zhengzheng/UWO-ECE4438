function C=imdilateconv_22(A,SE)
    %Performs binary dilation using convolution
    C = filter2(SE,A,'same')>0;