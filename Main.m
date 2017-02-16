function [] = Main(finalX, finalY, n_tree, mtree, F, min_leaf)

%% Data incluses two variables: finalX and finalY. 
%% finalX is a m by n matrix havign genomics data of m samples of n features.
%% finalY is a m by p matrix having drug response values for m samples and p drugs.

%% Some usual parameters
%% n_tree=150;  % Number of trees (referred to as "T" in the paper)
%% mtree=10;    % Referred to as "m" in the paper
%% F=5;         % F fold cross validation. Put F=0 for 30-70 case
%% min_leaf=5;  % stopping criteria while creating a tree


%% Applying ReliefF algorithm to initially select features, Comment out the whole section if not needed
In=[];
for i=1:size(finalY, 2)
[ranked{i}, weights{i}]=relieff(finalX, finalY(:,i), 10);
In=union (In,ranked{i}(1:500));
end
finalX=finalX(:,In);
%%%%%%%%%%%%%%%

[Xtrain,Xtest,Ytrain,Ytest,FoldedIndex]=CreateFoldedDataMRF(finalX,finalY,F); %% For F fold cross validation, creating folded index
                                                                              %% Can also be done using cvpartition

addpath(genpath(pwd))

%% Prediction
% AADC/AADV/AADRF = Average absolute deviation
% CMRFC/CMRFV/CRF = Correlation coefficient of actual and predicted
% Yactual = The actual values of finalY.
% Ypred   = The predicted valued of finalY.
% MC/MV   = The saved forest
% t_train = Amount of time needed to train the model
% t_test  = amount of time needed to test 

% %%Finding Copula based multivariate random forest (CMRF) Results. Use Command =1
Command=1
[AADC, C1MRFC, C2MRFC,YactualC,YpredC,MC, Alpha, T_trainC, T_testC] = Main_CMRF1(finalX,finalY,F,FoldedIndex,n_tree,mtree,Command, min_leaf);
% Command=4
% [AADC2, C1MRFC2, C2MRFC2,YactualC2,YpredC2,MC2] = Main_CMRF1(finalX,finalY,F,FoldedIndex,n_tree,mtree,Command, min_leaf);

%%Finding Covaraiance based multivariate random forest (VMRF) Results, Use Command =2
Command=2
[AADV, C1MRFV, C2MRFV,YactualV,YpredV,MV, T_trainV, T_testV] = Main_MRF(finalX,finalY,F,FoldedIndex,n_tree,mtree,Command, min_leaf);
%%Finding Univariate RF Results. Use Command = 3
Command=3
[AAD1RF, C1RF,Yactual1RF,Ypred1RF, T_trainRF1, T_testRF1] = Main_RF(finalX,finalY,F,FoldedIndex,n_tree,mtree,1,Command, min_leaf);
[AAD2RF, C2RF,Yactual2RF,Ypred2RF, T_trainRF2, T_testRF2] = Main_RF(finalX,finalY,F,FoldedIndex,n_tree,mtree,2,Command, min_leaf);

save('Results');

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




