function q=HW4_2_v(x,t)
q=0;
if t>1 && t<1.2
    q=x*(1-x)*30;
    if t>1 && t<1.03
        q=q*(exp((t-1)*20)-1);
    elseif t>1.18 && t<1.2
        q=q*(exp((1.2-t)*20)-1);
    end
elseif t>2
    q=sin(4*x*pi)^2*30;
    if x>0.5
        q=0;
    end
    if t>2 && t<2.03
        q=q*(exp((t-2)*20)-1);
    end
end