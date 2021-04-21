function M = generateGeneralSparseMatrix(s,n)
    M = full(100 .* sprand(n,n,s));
end