classdef EllpackItpack < CompactFormat
    properties
        COEFF 
        JCOEFF
    end
    methods
        function C = Compact(C,M)
            C.n = height(M);
            C.COEFF = zeros(C.n, 1);
            C.JCOEFF = zeros(C.n, 1);
            for i = [1:1:C.n]
                k = 1;
                for j = [1:1:C.n]
                    if M(i,j) ~= 0
                        C.COEFF(i,k) = M(i,j);
                        C.JCOEFF(i,k) = j;
                        k = k + 1;
                    end
                end
            end
        end
        function r = extractRow(C,i)
            r = zeros(1,C.n);
            J = nonzeros(C.JCOEFF(i,:));
            V = nonzeros(C.COEFF(i,:));
            r(J) = V;
        end
        function c = extractCol(C,j)
            c = zeros(C.n, 1);
            for i = [1:1:C.n]
                k = find(C.JCOEFF(i,:) == j);
                if ~ isempty(k)
                    c(i) = C.COEFF(i,k);
                end
            end
        end
        function Y = matMulBy(C,X) 
            Y = EllpackItpack(C.n);
            Y.COEFF = zeros(C.n, 1);
            Y.JCOEFF = zeros(C.n, 1);
            for i =[1:1:C.n]
                k = 1;
                r = C.extractRow(i);
                for j = [1:1:C.n]
                    c = X.extractCol(j);
                    v = r * c;
                    if v ~= 0
                        Y.COEFF(i,k) = v;
                        Y.JCOEFF(i,k) = j;
                        k = k +1;
                    end
                end
            end
        end     
    end
end