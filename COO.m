classdef COO < CompactFormat
    properties
        V
        I
        J
    end
    methods
        function C = Compact(C,M)
            dim = nnz(M);
            C.I = zeros(1,dim);
            C.J = zeros(1,dim);
            C.V = zeros(1,dim);
            %C.n = height(M);

            k = 1;
            for i=[1:1:C.n]
                for j=[1:1:C.n]
                    if M(i,j) ~= 0
                        C.V(k) = M(i,j);
                        C.I(k) = i;
                        C.J(k) = j;
                        k = k + 1;
                    end
                end
            end
        %     % test
        %     assert(k - 1 == dim);
        %     for k=[1:1:dim]
        %         assert(C.V(k) == M(C.I(k), C.J(k)));
        %     end

        end
        function r = extractRow(C, i)
            r = zeros(1,C.n);
            k = find(C.I==i);
            r(C.J(k)) = C.V(k);
        end
        function c = extractCol(C, j)
            c = zeros(C.n,1);
            k = find(C.J==j);
            c(C.I(k)) = C.V(k);
        end
        function Y = matMulBy(C,X)
            Y = COO(C.n);
            k = 1;
            for i =[1:1:C.n]
                r = C.extractRow(i);
                for j = [1:1:C.n]
                    c = X.extractCol(j);
                    v = r * c;
                    if v ~= 0
                        Y.V(k) = v;
                        Y.I(k) = i;
                        Y.J(k) = j;
                        k = k +1;
                    end
                end
            end
       end
    end
end
