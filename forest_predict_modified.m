function Y_hat = forest_predict_modified(X_hat, model,whichtree)

forest = model.forest;
variable_num = model.variable_num;

Y_hat = zeros(size(X_hat,1),variable_num);
   
%for i=1:n_tree
    t = forest{1,whichtree};
    Y_predict = single_tree_predict(X_hat, t, variable_num);
    
    for j = 1:variable_num
        Y_hat(:,j) = Y_hat(:,j) + Y_predict(:,j);
    end
%end

%Y_hat = Y_hat/n_tree;

    

