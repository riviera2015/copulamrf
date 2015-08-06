function [AAD, C1MRF, C2MRF,Yactual,Ypred, model, T_train, T_test] = Main_MRF(finalX,finalY,F,FoldedIndex,n_tree,mtree,Command, min_leaf)

[Xtrain,Xtest,Ytrain,Ytest]=CreateFoldedDataRF(finalX,finalY,F, FoldedIndex);
N=20;
%y = [linspace(1/N,1,N)' linspace(1/N,1,N)'];

if Command==2
    Alpha=0.5;
else 
    Alpha=1;
end

if F==0
    F=F+1;
end

F=1 %Delete this

for FF=1:F 
    FF
    X1=Xtrain{FF};
    Y1=Ytrain{FF};
    Xt{FF}=Xtest{FF};
    Yt{FF}=Ytest{FF};
  
    %[xtrain,xtest,ytrain,ytest,FoldedIndex2]=CreateFoldedDataMRF(X1,Y1,F);
    tic
    model{FF} = build_forest(X1, Y1, n_tree, mtree,N,Command, min_leaf, Alpha)
    T_train(FF)=toc;
    
    tic
    Y_hat{FF} = forest_predict(Xt{FF}, model{FF});
    T_test(FF)=toc;
  
    AAD(FF,:)=mean(abs(Y_hat{FF}-Yt{FF}));
end


Yactual=[];
Ypred=[];

parfor i=1:F
    Yactual=[Yactual;Yt{i}];
    Ypred=[Ypred;Y_hat{i}];
end


% In=[];
% for i=1:F
%     In=[In FoldedIndex{i}];
% end
% Yactual(In,:)=Yactual;
% Ypred(In,:)=Ypred;

C1MRF=corrcoef(Yactual(:,1),Ypred(:,1));
C2MRF=corrcoef(Yactual(:,2),Ypred(:,2));
