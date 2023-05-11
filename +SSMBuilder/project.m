function [projections]=project(vS,fS,vT,fT)

    TRS = triangulation(fS,vS); 
    % V = vertexNormal(TR) returns the unit normal vectors to all vertices in a 3-D surface triangulation. 
    % V is a three-column matrix with each row containing the unit normal coordinates corresponding to the vertices in TR.Points.
    normalsS=vertexNormal(TRS); % normalsS is n-by-3 matrix
    
    % 对于vS中的每个点，查询vT中哪个点和他最近，并返回最近的点的id到IDXsource里
    [IDXsource,Dsource]=knnsearch(vT,vS);
    % vS到最近vT点的方向向量
    vector_s_to_t=vT(IDXsource,:)-vS;
    % 以下是原代码，但是normalsS是个矩阵，所以norm(矩阵)其实是求他的最大奇异值，再平方，感觉无意义。所以猜测有错误，注释掉
    %projections=vS+[(sum(vector_s_to_t.*normalsS,2)./(norm(normalsS).^2)).*normalsS(:,1) (sum(vector_s_to_t.*normalsS,2)./(norm(normalsS).^2)).*normalsS(:,2) (sum(vector_s_to_t.*normalsS,2)./(norm(normalsS).^2)).*normalsS(:,3)];

    % 猜测想要做的事就是把向量投影到单位方向向量上
    innerProduct = sum(vector_s_to_t .* normalsS, 2);
    projections = vs + innerProduct .* normalsS; %点乘会自动广播，不用像原代码那么冗长
end    