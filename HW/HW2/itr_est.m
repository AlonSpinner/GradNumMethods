function [est_num_iter, est_error ] = itr_est(x0,G,c,threshold,k)
    %This function should have been split into two, one for each output.

    %from page 457 in Numerical Analysis by Rhichard L. Burden 9th ed: General Iteration Methods
    
    %given a system:
    %x(k) = Tx(k-1) + c

    % if ||T|| < 1 for any natrual matrix norm, and c is a given vector,
    % then the sequence x(k) converges for any x(0), and the following
    % error bounds hold:

    %bound(1) ||x-x(k)|| <= ||T||^k||x(0)-x|| % a little useless
    %bound(2) ||x-x(k)|| <= ||T||^k/(1-||T||)*||x(1)-x(0)||To 

    x1 = G*x0 + c;
    ndx1 = norm(x1-x0,'inf');
    nG = norm(G,'inf');

    %find number of iterations given upper error bound: Compare bound(2)_ to threshold
    est_num_iter = log(threshold/ndx1*(1-nG))/ log(nG); %minimal number of iterations

    if nargin < 5 %k was not provided
        k = est_num_iter;
    end
    est_error = nG^k / (1-nG) *ndx1;

end