classdef Toolbar
   methods(Static)
       function C=maxCrossAdd(A,B)
            C=zeros(size(A));
            index=A>B;
            C(index)=A(index);
            C(~index)=B(~index);
       end
       function C=minCrossAdd(A,B)
            C=zeros(size(A));
            index=A<B;
            C(index)=A(index);
            C(~index)=B(~index);
       end
       function W=WeightToCell(W)
                sizeW=size(W);
                W=mat2cell(W,ones(1,sizeW(1)), sizeW(2));
       end
       function R=fuzzyMul(W,X)
            W=Toolbar.WeightToCell(W);
            specificMCA=@(w_i) max(Toolbar.minCrossAdd(w_i,X'));
            R=cell2mat(Map(specificMCA,W));
       end
       function W=fuzzyMulPrime(W,Y,bias)
           Y_r=zeros(size(Y));
           Y_assign_idx=Y>0;
           Y_r(Y_assign_idx)=Y(Y_assign_idx)-bias(Y_assign_idx);
           getIndex=@ (w_i,y_i) (w_i-y_i)>0.005;
           IndexZero=cell2mat(cellfun(getIndex,Toolbar.WeightToCell(W),Toolbar.WeightToCell(Y_r),'UniformOutput',false));
           W(IndexZero)=0;
       end
       function y=OriRelu(x)
            y=zeros(size(x));
            index=x>0;
            y(index)=x(index);
       end
       
       function error=ErrorCal(y_pred,y_test,activationPrimeFunc)
                error= 2*(y_pred-y_test).* activationPrimeFunc(y_pred);
       end
       function ret=partial_gram(func,varagin)
        sizeV=numel(varagin);
        if isa(varagin(1),'cell')
            ret=cell(sizeV-1,1);
            for i=1:sizeV-1
                ret{i}=func(varagin{i},varagin{i+1});
            end
            return
        else
            ret=cell(sizeV-1,1);
            for i=1:sizeV-1
                ret{i}=func(varagin(i),varagin(i+1));
            end
            return
        end
    end
           
%         function y=PrimeRelu(x)
%             y=x>0;
%         end
   end
end