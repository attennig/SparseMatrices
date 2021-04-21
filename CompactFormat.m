classdef CompactFormat
    properties
        n
    end
    methods (Abstract)
        Compact(C,M)
        extractRow(C,i)
        extractCol(C,j)
        matMulBy(C,X)
    end 
    methods
        function C = CompactFormat(n)
            C.n = n;
        end
            
    end
end