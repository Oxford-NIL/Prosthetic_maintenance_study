function [NType,Type] = Count(List)
    NList = length(List);
    m = 1;
    Type = [];
    NType = [];
    SortedList = sort(List);
    while m <= NList
        Counter = 0;
        n = m;
        while (n <= NList && SortedList(m) == SortedList(n))
            Counter = Counter+1;
            n = n+1;
        end
        Type = [Type; SortedList(m)];
        NType = [NType; Counter];
        m = n;
    end
end