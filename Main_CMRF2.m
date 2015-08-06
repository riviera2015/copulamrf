function [AAD, C1MRF, C2MRF,Yactual,Ypred, model, Alpha] = Main_CMRF2(finalX,finalY,F,FoldedIndex,n_tree,mtree,Command, min_leaf)

[Xtrain,Xtest,Ytrain,Ytest]=CreateFoldedDataRF(finalX,finalY,F, FoldedIndex);
N=20;
%y = [linspace(1/N,1,N)' linspace(1/N,1,N)'];

if F==0
    F1=F+1;
else
    F1=F;
end

for FF=1:F1  
    X1=Xtrain{FF};
    Y1=Ytrain{FF};
    Xt{FF}=Xtest{FF};
    Yt{FF}=Ytest{FF};
    
    %%%%
    [xtrain,xtest,ytrain,ytest]=CreateFoldedDataMRF(X1,Y1,F);
    x=xtrain{1};
    y=ytrain{1};
    xt=xtest{1};
    yt=ytest{1};
    
    
    m=build_forest(x, y, n_tree, mtree,N,Command, min_leaf, 1);

    slopeL=[];
    slopeR=[];
    Slope=[];

    for i=1:n_tree

            D=m.forest{1,i}.Node{1,1}{1,3};

            D1L=D{1,1}(:);
            D2L=D{1,2}(:);
            D1R=D{2,1}(:);
            D2R=D{2,2}(:);
            
            T=[D1L D2L];
            T=T(find(sum(T,2)~=0), :);
            front=paretoGroup(T);
            ind=find(front==1);
            f1L=D1L(ind);
            f2L=D2L(ind);
            InL_Low=find(f1L>f2L);
            InL_High=find(f1L<=f2L);
            f1L_Low=f1L(InL_Low);
            f1L_High=f1L(InL_High);
            f2L_Low=f2L(InL_Low);
            f2L_High=f2L(InL_High);

            T=[D1R D2R];
            T=T(find(sum(T,2)~=0), :);
            front=paretoGroup(T);
            front=paretoGroup(T);
            ind=find(front==1);
            f1R=D1R(ind);
            f2R=D2R(ind);
            InR_Low=find(f1R>f2R);
            InR_High=find(f1R<=f2R);
            f1R_Low=f1R(InR_Low);
            f1R_High=f1R(InR_High);
            f2R_Low=f2R(InR_Low);
            f2R_High=f2R(InR_High);


            A=abs(polyfit(f1L_Low,f2L_Low,1));
            slopeL(i,1)=1/(A(1)+0.00001);
            A=polyfit(f1L_High,f2L_High,1);
            slopeL(i,2)=1/(A(1)+0.00001);
            
            if slopeL(i,1)>50 | slopeL(i,1)<0.1 | slopeL(i,1)==NaN  slopeL(i,1)=50;end
            if slopeL(i,2)>50 | slopeL(i,2)<0.1 | slopeL(i,2)==NaN  slopeL(i,2)=0.1;end

            B=abs(polyfit(f1R_Low,f2R_Low,1));
            slopeR(i,1)=1/(B(1)+0.00001);
            B=polyfit(f1R_High,f2R_High,1);
            slopeR(i,2)=1/(B(1)+0.00001);
            
            if slopeR(i,1)>50 | slopeR(i,1)<0.1 | slopeR(i,1)==NaN  slopeR(i,1)=50;end
            if slopeR(i,2)>50 | slopeR(i,2)<0.1 | slopeR(i,2)==NaN slopeR(i,2)=0.1;end

    end
    
    Slope = mean([slopeL;slopeR]);
    
    for i=1:length(Slope)
        m=build_forest(x, y, n_tree, mtree,N,Command, min_leaf, Slope(i));
        y_hat=forest_predict(xt, m);
        c1=corrcoef(yt(:,1),y_hat(:,1));
        c2=corrcoef(yt(:,2),y_hat(:,2));
        
        if size(c1,1)==2
            c(i)=(c1(1,2)+c2(1,2))/2;
        elseif size(c1,1)==1
            c(i)=(c1+c2)/2;
        end
        
    end
        
    Alpha(FF)=Slope(min(find(c==max(c))));
      
    %%%%
     
    model{FF} = build_forest(X1, Y1, n_tree, mtree,N,Command, min_leaf, Alpha(FF));
    Y_hat{FF} = forest_predict(Xt{FF}, model{FF});
    AAD(FF,:)=mean(abs(Y_hat{FF}-Yt{FF}));
end


Yactual=[];
Ypred=[];

parfor i=1:F1
    Yactual=[Yactual;Yt{i}];
    Ypred=[Ypred;Y_hat{i}];
end

C1MRF=corrcoef(Yactual(:,1),Ypred(:,1));
C2MRF=corrcoef(Yactual(:,2),Ypred(:,2));
