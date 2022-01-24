function [I,GQevals] = AdaptQuad(fun,a,b,n,epsilon,I1)
    if nargin < 6 %Iprev not provided --> first iteration
        I1 = GC(fun,a,b,n);
        GQevals = 1;
    else
        GQevals = 0;
    end
    
    m = (a+b)/2;
    I2a = GC(fun,a,m,n); GQevals = GQevals+1;
    I2b = GC(fun,m,b,n); GQevals = GQevals+1;
    I2 = I2a + I2b;

    if abs(I2-I1)/I1 < epsilon
        I = I2;
    else
        [I2a,GQevals_a] = AdaptQuad(fun,a,m,n,epsilon,I2a);
        [I2b,GQevals_b] = AdaptQuad(fun,m,b,n,epsilon,I2b);
        I = I2a + I2b;
        GQevals = GQevals + GQevals_a + GQevals_b;
    end
end

function I = GC(fun,a,b,n)
    [x,w] = lgwt(n,a,b); %both column vectors
    %assume function was not written for a vectorized x
    y = arrayfun(@(element) fun(element),x);
    I = w'*y;
end