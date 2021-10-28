function R=MyDist_b(P,P0)
    R=zeros(size(P,1),1);
    for ii=1:length(R)
        R(ii)=MyDist_a(P,P0);
    end
end