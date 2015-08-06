function [index_left, index_right, which_feature, threshold_feature, DD, IN, indexX]...
    = split_vmrf_rf(X, Y, index, V_inv, mtree,NN,copula,Command, Alpha, min_leaf)

x = X(index,:);
y = Y(index,:);

f = size(x,2); % number of features
f_1 = sort(randperm(f, mtree));
N = size(x,1); % number of samples
min_score = [];
id = cell(N-1,length(f_1));
for j = 1:length(f_1)
    xj = x(:,f_1(j));
    [s, idx] = sort(xj); % sort the features)
    
    ss=s(1):(s(end)-s(1))/(N/5):s(end);
     
    while length(find(s<ss(1)))<min_leaf && length(ss)>1
       ss(1)=[];
    end
    
    while length(find(s>ss(end)))<min_leaf && length(ss)>1
        ss(end)=[];
    end
    
    for k1=1:length(ss)
        k=k1;
        yk_left=y(idx(find(s<ss(k1))),:);
        yk_right=y(idx(find(s>=ss(k1))),:);
        
    %for k1=min_leaf:min_leaf:N-min_leaf
        %k=k1-min_leaf+1;
        %k=k1/min_leaf;
        %yk_left = y(idx(1:k1),:);
        %yk_right = y(idx(k1+1:end),:);
        
        if length(yk_left)<min_leaf | length(yk_right)<min_leaf
            D=1000000;
            D1L(j,k)=100000;
            D2L(j,k)=0;
            D1R(j,k)=100000;
            D2R(j,k)=0;
        else
            [D_left c]= Multi_D_mod(Y,y,yk_left, V_inv,NN,copula,Command);
            [D_right c] = Multi_D_mod(Y,y,yk_right, V_inv,NN,copula,Command);
            D=D_left+D_right;
            D1L(j,k)=D_left;
            D2L(j,k)=0;
            D1R(j,k)=D_right;
            D2R(j,k)=0;
        end

                       
        if j==1&&k==1
                min_score = D;
                which_feature = f_1(1);
                indexX=[j k1];
                %threshold_feature = (s(k1) + s(k1+1))/2;
                threshold_feature = ss(k1) + (s(end)-s(1))/(2*N/5);
                ij_i = 1;
                ij_j = 1;
        end

        if D < min_score
                min_score = D;
                which_feature = f_1(j); 
                indexX=[j k1];
                %threshold_feature = (s(k1) + s(k1+1))/2; % threshold calculation
                threshold_feature = ss(k1) + (s(end)-s(1))/(2*N/5);
                ij_i = k;
                ij_j = j;
        end

        %id{k,j} = idx(1:k1);
        id{k,j} = idx(find(s<ss(k1)));
      
    end
end




DD={D1L D2L;D1R D2R};

index_left = id{ij_i,ij_j};
index_right = 1:N;
index_right(index_left) =[];

index_left = index(sort(index_left));
index_right = index(sort(index_right));
IN={index_left index_right};

