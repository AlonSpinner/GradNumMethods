function [est_num_iter, est_error ] = itr_est(x0,G,c,threshold,k)
    x1=G*x0+c; %Find next itr
    x2=G*x1+c; %Find next itr
    
    %Find the error supremum for given k
    est_error=(norm(x1-x0,inf))*(norm(G,inf)^k)/(1-norm(G,inf));
    
    %Find number of itr for given supremum
    normG=norm(G,inf);
    a=1-norm(G,inf);
    b=norm(x1-x0,inf);
    
    c=threshold*a/b;
    
    est_num_iter=log(c)/log(normG);
end