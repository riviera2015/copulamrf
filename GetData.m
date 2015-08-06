function [finalX finalY]=GetData(PairNum, NumDrugs)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('DataNeeded.mat');
load('CL1.mat');
load('CL2.mat');
load ('IC50.mat');
load('stab_2.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[CL CLPosition1 CLPosition2]=Matching(CL1,CL2);
CancerType=stab_2(1:310,3);
CancerType=CancerType(CLPosition1);
Cancer=stab_2(1:310,4);
Cancer=Cancer(CLPosition1);
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load('ProbeSet1.mat');
% load('ProbeSet2.mat');
% [Probeset ProbeSetPosition1 ProbesetPosition2]=Matching(ProbeSet1,ProbeSet2);
% load('GeneExpressionsCombined.mat');
% X=X(ProbesetPosition2,CLPosition2);
% X=X';
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if NumDrugs==2
    SelectDrugs=nchoosek([1:19],2);
    for i=1:size(SelectDrugs,1)
        Y=IC50(:,SelectDrugs(i,:));
        Y=Y(CLPosition1,:);
        Position=find((Y(:,1).*Y(:,2))~=0);
        Y=Y(Position,:);
        Z=mean(IC50(Position,:));
        Z=Z(SelectDrugs(i,:));
        h=0.5*ones(1,size(Y,1));
        Y=scalingkd(Y,Z,h);
        Y=1-log10(Y)*(diag(1./max(log10(Y))));
        C=corrcoef(Y(:,1),Y(:,2));
        Corr(i)=C(1,2);
    end    
    
    [SortedCorr SortedInd]=sort(Corr,'descend');
    SelectedDrugs=SelectDrugs(SortedInd(PairNum),:);
    
elseif NumDrugs==3
        SelectDrugs=nchoosek([1:19],3);
    for i=1:size(SelectDrugs,1)
        Y=IC50(:,SelectDrugs(i,:));
        Y=Y(CLPosition1,:);
        Position=find((Y(:,1).*Y(:,2).*Y(:,3))~=0);
        Y=Y(Position,:);
        Z=mean(IC50(Position,:));
        Z=Z(SelectDrugs(i,:));
        h=0.5*ones(1,size(Y,1));
        Y=scalingkd(Y,Z,h);
        Y=1-log10(Y)*(diag(1./max(log10(Y))));
    end  
    
    SelectedDrugs=SelectDrugs(PairNum,:);    
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SelectedDrugs=[14 18];
Y=IC50(:,SelectedDrugs); 
Y=Y(CLPosition1,:);

if NumDrugs==2
    Position=find((Y(:,1).*Y(:,2))~=0);
elseif NumDrugs==3
    Position=find((Y(:,1).*Y(:,2).*Y(:,3))~=0);
end

Y=Y(Position,:);
Z=mean(IC50(Position,:));
Z=Z(SelectedDrugs);
h=1*ones(1,size(Y,1));
%Y=scalingkd(Y,Z,h);
Y=1-log10(Y)*(diag(1./max(log10(Y))));
X=X(Position,:);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % CancerType=CancerType(Position);
% % Cancer=Cancer(Position);
% % Temp1=strfind(Cancer, 'carcinoma');
% % Temp2=double(cellfun(@isempty,Temp1));
% % Temp3=find(Temp2==1);
% % Temp1(Temp3)={0};
% % Temp4=cell2mat(Temp1);
% % Position1=find(Temp4==1);
% % 
% % Temp1=strfind(CancerType,'Lung');
% % Temp2=double(cellfun(@isempty,Temp1));
% % Temp3=find(Temp2==1);
% % Temp1(Temp3)={0};
% % Temp4=cell2mat(Temp1);
% % Position2=find(Temp4==1);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n_tree=200;
mtree=10;
F=10;
P=1:size(X,1);

finalX=X(P,:);
finalY=Y(P,:);



