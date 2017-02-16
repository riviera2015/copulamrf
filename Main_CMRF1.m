function [AAD, C1MRF, C2MRF,Yactual,Ypred, model, Alpha, T_train, T_test] = Main_CMRF1(finalX,finalY,F,FoldedIndex,n_tree,mtree,Command, min_leaf)

[Xtrain,Xtest,Ytrain,Ytest]=CreateFoldedDataRF(finalX,finalY,F, FoldedIndex);
N=20;

if F==0
    F=F+1;
end

%%%%%%%%%%%%%%Finding Alpha
% X1=Xtrain{1};
% Y1=Ytrain{1};
%     %%%
% [xtrain,xtest,ytrain,ytest]=CreateFoldedDataMRF(X1,Y1,F);
% x=xtrain{1};
% y=ytrain{1};
% xt=xtest{1};
% yt=ytest{1};
%     
% parfor i=1:length(A);
%    m=build_forest(x, y, n_tree, mtree,N,Command, min_leaf, A(i));
%    y_hat=forest_predict(xt, m);
%    c1=corrcoef(yt(:,1),y_hat(:,1));
%    c2=corrcoef(yt(:,2),y_hat(:,2));
%         
%    if size(c1,1)==2
%        c(i)=(c1(1,2)+c2(1,2))/2;
%    elseif size(c1,1)==1
%        c(i)=(c1+c2)/2;
%    end
% end
% 
% Alpha=A(min(find(c==max(c))));
Alpha=25;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for FF=1:F  
    X1=Xtrain{FF};
    Y1=Ytrain{FF};
    Xt{FF}=Xtest{FF};
    Yt{FF}=Ytest{FF};  
    
    tic
    model{FF} = build_forest(X1, Y1, n_tree, mtree,N,Command, min_leaf, Alpha);
    T_train(FF)= toc;
    
    tic
    Y_hat{FF} = forest_predict(Xt{FF}, model{FF});
    T_test(FF)=toc;
    
    AAD(FF,:) = mean(abs(Y_hat{FF}-Yt{FF}));
end


Yactual=[];
Ypred=[];

parfor i=1:F
    Yactual=[Yactual;Yt{i}];
    Ypred=[Ypred;Y_hat{i}];
end

In=[];
for i=1:F
    In=[In FoldedIndex{i}];
end
Yactual(In,:)=Yactual;
Ypred(In,:)=Ypred;


C1MRF=corrcoef(Yactual(:,1),Ypred(:,1));
C2MRF=corrcoef(Yactual(:,2),Ypred(:,2));
