function C = toCompact(M, type, format)
% Tihs function returns an object that is the sparse compact format of the given matrix
    assert(type == "General" | type == "Banded", "Type not supported");
    assert(type == "General" & (format == "COO" | format == "CSR") | type == "Banded" & (format == "Diagonal" | format ==  "Ellpack-Itpack"), "Format not supported for given type");
    n  = height(M);
    if format  == "COO"
        C = COO(n); 
    end
    if format  == "CSR"
        C = CSR(n);
    end
    if format  == "Diagonal"
        C = Diagonal(n);
    end
    if format == "Ellpack-Itpack"
        C = EllpackItpack(n);
    end
    C = C.Compact(M);
end