function [error,Reallignedsource]=ICPmanu_allign2(target,source)
    %procustes
    %analysis要求target和source点数一样，本函数扩展了procustes函数，使得能应对不同点数。前提要求target和sourcealign到一起，在一个相同坐标轴下
    [IDX1(:,1),IDX1(:,2)]=knnsearch(target,source);%对source的每一行（每一个点），查询target中哪一行与它距离最近
    [IDX2(:,1),IDX2(:,2)]=knnsearch(source,target);% 对target的每一行（每一个点），查询source中哪一行（哪一个点）与它距离最近
    IDX1(:,3)=1:length(source(:,1));% 在矩阵IDX1右侧添加一列source点集id
    IDX2(:,3)=1:length(target(:,1)); % 在矩阵IDX2右侧添加一列target点集id
    
    m1=mean(IDX1(:,2)); %source点到target中最近点距离的平均值
    s1=std(IDX1(:,2));%source点到target中最近点距离的标准差
    IDX2=IDX2(IDX2(:,2)<(m1+1.96*s1),:);
    
    Datasetsource=vertcat(source(IDX1(:,3),:),source(IDX2(:,1),:));
    Datasettarget=vertcat(target(IDX1(:,1),:),target(IDX2(:,3),:));
    
    [error,Reallignedsource,transform] = procrustes(Datasettarget,Datasetsource,'scaling',0);
    Reallignedsource=transform.b*source*transform.T+repmat(transform.c(1,1:3),size(source,1),1);
end


