function varagout=Reduce(func,varagin)
    function varagout=partial_reduce(varagin)
        sizeV=numel(varagin);
        if isa(varagin(1),'cell')
            varagout=varagin{1};
            for i=2:sizeV
                varagout=varagout+func(varagin{i});
            end
            return
        else
            varagout=varagin(1);
            for i=2:sizeV
                varagout=varagout+func(varagin(i));
            end
            return
        end
    end
    if any(size(varagin)==0)
        varagout=cell(0);
        return
    end
    varagout=cellfun(@partial_reduce,varagin,'UniformOutput',false);
    return 
end
