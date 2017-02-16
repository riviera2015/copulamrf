function [AAD, CRF,Yactual,Ypred, T_train, T_test] = Main_RF(finalX,finalY,F,FoldedIndex,n_tree,mtree,Column, Command, min_leaf)

finalY=finalY(:,Column);
[Xtrain,Xtest,Ytrain,Ytest]=CreateFoldedDataRF(finalX,finalY,F,FoldedIndex); %% Finding The folded index back


if F==0
    F=F+1;
end

for FF=1:F 
    FF
    X1=Xtrain{FF};
    Y1=Ytrain{FF};
    Xt{FF}=Xtest{FF};
    Yt{FF}=Ytest{FF};
    
    tic
    model = build_forest(X1, Y1, n_tree, mtree, 1,Command, min_leaf, 1)
    T_train(FF)=toc;
    
    tic
    Y_hat{FF} = forest_predict(Xt{FF}, model);
    T_test(FF)=toc;
    
    AAD(FF,:)=mean(abs(Y_hat{FF}-Yt{FF}));
end


Yactual=[];
Ypred=[];

for i=1:F
    Yactual=[Yactual;Yt{i}];
    Ypred=[Ypred;Y_hat{i}];
end

In=[];
for i=1:F
    In=[In FoldedIndex{i}];
end
Yactual(In,:)=Yactual;
Ypred(In,:)=Ypred;


CRF=corrcoef(Yactual(:,1),Ypred(:,1));
