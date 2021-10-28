function R=MyDist_a(P,P0)
R=sqrt(sum((P-P0).^2,2));
end