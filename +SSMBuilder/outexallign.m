function [outlierex]=outexallign(doel,tedoen,whetherScaling)
    %带outlier exclusion的procustes analysis
    % exclusion of outliers
    %[d,Z,transform] = procrustes(X,Y): transfom Y to superimpose on X
    arguments
        doel (:,3)
        tedoen (:,3)
        whetherScaling (1,1) logical = false
    end
    
    [d,tedoen,transform]=procrustes(doel,tedoen,'Scaling',whetherScaling);
    
    for i=1:20
        d=(doel-tedoen);
        distance = sqrt(sum(d.^2, 2));
        M=mean(distance);
        ss=std(distance);
        distance(:,2)=1:length(distance);
        distance=distance(distance(:,1)<M+1.65*ss,:);
        testdoel=doel(distance(:,2),1:3);
        testtedoen=tedoen(distance(:,2),1:3);%筛选出 距离 < mean+1.65std范围内的点，将其余的视为outlier。接下来只配准inlier。
        [dnieuw,localnieuw,transform]=procrustes(testdoel,testtedoen,'Scaling',whetherScaling);
        tedoen=tedoen*transform.T + repmat(transform.c(1,1:3),length(tedoen(:,1)),1);%用只考虑inlier计算得出的transform，变换全体moving points
    end
    
    outlierex=tedoen;
end


