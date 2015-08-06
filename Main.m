clear all;
close all;
clc;

n_tree=150;  % Number of trees
mtree=10;    %  m
F=0;         % 5 fold cross validation. Put F=0 for 30-70 case
min_leaf=5;  % min_leaf




load('C:\Users\sahaider\Documents\My Dropbox\My Copula\Code For Submission\Data for copulamrf\Data_GDSC_4_5.mat');
%load('C:\Users\sahaider\Dropbox\My Copula\Code For Submission\Data for copulamrf\Data_CCLE_2_24_Relieff.mat');
%final4=finalY+0.001*rand(size(finalY));

In=[];
for i=1:size(finalY, 2)
[ranked{i}, weights{i}]=relieff(finalX, finalY(:,i), 10);
In=union (In,ranked{i}(1:500));
end

finalX=finalX(:,In);

%finalX=finalX(1:300,:);
%finalY=finalY(1:300,:);

[Xtrain,Xtest,Ytrain,Ytest,FoldedIndex]=CreateFoldedDataMRF(finalX,finalY,F);
%load('C:\Users\sahaider\Documents\My Dropbox\My Copula\Code For Submission\Data for copulamrf\FoldedIndex_CCLE_4_5_5fold');
%load('C:\Users\sahaider\Dropbox\My Copula\Code For Submission\Data for copulamrf\FoldedIndex_CCLE_2_24_5fold');
%[Xtrain,Xtest,Ytrain,Ytest]=CreateFoldedDataRF(finalX,finalY,F,FoldedIndex);

addpath(genpath(pwd))


% %%Finding CMRF Results
%tic
Command=1
[AADC, C1MRFC, C2MRFC,YactualC,YpredC,MC, Alpha, T_trainC, T_testC] = Main_CMRF1(finalX,finalY,F,FoldedIndex,n_tree,mtree,Command, min_leaf);
%TC1=toc

% tic
% Command=4
% [AADC2, C1MRFC2, C2MRFC2,YactualC2,YpredC2,MC2] = Main_CMRF1(finalX,finalY,F,FoldedIndex,n_tree,mtree,Command, min_leaf);
% TC2=toc
% 
%%Finding VMRF Results
%tic
Command=2
[AADV, C1MRFV, C2MRFV,YactualV,YpredV,MV, T_trainV, T_testV] = Main_MRF(finalX,finalY,F,FoldedIndex,n_tree,mtree,Command, min_leaf);
%TV1=toc

%%Finding RF Results
%tic
Command=3
[AAD1RF, C1RF,Yactual1RF,Ypred1RF, T_trainRF1, T_testRF1] = Main_RF(finalX,finalY,F,FoldedIndex,n_tree,mtree,1,Command, min_leaf);
[AAD2RF, C2RF,Yactual2RF,Ypred2RF, T_trainRF2, T_testRF2] = Main_RF(finalX,finalY,F,FoldedIndex,n_tree,mtree,2,Command, min_leaf);
%TR1=toc
% [AAD3RF, C3RF,Yactual3RF,Ypred3RF] = Main_RF(finalX,finalY,F,FoldedIndex,n_tree,mtree,3,Command, min_leaf);
% [AAD4RF, C4RF,Yactual4RF,Ypred4RF] = Main_RF(finalX,finalY,F,FoldedIndex,n_tree,mtree,4,Command, min_leaf);
% [AAD5RF, C5RF,Yactual5RF,Ypred5RF] = Main_RF(finalX,finalY,F,FoldedIndex,n_tree,mtree,5,Command, min_leaf);
% [AAD6RF, C6RF,Yactual6RF,Ypred6RF] = Main_RF(finalX,finalY,F,FoldedIndex,n_tree,mtree,6,Command, min_leaf);
% [AAD7RF, C7RF,Yactual7RF,Ypred7RF] = Main_RF(finalX,finalY,F,FoldedIndex,n_tree,mtree,7,Command, min_leaf);
% [AAD8RF, C8RF,Yactual8RF,Ypred8RF] = Main_RF(finalX,finalY,F,FoldedIndex,n_tree,mtree,8,Command, min_leaf);
% [AAD9RF, C9RF,Yactual9RF,Ypred9RF] = Main_RF(finalX,finalY,F,FoldedIndex,n_tree,mtree,9,Command, min_leaf);
% [AAD10RF, C10RF,Yactual10RF,Ypred10RF] = Main_RF(finalX,finalY,F,FoldedIndex,n_tree,mtree,10,Command, min_leaf);
% [AAD11RF, C11RF,Yactual11RF,Ypred11RF] = Main_RF(finalX,finalY,F,FoldedIndex,n_tree,mtree,11,Command, min_leaf);
% [AAD12RF, C12RF,Yactual12RF,Ypred12RF] = Main_RF(finalX,finalY,F,FoldedIndex,n_tree,mtree,12,Command, min_leaf);
% [AAD13RF, C13RF,Yactual13RF,Ypred13RF] = Main_RF(finalX,finalY,F,FoldedIndex,n_tree,mtree,13,Command, min_leaf);
% [AAD14RF, C14RF,Yactual14RF,Ypred14RF] = Main_RF(finalX,finalY,F,FoldedIndex,n_tree,mtree,14,Command, min_leaf);
% [AAD15RF, C15RF,Yactual15RF,Ypred15RF] = Main_RF(finalX,finalY,F,FoldedIndex,n_tree,mtree,15,Command, min_leaf);


%% VIM Analysis
% NumVariable=size(finalX,2);
% [AAD_OOBC NumRepeatationC]=findVIM_OOB(MC,NumVariable,n_tree,Xtrain, Ytrain,1);
% [AAD_OOBV NumRepeatationV]=findVIM_OOB(MV,NumVariable,n_tree,Xtrain, Ytrain,2);
% VIM_V=sum(NumRepeatationV)./(sum(sum(NumRepeatationV)));
% VIM_C=sum(NumRepeatationC)./(sum(sum(NumRepeatationC)));
% [VIM_V VIM_V_ind]=sort(VIM_V,'descend');
% [VIM_C VIM_C_ind]=sort(VIM_C,'descend');
% VIM_V=VIM_V/sum(VIM_V);
% VIM_C=VIM_C/sum(VIM_C);




