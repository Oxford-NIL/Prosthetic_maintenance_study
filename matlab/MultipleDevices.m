MULTIPLEDEVICEINDEX = [1,zeros(1,length(NumberOfDeviceList)-1)];
for i = 2 : length(NumberOfDeviceList)
    if NumberOfDeviceList{i,2}+NumberOfDeviceList{i,3}+NumberOfDeviceList{i,4} > 1
        MULTIPLEDEVICEINDEX(i) = 1;
    end
end
MoreThanOneDevicesList = NumberOfDeviceList(logical(MULTIPLEDEVICEINDEX),:);

MULTIPLETERMINALDEVICEINDEX = [1,zeros(1,length(NumberOfDeviceList)-1)];
for i = 2 : length(NumberOfDeviceList)
    if NumberOfDeviceList{i,5}+NumberOfDeviceList{i,6}+NumberOfDeviceList{i,7} > ...
            NumberOfDeviceList{i,2}+NumberOfDeviceList{i,3}+NumberOfDeviceList{i,4}
        MULTIPLETERMINALDEVICEINDEX(i) = 1;
    end
end
MoreThanOneTerminalDevicesList = NumberOfDeviceList(logical(MULTIPLETERMINALDEVICEINDEX),:);