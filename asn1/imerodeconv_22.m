function C=imerodeconv_22(A,SE)
    %Performs binary erosion using convolution for structuring elements
    %that are all ones
    C = filter2(SE,A,'same')==sum(sum(SE));