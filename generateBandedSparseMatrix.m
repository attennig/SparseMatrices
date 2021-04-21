function M = generateBandedSparseMatrix(k,n)
    b = 2*k+1;
    d = [-k:1:k];
    nzM = 100 .* sprand(n,b,1);
    M = full(spdiags(nzM, d, n,n));
end