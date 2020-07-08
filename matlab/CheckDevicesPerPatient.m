TableOriIndex = ones(length(TableOri),1);
for i = 2:length(TableOri)
    for j = 1:i-1
        if TableOri{i,1} == TableOri{j,1} &&...
                    TableOri{i,9} == TableOri{j,9}&&...
                    TableOri{i,10} == TableOri{j,10}&&...
                    TableOri{i,11} == TableOri{j,11}&&...
                    TableOri{i,12} == TableOri{j,12}
                TableOriIndex(i) = 0;
        end
    end
end
TableOri = TableOri(logical(TableOriIndex),:);
Check = [1, zeros(1,length(TableOri)-1)];
for i = 2:length(TableOri)
    if TableOri{i,1} == TableOri{i-1,1} &&...
            TableOri{i,9} == TableOri{i-1,9}&&...
            TableOri{i,10} == TableOri{i-1,10}
        Check(i) = 1;
    elseif TableOri{i,1} ~= TableOri{i-1,1}
        Check(i) = 1;
    end
end
ChangedRaw = TableOri(logical(ones(1,length(TableOri))-Check),1);
Changed = ChangedRaw{1};
NumOfNewDevice = [];
NumOfNewDeviceCounter = 1;
for j = 2:length(ChangedRaw)
    if ChangedRaw{j} ~= ChangedRaw{j-1}
        Changed = [Changed ChangedRaw{j}];
        NumOfNewDevice = [NumOfNewDevice NumOfNewDeviceCounter];
        NumOfNewDeviceCounter = 1;
    else
        NumOfNewDeviceCounter = NumOfNewDeviceCounter+1;
    end
end
NumOfNewDevice = [NumOfNewDevice NumOfNewDeviceCounter];
ChangedList = [Changed;NumOfNewDevice]';