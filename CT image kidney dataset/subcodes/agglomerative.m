function [mean,Std,Skew,area,peri,compact,smoothness,uniformity,entropy,correlation]=agglomerative(biggestBlob)

mean=mean2(biggestBlob);
Std=std2(biggestBlob);
      Skew=skewness(biggestBlob);
      bwp=edge(biggestBlob,'sobel');
      area=sum(sum(biggestBlob));
      peri=sum(sum(bwp));
      compact=peri^2/area;
      smoothness=1/(1+Std^2);
      nh=biggestBlob/area;
      uniformity=sum(nh.^2);
      entropy=sum(nh.*log10(nh));
      correlation=sum(nh'*biggestBlob)-mean/Std;