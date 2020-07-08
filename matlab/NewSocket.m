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
NewSocketIndex = zeros(length(TableOri),1);
for i = 1:length(TableOri)
    if TableOri{i,11}== "New Socket" || TableOri{i,11}== "New Limb"
        NewSocketIndex(i) = 1;
    end
end
NewSocketDeviceRaw = TableOri(logical(NewSocketIndex),:);
PatientNum = NewSocketDeviceRaw{1,1};
PatientAge = NewSocketDeviceRaw{1,2};
PatientGender = NewSocketDeviceRaw{1,3};
PatientDoA = NewSocketDeviceRaw{1,4};
PatientDoF = NewSocketDeviceRaw{1,5};
PatientCoA = NewSocketDeviceRaw{1,6};
PatientSoA = NewSocketDeviceRaw{1,8};
PatientInfo = [NewSocketDeviceRaw{1,7}, NewSocketDeviceRaw{1,9},...
    NewSocketDeviceRaw{1,10}, NewSocketDeviceRaw{1,11}, NewSocketDeviceRaw{1,12}];
PatientsInfo = [];
if NewSocketDeviceRaw{1,11} == "New Socket"
    PatientNS = 1;
else PatientNS = 0;
end
PatientsNS = [];
for j = 2:size(NewSocketDeviceRaw,1)
    if  NewSocketDeviceRaw{j,1} == NewSocketDeviceRaw{j-1,1}
        PatientInfo = [PatientInfo;[NewSocketDeviceRaw{j,7},...
            NewSocketDeviceRaw{j,9}, NewSocketDeviceRaw{j,10},...
            NewSocketDeviceRaw{j,11}, NewSocketDeviceRaw{j,12}]];
        if NewSocketDeviceRaw{j,11} == "New Socket"
            PatientNS = PatientNS+1;
        end
    else PatientNum = [PatientNum; NewSocketDeviceRaw{j,1}];
        PatientAge = [PatientAge; NewSocketDeviceRaw{j,2}];
        PatientGender = [PatientGender; NewSocketDeviceRaw{j,3}];
        PatientDoA = [PatientDoA; NewSocketDeviceRaw{j,4}];
        PatientDoF = [PatientDoF; NewSocketDeviceRaw{j,5}];
        PatientCoA = [PatientCoA; NewSocketDeviceRaw{j,6}];
        PatientSoA = [PatientSoA; NewSocketDeviceRaw{j,8}];
        PatientsInfo = [PatientsInfo; {PatientInfo}];
        PatientInfo = [NewSocketDeviceRaw{j,7}, NewSocketDeviceRaw{j,9},...
            NewSocketDeviceRaw{j,10}, NewSocketDeviceRaw{j,11}, NewSocketDeviceRaw{j,12}];
        PatientsNS = [PatientsNS;PatientNS];
        if NewSocketDeviceRaw{1,11} == "New Socket"
            PatientNS = 1;
        else PatientNS = 0;
        end
    end
end
[~, AGEINDEX] = sort(PatientAge);
PatientsInfo = [PatientsInfo; {PatientInfo}];
PatientsNS = [PatientsNS;PatientNS];
NewSocketDevice = [cellstr(PatientNum(AGEINDEX)),num2cell(PatientAge(AGEINDEX)),...
    cellstr(PatientGender(AGEINDEX))...
    ,cellstr(PatientDoA(AGEINDEX)),cellstr(PatientDoF(AGEINDEX)),...
    cellstr(PatientCoA(AGEINDEX)),cellstr(PatientSoA(AGEINDEX)),...
    num2cell(PatientsNS(AGEINDEX)),PatientsInfo(AGEINDEX)];