A = [2 1 2; 1 2 3; 4 1 2];
B = [2 3 -1; 1 -2 1; -1 -12 5;];
C = [2 1 2; 4 1 2; 1 2 3];

disp('A')
checkMatrix(A);
disp('B')
checkMatrix(B);
disp('C')
checkMatrix(C);

disp('magic')
checkMatrix(magic(10))

function checkMatrix(A)
    [mydet_A,myinv_A] = my_det_and_inv(A);
    re_det_A = abs(mydet_A - det(A))/det(A));
    re_inv_A = norm((myinv_A - inv(A)),'inf')/norm(inv(A),'inf');
    
    fprintf('condNumber = %d\n',cond(A));
    fprintf('relative determinant error %d\n',re_det_A);
    fprintf('relative inverse error %d\n',re_inv_A);
end
