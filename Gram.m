function varagout=Gram(func,varagin)
    function ret=partial_reduce(varagin)
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
    if any(size(varagin)==0)
        varagout=cell(0);
        return
    end
    if isa(varagin,'cell')
        varagout=cellfun(@partial_reduce,varagin,'UniformOutput',false);
    else
        varagout=arrayfun(@partial_reduce,varagin,'UniformOutput',false);
    end
end
