function I = AdaptQuad(fun,a,b,n,epsilon,I1)
    if nargin <6 %Iprev not provided, probability first iteration
        I1 = GC(fun,a,b,n);
    end
    
    m = (a+b)/2;
    I2 = GC(fun,a,m,n)+GC(fun,m,b,n);

    if abs(I1-I2) < epsilon
        I = I2 + (I2-I1)/15;
    else
        I = AdaptQuad(fun,a,m,n,epsilon)+AdaptQuad(fun,m,b,n,epsilon/2);
    end
end

function I = GC(fun,a,b,n)
    [x,w] = lgwt(a,b,n); %both column vectors
    %assume function was not written for a vectorized x
    y = bsxfun(fun,x);
    I = w'*y;

end