%% deduplicating
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
%% removing pre-2001 fittings
WO2001INDEX = ones(length(TableOri),1);
for i = 1:length(TableOri)
    if TableOri{i,5} == "Pre Nov 2001" || TableOri{i,5} == "Pre Nov 2002"
        WO2001INDEX(i) = 0;
    end
end
WO2001Table = TableOri(logical(WO2001INDEX),:);
%% reducing details
WO2001INDEX = ones(length(WO2001Table),1);
for i = 2:length(WO2001Table)
    if WO2001Table{i,1} == WO2001Table{i-1,1}
        WO2001INDEX(i) = 0;
    end
end
WO2001Table = WO2001Table(logical(WO2001INDEX),1:10);
%% taking out "unknown"
WO2001INDEX = ones(length(WO2001Table),1);
for i = 1:length(WO2001Table)
    if WO2001Table{i,4} == "Unknown" || WO2001Table{i,5} == "Unknown"
        WO2001INDEX(i) = 0;
    end
end
WO2001Table = WO2001Table(logical(WO2001INDEX),:);
%% Congenital list
CongenitalINDEX = zeros(size(WO2001Table,1),1);
for i = 1:size(WO2001Table,1)
    if WO2001Table{i,6} == "Congenital"
        CongenitalINDEX(i) = 1;
    end
end
CongenitalTable = WO2001Table(logical(CongenitalINDEX),:);
NonCongenitalTabel = WO2001Table(logical(ones(size(WO2001Table,1),1)-CongenitalINDEX),:);
%% remove pre-2001 amputees since this would bias our data after removing pre 2001 fittings
WO2001INDEX = ones(size(NonCongenitalTabel,1),1);
Cutoff = datetime("01/Nov/2001");
for i = 1:size(NonCongenitalTabel,1)
    if datetime(NonCongenitalTabel{i,4}) < Cutoff
        WO2001INDEX(i) = 0;
    end
end
NonCongenitalTabel = NonCongenitalTabel(logical(WO2001INDEX),:);
%% Non-congenital average time till first fitting
NonCongenitalTimeTillFirstFitting = zeros(size(NonCongenitalTabel,1),1);
for i = 1:size(NonCongenitalTabel,1)
    NonCongenitalTimeTillFirstFitting(i) = days(datetime(NonCongenitalTabel{i,5})-...
        datetime(NonCongenitalTabel{i,4}));
%     if NonCongenitalTimeTillFirstFitting(i) == 0
%         NonCongenitalTabel{i,1}
%         0
%     end
%     if NonCongenitalTimeTillFirstFitting(i) == 857
%         NonCongenitalTabel{i,1}
%         857
%     end
%     if NonCongenitalTimeTillFirstFitting(i) == 1256
%         NonCongenitalTabel{i,1}
%         1256
%     end
%     if NonCongenitalTimeTillFirstFitting(i) == 1625
%         NonCongenitalTabel{i,1}
%         1625
%     end
%     if NonCongenitalTimeTillFirstFitting(i) == 1821
%         NonCongenitalTabel{i,1}
%         1821
%     end
%     if NonCongenitalTimeTillFirstFitting(i) == 3192
%         NonCongenitalTabel{i,1}
%         3192
%     end
end
NCTTFFmean = mean(NonCongenitalTimeTillFirstFitting);
NCTTFFStD = std(NonCongenitalTimeTillFirstFitting);
%% quick check for congenital
EndDate = datetime("31/Dec/2018");
Diff = zeros(size(CongenitalTable,1),1);
AGE = zeros(size(CongenitalTable,1),1);
for i = 1:size(CongenitalTable,1)
    Diff(i) = years(EndDate - datetime(CongenitalTable{i,5}));
    AGE(i) = CongenitalTable{i,2};
%     if AGE(i)-Diff(i)+0.5>5
%         CongenitalTable{i,1}
%         AGE(i)-Diff(i)+0.5
%     end
end
CongenitalTimeTillFirstFitting = AGE(AGE<18)-Diff(AGE<18);
CTTFFmean = mean(CongenitalTimeTillFirstFitting(CongenitalTimeTillFirstFitting<5))+0.5; 
% +0.5 because we have their age but not bday
CTTFFStD = std(CongenitalTimeTillFirstFitting(CongenitalTimeTillFirstFitting<5));