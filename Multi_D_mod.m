function [D c] = Multi_D_mod(YY,Y, y, V_inv,N,copula,Command)

            NN=size(y,1);
            ybar1 = sum(y,1)/size(y,1);
            ybar2 = sum(y,1)/size(y,1);
        if Command==1 %%Which means using CMRF        
            c=FindCopulaPal3(y,N);            
            IntDiff=(sum(sum(abs(copula-c))))/N^2;
            D1=2*6*size(Y,1)*IntDiff;
            sigma1=std(Y(:,1));
            sigma2=std(Y(:,2));
            D2=sum((y(:,1)-ybar1(1)).^2)/(sigma1^2) + sum((y(:,2)-ybar1(2)).^2)/(sigma2^2);
            D=[D1 D2];     
        elseif Command==4
            c=sin((pi/2)*corr(y,'type', 'kendall'));
            %D1=size(Y,1)*abs(c(1,2)-copula(1,2));
            D1=size(Y,1)*sum(sum(abs(c-copula)))/((size(y,2))^2-size(y,2));
            sigma1=std(Y(:,1));
            sigma2=std(Y(:,2));
            D2=sum((y(:,1)-ybar1(1)).^2)/(sigma1^2) + sum((y(:,2)-ybar1(2)).^2)/(sigma2^2);
            D=[D1 D2];  
        elseif Command==2 %%Using VMRF       
            yhat = y - ybar2(ones(size(y,1), 1), :); % yhat = y - repmat(ybar2,size(y,1),1);
            c=[];
            D = sum(diag((yhat*V_inv*yhat')));
        elseif Command==3  %%Using Regular RF
            ybar = sum(y)/size(y,1);
            D = sum((y - ybar).^2);
            c=[];
        end
    