function O=Map(func,V)     
    if isa(V,'cell')
        O=cellfun(func,V,'UniformOutput',false);
    else
        O=arrayfun(func,V,'UniformOutput',false);
    end
end
        