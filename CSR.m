classdef CSR < CompactFormat
    properties
        I
        J
        V
    end
    methods
        function C = Compact(C,M)
            dim = nnz(M);
            C.n = height(M);
            C.I = zeros(1,C.n+1);
            C.J = zeros(1,dim);
            C.V = zeros(1,dim);

            k = 1;
            for i=[1:1:C.n]
                C.I(i) = k;
                for j=[1:1:C.n]
                    if M(i,j) ~= 0
                        C.V(k) = M(i,j);
                        C.J(k) = j;
                        k = k + 1;
                    end
                end
            end
            C.I(C.n+1) = k;
        %     % test
        %     assert(C.I(dims(1)+1) == dim+1);
        % 
        %     for k=[1:1:dim]
        %         j = C.J(k);
        %         i = 1;
        %         while C.I(i) <= k
        %             i = i+1;
        %         end
        %         i = i-1;
        %         assert(C.V(k) == M(i, j));
        %     end
        end
        function r = extractRow(C, i)
            r = zeros(1, C.n);
            first = C.I(i);
            last = C.I(i+1)-1;
            r(C.J(first:last)) = C.V(first:last);
        end
        function c = extractCol(C,j)
            c = zeros(C.n, 1);
            value_indices = find(C.J==j);
            values = C.V(value_indices)';
            k = 1;
            indices = zeros(1,length(value_indices));
            for i = [1:1:C.n]        
                if k <= length(value_indices) & value_indices(k) < C.I(i+1)
                    indices(k) = i;
                    k = k + 1;
                end
            end
            c(indices) = values;
        end
%         function C = update(C,i,j,v)
%             if isempty(C.I)
%                 
%             else
%                 column = [C.I(i):C.I(i+1)-1]
%                 k = find(j == C.J(column))
%                 if ~isempty(k)
%                     C.V(k) = v; 
%                 else
% 
%                     k = min(find(j > C.J(column)));
%                     C.J = [C.J(1:k-1), j, C.J(k:end)];
%                     C.V = [C.V(1:k-1), v, C.V(k:end)];
%                     C.I(i+1:end) = C.I(i+1:end) + 1;
%                 end
%             end
%         end
        function Y = matMulBy(C,X) 
            Y = CSR(C.n);
            k = 1;
            for i =[1:1:C.n]
                Y.I(i) = k;
                r = C.extractRow(i);
                for j = [1:1:C.n]
                    c = X.extractCol(j);
                    v = r * c;
                    if v ~= 0
                        Y.V(k) = v;
                        Y.J(k) = j;
                        k = k +1;
                    end
                end
            end
            Y.I(C.n+1) = k;
        end  
    end
end

        