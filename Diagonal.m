classdef Diagonal < CompactFormat
    properties
        DIAG
        IOFF
    end
    methods
        function C = Compact(C,M)
        % This methods produces the compact representation in diagonal format of a given matrix 
            C.n = height(M);
            [C.DIAG, C.IOFF] = spdiags(M);
            for i = [1: length(C.IOFF)]
                if C.IOFF(i) > 0
                    C.DIAG(:,i) = circshift(C.DIAG(:,i), [-C.IOFF(i) 0]);
                end
            end
        end
        function r = extractRow(C,i)
            r = zeros(1,C.n);
            for k = [1:1:C.n]
                diagj = find(C.IOFF == k-i);
                if ~ isempty(diagj)
                    if C.IOFF(diagj) < 0
                        diagi = i + C.IOFF(diagj);
                    else
                        diagi = i;
                    end
                    if diagi > 0
                        r(k) = C.DIAG(diagi, diagj);
                    end
                end
         
            end
        end
        function c = extractCol(C,j)
            c = zeros(C.n, 1);
            for k = [1:1:C.n]
                diagj = find(C.IOFF == j-k);
                if ~ isempty(diagj)
                    if C.IOFF(diagj) <= 0
                        diagi = j;
                    else
                        diagi = j - C.IOFF(diagj);
                    end
                    if diagi > 0
                        c(k,1) = C.DIAG(diagi, diagj);
                    end
                end
         
            end
        end
        function Y = matMulBy(C,X) 
            Y = Diagonal(C.n);
            Y.DIAG = zeros(C.n,1);
            for i =[1:1:C.n]
                r = C.extractRow(i);
                for j = [1:1:C.n]
                    c = X.extractCol(j);
                    v = r * c;
                    if v ~= 0
                        if isempty(Y.IOFF)
                            diagj = 1;
                            Y.IOFF = j-i;
                        else
                            diagj = find(j-i == Y.IOFF);
                            if isempty(diagj)
                                diagj = min(find(Y.IOFF > j-i));
                                Y.IOFF = [Y.IOFF(1:diagj-1), j-i, Y.IOFF(diagj:end)];
                                Y.DIAG = [Y.DIAG(:,1:diagj-1), zeros(height(Y.DIAG),1), Y.DIAG(:,diagj:end)];
                            end
                        end
                        if j >= i
                            diagi = i;
                        else
                            diagi = i + Y.IOFF(diagj);
                        end
                        Y.DIAG(diagi, diagj) = v;
                    end
                end
            end
        end
    end
end
