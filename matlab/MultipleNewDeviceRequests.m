%Multiple New Device Requests 18+
clear
clc
load('SeniorsTable.mat')
load('AdultsTable.mat')
Above18Table = [AdultsTable;SeniorsTable];
Above18Cell = table2cell(Above18Table);
Above18NewDeviceTable = [];
for i = 1:length(Above18Cell)
    repairs = Above18Cell{i,12};
%     repairs = repairs{1,1};
    if contains(repairs(:,2),"New Limb")
        Above18NewDeviceTable = [Above18NewDeviceTable ;Above18Table(i,:)];
    end
end
%% Multiple New Device Requests minors
load('MinorsTable.mat')
MinorCell = table2cell(MinorsTable);
MinorsNewDeviceTable = [];
for i = 1:length(MinorCell)
    repairs = MinorCell{i,12};
%     repairs = repairs{1,1};
    if contains(repairs(:,2),"New Limb")
        MinorsNewDeviceTable = [MinorsNewDeviceTable ;MinorsTable(i,:)];
    end
end
