function [AAD NumRepeatation]=findVIM_OOB(M,NumVariable,n_tree,XX,YY, Command);

NumRepeatation=zeros(n_tree,NumVariable);
AAD=zeros(1,n_tree);

for i=1:length(M)
   i
   X=XX{i};
   Y=YY{i};
   Model=M{i};
   Forest=Model.forest;
   BootSam=Model.bootsam;
   Y=Model.training_response;
   
   for j=1:n_tree
       j1=[];
       k1=[];
       D1L=[];
       D2L=[];
       D1R=[];
       D2R=[];
       BootSampleIndex=BootSam(:,j);
       OOBIndex=setdiff([1:size(BootSam,1)]', BootSampleIndex);
       
       Tree=Forest{j};
       Node=Tree.Node;
        
       X1=X(BootSampleIndex,:);
       Y1=Y(BootSampleIndex,:);
       Xtest=X1(OOBIndex,:);
       Y_hat=forest_predict_modified(Xtest,Model,j);
       Ytest=Y(OOBIndex,:);
       AAD(i,j)=mean(mean(abs(Y_hat-Ytest)));
           
            for k=1:size(Node,1)
                if size(Node{k},2)>3               
                     NumRepeatation(j, Node{k}{1})=NumRepeatation(j, Node{k}{1})+1;           
                end
            end            
   end
end
       
       
       
       
     