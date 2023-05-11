function [X,Y,Z]=reallign2(X,Y,Z,namedValueArgs)
    %使用procustes analysis把surface mesh都配准到一起，配完后点没有normalize
    %iterative function realligns training data according to the mean and excluding
    %outliers at the 0.05 level
        arguments
            X (:,:)
            Y (:,:)
            Z (:,:)
            namedValueArgs.initialIdx (1,1)
            namedValueArgs.whetherScaling (1,1) logical = false
        end
        [m,n] = size(X);
        if isfield(namedValueArgs,"initialIdx")
            initialIdx = namedValueArgs.initialIdx;        
        else
            initialIdx = 1;        
        end
        Template=horzcat(X(:,initialIdx),Y(:,initialIdx),Z(:,initialIdx));%选用户指定或第一个作为template
        %将其余n-1个往template上配准
        for i=1:n
            if i ~= initialIdx
                Ytemp= horzcat(X(:,i),Y(:,i),Z(:,i)); 
                [outlierex]=SSMBuilder.outexallign(Template,Ytemp,namedValueArgs.whetherScaling);
                X(:,i)=outlierex(:,1);
                Y(:,i)=outlierex(:,2);
                Z(:,i)=outlierex(:,3);
            end
        end
        %第二轮：取所有的平均，并让此平均作为此轮的template。
        Templatenew=horzcat(mean(X,2),mean(Y,2),mean(Z,2));
        for i=1:n
            Ytemp= horzcat(X(:,i),Y(:,i),Z(:,i)); 
            [outlierex]=SSMBuilder.outexallign(Templatenew,Ytemp,namedValueArgs.whetherScaling);
            X(:,i)=outlierex(:,1);
            Y(:,i)=outlierex(:,2);
            Z(:,i)=outlierex(:,3);
        end
        
        Templatenew=horzcat(mean(X,2),mean(Y,2),mean(Z,2));
        for i=1:n
            Ytemp= horzcat(X(:,i),Y(:,i),Z(:,i)); 
            [outlierex]=SSMBuilder.outexallign(Templatenew,Ytemp,namedValueArgs.whetherScaling);
            X(:,i)=outlierex(:,1);
            Y(:,i)=outlierex(:,2);
            Z(:,i)=outlierex(:,3);
        end
end