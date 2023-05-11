function [Prealligned_source,Prealligned_target,transformtarget ]=Preall(target,source)

    % This function performs a first and rough pre-alligment of the data as starting position for the iterative allignment and scaling procedure
    
    % Initial positioning of the data is based on alligning the coordinates of the objects -which are assumed to be close/similar in shape- following principal component analysis
    
    % [COEFF,Prealligned_source] = princomp(source);
    % 
    % [COEFF,Prealligned_target] = princomp(target);
    % target是meanBone的点集，source是测试集点集。这两个点集一开始所处的坐标轴都是任意的，且两套可能不一致。
    % 第一步先用pca分析两套点集，实际上是各自重新寻找三个互相垂直的坐标轴，但是x轴一定会沿股骨长轴方向
    % 第二步，确定两个boundingbox在x,y,z三个方向上的放缩，并构建放缩对角矩阵，把source尺寸变换。
    % 第三步，由于pca无法保证坐标轴方向向量一定相同，只能保证共线，因此x,y,z三个轴每个都可选择翻转或不反转，共有2^3 = 8种可能
    % 第四步，确定了正确的反转后，将反转应用到source上。
    
    % prealigned_target是变换坐标轴后的点集矩阵
    % transformtarget是把prealigned_target重新变回target的变换
    % prealigned_source是原始source旋转，且翻转，使得和prealigned_target坐标轴一致
    
    
    [COEFF,Prealligned_source] = pca(source);
    
    [COEFF,Prealligned_target] = pca(target);
    
    % the direction of the axes is than evaluated and corrected if necesarry.
    %下面这段原代码肯定有问题的所以,换成我的
    % Maxtarget=max(Prealligned_source)-min(Prealligned_source);
    % Maxsource=max(Prealligned_target)-min(Prealligned_target);
    Maxsource=max(Prealligned_source)-min(Prealligned_source);
    Maxtarget=max(Prealligned_target)-min(Prealligned_target);
    D=Maxtarget./Maxsource;
    D=[D(1,1) 0 0;0 D(1,2) 0; 0 0 D(1,3)];
    RTY=Prealligned_source*D;
    %Idx = knnsearch(X,Y) finds the nearest neighbor in X for 
    % each query point in Y and returns the indices of the nearest neighbors in Idx, a column vector. Idx has the same number of rows as Y.
    load R
    for i=1:8
        T=R{1,i};
        T=RTY*T;
        [bb DD]=knnsearch(T,Prealligned_target);
        MM(i,1)=sum(DD);
    end
    
    [M I]=min(MM);
     T=R{1,I};
     Prealligned_source=Prealligned_source*T;
     
     [d,Z,transformtarget] = procrustes(target,Prealligned_target);
end