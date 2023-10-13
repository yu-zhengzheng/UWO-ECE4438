function thres = otsu_22(im)
    %compute histogram
    [H,D]=imhist(im);
    %normalize histogram
    H=H/sum(H);
    D=D/255;
    
    P1=cumsum(H);
    m=cumsum(H.*D);%is this really the average intensity though???
    mG=sum(H.*D);
    %compute between-class variance
    for k=1:256
        if (P1(k)==0|P1(k)==1)
            var(k)=0;
        else var(k)=((mG*P1(k)-m(k)).^2)/(P1(k)*(1-P1(k)));
        end
    end    
    
    %stem(D,var')
    %find the maximum
    maxVar=max(var);
    %computing the threshold
    thres=sum(sum(D.*(var==maxVar)'))/sum(var==maxVar);