function [t] = split_node(X,Y,t,t_idx,index,index_memory, V_inv, mtree,N,copula,Command,min_leaf, Alpha)

% calculate which feaure is used for splitting
if length(index)>3*min_leaf+1
    if Command==1 | Command == 4
        [index_left, index_right, which_feature, threshold_feature, DD, IN, indexX] = split_cmrf(X, Y, index, V_inv, mtree,N,copula,Command, Alpha, min_leaf);
    elseif Command==2 | Command ==3
        [index_left, index_right, which_feature, threshold_feature, DD, IN, indexX] = split_vmrf_rf(X, Y, index, V_inv, mtree,N,copula,Command, Alpha, min_leaf);
    end
    t = t.set(t_idx, {which_feature threshold_feature DD IN Alpha indexX});
    [t,tl] = t.addnode(t_idx, 1);
    [t,tr] = t.addnode(t_idx, 2);
    
    [t] = split_node(X,Y,t,tl,index_left, index, V_inv, mtree,N,copula,Command, min_leaf, Alpha);
    [t] = split_node(X,Y,t,tr,index_right, index, V_inv, mtree,N,copula,Command, min_leaf, Alpha);
else
    t = t.set(t_idx, [index', Y(index,:)]);
end