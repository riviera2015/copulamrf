function [model] = build_forest(X1, Y1, n_tree, mtree, N,Command, min_leaf, Alpha)


addpath(genpath(pwd))

[bootstat,bootsam] = bootstrp(n_tree,[],Y1);
model.bootsam = bootsam;

fprintf('     Set ntree = %d, mtree = %d \n      ', n_tree, mtree)

% build forest
forest = cell(1,n_tree);


ms.UseParallel = 'always';

parfor i = 1:n_tree
    X=X1(bootsam(:,i),:);
    Y=Y1(bootsam(:,i),:);
    V_inv = inv(cov(Y)); % calculate the V inverse
    %%%%%%%%%%%%%%%%%%%%%%
    if Command==1
        copula=FindCopulaPal3(Y,N);
    elseif Command == 4
        copula=sin((pi/2)*corr(Y,'type', 'kendall'));
    else
        copula=[];
    end
    %%%%%%%%%%%%%%%%%%%%%
    
    feature_threshold_t = build_single_tree(X, Y, V_inv, mtree,N,copula,Command, min_leaf, Alpha);  
    forest{1,i} = feature_threshold_t;
end


model.forest = forest;
model.variable_num = size(Y1,2);
model.training_response = Y1;




