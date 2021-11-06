function sol_direct = gauss_elim(A,b,pivot_flag)
assert(size(A,1) == size(b,1) && size(A,2) == size(b,1),"error matrix A and vector b are not competible");
C = [A,b];
for i = 1:size(A,2)-1
    if (C(i,i) == 0 || pivot_flag==1) % checking diagonal value is not zero or pivoting is required
        [~,max_row] = max(C(i:end,i));
        max_row = max_row - 1 + i;
        temp = C(i,:);
        C(i,:) = C(max_row,:);
        C(max_row,:) = temp;
    end
    for j = i+1:size(A,1)
        if(C(j,i) ~= 0)
            C(j,:) = C(j,:) - C(i,:)./C(i,i).*C(j,i);
        end
    end
end


sol_direct = zeros(size(b,1),1); %zeros vector
for i = size(A,1):-1:1
    sol_direct(i) = (C(i,end)-C(i,1:end-1)*sol_direct)/C(i,i); %updating the sol_direct vector every iteration
end
end