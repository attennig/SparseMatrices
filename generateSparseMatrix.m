function M = generateSparseMatrix(s,n,type)
% This function generates a random matrix 
    if type == "General"
        % generally sparse
        M = generateGeneralSparseMatrix(s,n);
    end
    if type == "Banded"
        % banded spars
        % k so as to have the same sparsity of the general sparse matrix
        % nnzElem = s * n^2;
        % totrow = nnzElem/n;
        % k = floor((totrow - 1)/2);
        % k constant
        % k = 5;
        % k s.t. sparity is s
        k = floor((2*n - 1 - (4*n^2 - 4*s*n^2 - 1)^(0.5))*0.5);
        M = generateBandedSparseMatrix(k,n);
    end
    



end