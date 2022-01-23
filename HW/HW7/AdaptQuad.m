function [I,flag] = AdaptQuad(fun,a,b,n,epsilon,Iprev)
    if nargin <6 %Iprev not provided, probability first iteration
        Iprev = GC(fun,a,b,n);
    end
    m = (a+b)/2;
    s1 = GC(fun,a,m,n);
    s2 = GC(fun,m,b,n);

    if abs(Iprev-(s1+s2))>epsilon
        I=s1+s2;
        flag = true;
    else
        s1 = AdaptQuad(fun,a,m,n,epsilon/2);
        AdaptQuad(fun,m,b,n,epsilon/2);
        flag = false;
    end
end

function I = GC(fun,a,b,n)
    [x,w] = lgwt(a,b,n); %both column vectors
    %assume function was not written for a vectorized x
    y = bsxfun(fun,x);
    I = w'*y;

end