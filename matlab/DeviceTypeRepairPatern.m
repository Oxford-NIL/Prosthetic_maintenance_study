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
%% Device types
DeviceTypes = [strcat(TableOri{1,9}," ",TableOri{1,10})];
for i = 2:size(TableOri,1)
    if sum(contains(DeviceTypes,strcat(TableOri{i,9}," ",TableOri{i,10}))) == 0
        DeviceTypes = [DeviceTypes;strcat(TableOri{i,9}," ",TableOri{i,10})];
    end
end
DeviceTypes = sort(DeviceTypes);
DeviceTypes = replace(DeviceTypes,"N/A","NA");
DeviceTypes = replace(DeviceTypes,"&","and");
DeviceTypes = replace(DeviceTypes," ","_");
%% reorganizing the table to combine entries
S_reorg = struct;
S_reorg.(replace(strcat(TableOri{1,1}," ",TableOri{1,9}," ",TableOri{1,10})," ","_")) = TableOri(1,:);
for i = 2:size(TableOri,1)
    if TableOri{i,10} == "N/A"
        TableOri{i,10} = "NA";
    end
    if TableOri{i,10} == "Hand & Hook"
        TableOri{i,10} = "Hand and Hook";
    end
    if sum(contains(fieldnames(S_reorg),replace(strcat(TableOri{i,1}," ",TableOri{i,9}," ",TableOri{i,10})," ","_"))) > 0
        S_reorg.(replace(strcat(TableOri{i,1}," ",TableOri{i,9}," ",TableOri{i,10})," ","_")) = ...
            [S_reorg.(replace(strcat(TableOri{i,1}," ",TableOri{i,9}," ",TableOri{i,10})," ","_"));TableOri(i,:)];
    else S_reorg.(replace(strcat(TableOri{i,1}," ",TableOri{i,9}," ",TableOri{i,10})," ","_")) = TableOri(i,:);
    end
end
FIELDNAMES = fieldnames(S_reorg);
% COUNT = 0;
% for i = 1:length(FIELDNAMES)
%     COUNT = COUNT + size(S_reorg.(FIELDNAMES{i}),1);
% end
%% Device category pie plot
DeviceCategories = ["Body-powered Hand or Hook";...
    "Body-powered Task-specific Device";...
    "Externally-powered Hand or Hook";...
    "Passive Hand or Hook";...
    "Passive Task-specific Device";...
    "Passive Digit(s)"];
DeviceCategoryCount = zeros(size(DeviceCategories));
for i = 1:length(FIELDNAMES)
    if contains(FIELDNAMES{i},DeviceTypes(2))
        DeviceCategoryCount(1) = DeviceCategoryCount(1)+2;
    elseif contains(FIELDNAMES{i},DeviceTypes(1))
        DeviceCategoryCount(1) = DeviceCategoryCount(1)+1;
    elseif contains(FIELDNAMES{i},DeviceTypes(3))
        DeviceCategoryCount(1) = DeviceCategoryCount(1)+1;
    elseif contains(FIELDNAMES{i},DeviceTypes(4))
        DeviceCategoryCount(2) = DeviceCategoryCount(2)+1;
    elseif contains(FIELDNAMES{i},DeviceTypes(5))
        DeviceCategoryCount(1) = DeviceCategoryCount(1)+1;
    elseif contains(FIELDNAMES{i},DeviceTypes(6))
        DeviceCategoryCount(3) = DeviceCategoryCount(3)+1;
    elseif contains(FIELDNAMES{i},DeviceTypes(7))
        DeviceCategoryCount(3) = DeviceCategoryCount(3)+1;
    elseif contains(FIELDNAMES{i},DeviceTypes(9))
        DeviceCategoryCount(4) = DeviceCategoryCount(4)+2;
    elseif contains(FIELDNAMES{i},DeviceTypes(8))
        DeviceCategoryCount(4) = DeviceCategoryCount(4)+1;
    elseif contains(FIELDNAMES{i},DeviceTypes(10))
        DeviceCategoryCount(4) = DeviceCategoryCount(4)+1;
    elseif contains(FIELDNAMES{i},DeviceTypes(11))
        DeviceCategoryCount(6) = DeviceCategoryCount(6)+1;
    elseif contains(FIELDNAMES{i},DeviceTypes(12))
        DeviceCategoryCount(4) = DeviceCategoryCount(4)+1;
    elseif contains(FIELDNAMES{i},DeviceTypes(13))
        DeviceCategoryCount(5) = DeviceCategoryCount(5)+1;
    end
end
for i = 1:size(DeviceCategoryCount,1)
    DeviceCategoryCountLabel(i) = strcat(num2str(DeviceCategoryCount(i))," (",num2str(round(100*DeviceCategoryCount(i)/sum(DeviceCategoryCount))),"%)");
end
figure(1)
PIE1 = pie(DeviceCategoryCount,DeviceCategoryCountLabel);
for i = 1:length(DeviceCategoryCount)
    T = PIE1(i*2);
    T.FontSize = 14;
end
title("Type Of Device",'fontsize',18)
legend(DeviceCategories,'fontsize',16)
%% number of people with multiple devices
S_Patient = struct;
for i = 1:size(FIELDNAMES,1)
    S_Patient.(S_reorg.(FIELDNAMES{i}){1,1}).(FIELDNAMES{i}) = S_reorg.(FIELDNAMES{i});
end
PATIENTFIELDNAMES = fieldnames(S_Patient);
BILATERALINDEX = zeros(size(PATIENTFIELDNAMES));
LEFTINDEX = zeros(size(PATIENTFIELDNAMES));
RIGHTINDEX = zeros(size(PATIENTFIELDNAMES));
BELOWELBOWINDEX = zeros(size(PATIENTFIELDNAMES));
ABOVEELBOWINDEX = zeros(size(PATIENTFIELDNAMES));
UCAINDEX = zeros(size(PATIENTFIELDNAMES));
for i = 1:size(PATIENTFIELDNAMES,1)
    TEMPFIELDNAMES = fieldnames(S_Patient.(PATIENTFIELDNAMES{i}));
    if S_Patient.(PATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{1}){1,8} == "Bilateral"
        BILATERALINDEX(i) = 1;
    end
    if S_Patient.(PATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{1}){1,8} == "Left"
        LEFTINDEX(i) = 1;
    end
    if S_Patient.(PATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{1}){1,8} == "Right"
        RIGHTINDEX(i) = 1;
    end
    if S_Patient.(PATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{1}){1,3} == "Male"
        MALEINDEX(i) = true;
    else
        MALEINDEX(i) = false;
    end
    if S_Patient.(PATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{1}){1,7} == "Digits (fingers)" ||...
            S_Patient.(PATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{1}){1,7} == "Partial Hand" ||...
            S_Patient.(PATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{1}){1,7} == "Wrist Disarticulation" ||...
            S_Patient.(PATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{1}){1,7} == "Trans-Radial"
        BELOWELBOWINDEX(i) = 1;
    elseif S_Patient.(PATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{1}){1,7} == "Upper Congenital Abnormality" 
        UCAINDEX(i) = 1;
    else
        ABOVEELBOWINDEX(i) = 1;
    end
    NumberOfPassiveDevices(i,1) = 0;
    NumberOfBodyPoweredDevices(i,1) = 0;
    NumberOfExternallyPoweredDevices(i,1) = 0;
    NumberOfPassiveTerminalDevices(i,1) = 0;
    NumberOfBodyPoweredTerminalDevices(i,1) = 0;
    NumberOfExternallyPoweredTerminalDevices(i,1) = 0;
    for j = 1:size(TEMPFIELDNAMES,1)
        if contains(TEMPFIELDNAMES{j},"Passive")
            NumberOfPassiveDevices(i,1) = 1;
            NumberOfPassiveTerminalDevices(i,1) = NumberOfPassiveTerminalDevices(i,1)+1;
        elseif contains(TEMPFIELDNAMES{j},"Body_powered")
            NumberOfBodyPoweredDevices(i,1) = 1;
            NumberOfBodyPoweredTerminalDevices(i,1) = NumberOfBodyPoweredTerminalDevices(i,1)+1;
        elseif contains(TEMPFIELDNAMES{j},"Externally_powered")
            NumberOfExternallyPoweredDevices(i,1) = 1;
            NumberOfExternallyPoweredTerminalDevices(i,1) = NumberOfExternallyPoweredTerminalDevices(i,1)+1;
        end
    end
end
BILATERALINDEX = logical(BILATERALINDEX);
BELOWELBOWINDEX = logical(BELOWELBOWINDEX);
ABOVEELBOWINDEX = logical(ABOVEELBOWINDEX);
UCAINDEX = logical(UCAINDEX);
NumberOfDeviceList = [{"Patient","Passive Devices","Body_powered Devices","Externally_powered Devices",...
    "Passive Terminal Devices","Body_powered Terminal Devices","Externally_powered Terminal Devices"};...
    [PATIENTFIELDNAMES,num2cell(NumberOfPassiveDevices),num2cell(NumberOfBodyPoweredDevices),...
    num2cell(NumberOfExternallyPoweredDevices),num2cell(NumberOfPassiveTerminalDevices),...
    num2cell(NumberOfBodyPoweredTerminalDevices),num2cell(NumberOfExternallyPoweredTerminalDevices)]];
NumberOfDevicePerPatient = NumberOfPassiveDevices+NumberOfBodyPoweredDevices+NumberOfExternallyPoweredDevices;
NumberOfTerminalDevicePerPatient = NumberOfPassiveTerminalDevices+NumberOfBodyPoweredTerminalDevices+NumberOfExternallyPoweredTerminalDevices;
% nonbilateral more than one device
sum(NumberOfDevicePerPatient(~BILATERALINDEX)>1)
sum((NumberOfTerminalDevicePerPatient(~BILATERALINDEX)-NumberOfDevicePerPatient(~BILATERALINDEX))>0)
% bilateral more than one device
sum(NumberOfDevicePerPatient(BILATERALINDEX)>2)
sum((NumberOfTerminalDevicePerPatient(BILATERALINDEX)-NumberOfDevicePerPatient(BILATERALINDEX))>0)


%% number of Devices by Age Group and Amputation Level
PATIENTINDEX = 1:size(PATIENTFIELDNAMES,1);
NumberOfMinorRepair = zeros(3,2,3); %X = P,BP,EP; Y = 18+,18-; Z = BE,AE,UCA;
NumberOfMajorRepair = zeros(3,2,3);
NumberOfSupplyOfItem = zeros(3,2,3);
NumberOfNewSocket = zeros(3,2,3);
NumberOfNewLimb = zeros(3,2,3);
for i = PATIENTINDEX
    TEMPFIELDNAMES = fieldnames(S_Patient.(PATIENTFIELDNAMES{i}));
    if S_Patient.(PATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{1}){1,2}>18
        BELOWELBOWAbove18INDEX(i) =  BELOWELBOWINDEX(i);
        ABOVEELBOWAbove18INDEX(i) = ABOVEELBOWINDEX(i);
        UCAAbove18INDEX(i) = UCAINDEX(i);
        BELOWELBOWBelow18INDEX(i) = false;
        ABOVEELBOWBelow18INDEX(i) = false;
        UCABelow18INDEX(i) = false;
    else
        BELOWELBOWAbove18INDEX(i) = false;
        ABOVEELBOWAbove18INDEX(i) = false;
        UCAAbove18INDEX(i) = false;
        BELOWELBOWBelow18INDEX(i) = BELOWELBOWINDEX(i);
        ABOVEELBOWBelow18INDEX(i) = ABOVEELBOWINDEX(i);
        UCABelow18INDEX(i) = UCAINDEX(i);
    end
end
NumberOfDevicesMatrix(1,1,1) = sum(NumberOfPassiveDevices(BELOWELBOWAbove18INDEX));
NumberOfDevicesMatrix(1,1,2) = sum(NumberOfPassiveDevices(ABOVEELBOWAbove18INDEX));
NumberOfDevicesMatrix(1,1,3) = sum(NumberOfPassiveDevices(UCAAbove18INDEX));
NumberOfDevicesMatrix(1,2,1) = sum(NumberOfPassiveDevices(BELOWELBOWBelow18INDEX));
NumberOfDevicesMatrix(1,2,2) = sum(NumberOfPassiveDevices(ABOVEELBOWBelow18INDEX));
NumberOfDevicesMatrix(1,2,3) = sum(NumberOfPassiveDevices(UCABelow18INDEX));

NumberOfDevicesMatrix(2,1,1) = sum(NumberOfBodyPoweredDevices(BELOWELBOWAbove18INDEX));
NumberOfDevicesMatrix(2,1,2) = sum(NumberOfBodyPoweredDevices(ABOVEELBOWAbove18INDEX));
NumberOfDevicesMatrix(2,1,3) = sum(NumberOfBodyPoweredDevices(UCAAbove18INDEX));
NumberOfDevicesMatrix(2,2,1) = sum(NumberOfBodyPoweredDevices(BELOWELBOWBelow18INDEX));
NumberOfDevicesMatrix(2,2,2) = sum(NumberOfBodyPoweredDevices(ABOVEELBOWBelow18INDEX));
NumberOfDevicesMatrix(2,2,3) = sum(NumberOfBodyPoweredDevices(UCABelow18INDEX));

NumberOfDevicesMatrix(3,1,1) = sum(NumberOfExternallyPoweredDevices(BELOWELBOWAbove18INDEX));
NumberOfDevicesMatrix(3,1,2) = sum(NumberOfExternallyPoweredDevices(ABOVEELBOWAbove18INDEX));
NumberOfDevicesMatrix(3,1,3) = sum(NumberOfExternallyPoweredDevices(UCAAbove18INDEX));
NumberOfDevicesMatrix(3,2,1) = sum(NumberOfExternallyPoweredDevices(BELOWELBOWBelow18INDEX));
NumberOfDevicesMatrix(3,2,2) = sum(NumberOfExternallyPoweredDevices(ABOVEELBOWBelow18INDEX));
NumberOfDevicesMatrix(3,2,3) = sum(NumberOfExternallyPoweredDevices(UCABelow18INDEX));
%% Prosthesis Types Pie
figure(2)
ProsthesisTypes = ["Body-powered arm";...
    "Externally-powered arm";...
    "Passive arm"];
ProsthesisTypeCount(1,1) = sum(NumberOfBodyPoweredDevices);
ProsthesisTypeCount(2,1) = sum(NumberOfExternallyPoweredDevices);
ProsthesisTypeCount(3,1) = sum(NumberOfPassiveDevices);
for i = 1:size(ProsthesisTypeCount,1)
    ProsthesisTypeCountLabel(i) = strcat(num2str(ProsthesisTypeCount(i))," (",num2str(round(100*ProsthesisTypeCount(i)/sum(ProsthesisTypeCount))),"%)");
end
PIE2 = pie(ProsthesisTypeCount,ProsthesisTypeCountLabel);
for i = 1:length(ProsthesisTypeCount)
    T = PIE2(i*2);
    T.FontSize = 14;
end
title("Type Of Prosthesis",'fontsize',18)
legend(ProsthesisTypes,'fontsize',16)
%% number of repairs
for i = PATIENTINDEX
    TEMPFIELDNAMES = fieldnames(S_Patient.(PATIENTFIELDNAMES{i}));
    for j = 1:size(TEMPFIELDNAMES,1)
        if contains(TEMPFIELDNAMES{j},"Passive")
            X = 1;
        elseif contains(TEMPFIELDNAMES{j},"Body_powered")
            X = 2;
        elseif contains(TEMPFIELDNAMES{j},"Externally_powered")
            X = 3;
        end
        
        if S_Patient.(PATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){1,2}>18
            Y = 1;
        else
            Y = 2;
        end
        
        if BELOWELBOWINDEX(i) == 1
            Z = 1;
        elseif ABOVEELBOWINDEX(i) == 1
            Z = 2;
        elseif UCAINDEX(i) == 1
            Z = 3;
        end
        
        for k = 1:size(S_Patient.(PATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}),1) 
            if S_Patient.(PATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){k,11} == "Minor Repair"
                NumberOfMinorRepair(X,Y,Z) = NumberOfMinorRepair(X,Y,Z)+1;
            elseif S_Patient.(PATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){k,11} == "Major Repair"
                NumberOfMajorRepair(X,Y,Z) = NumberOfMajorRepair(X,Y,Z)+1;
            elseif S_Patient.(PATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){k,11} == "Supply of Item"
                NumberOfSupplyOfItem(X,Y,Z) = NumberOfSupplyOfItem(X,Y,Z)+1;
            elseif S_Patient.(PATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){k,11} == "New Socket"
                NumberOfNewSocket(X,Y,Z) = NumberOfNewSocket(X,Y,Z)+1;
            elseif S_Patient.(PATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){k,11} == "New Limb"
                NumberOfNewLimb(X,Y,Z) = NumberOfNewLimb(X,Y,Z)+1;
            end
        end
    end
end
NumberOfMinorRepairNormalized = NumberOfMinorRepair./(NumberOfDevicesMatrix.*6);
NumberOfMajorRepairNormalized = NumberOfMajorRepair./(NumberOfDevicesMatrix.*6);
NumberOfSupplyOfItemNormalized = NumberOfSupplyOfItem./(NumberOfDevicesMatrix.*6);
NumberOfNewSocketNormalized = NumberOfNewSocket./(NumberOfDevicesMatrix.*6);
NumberOfNewLimbNormalized = NumberOfNewLimb./(NumberOfDevicesMatrix.*6);
figure(3)
subplot(3,2,1)
    bar([NumberOfMinorRepairNormalized(:,1,1)';NumberOfMajorRepairNormalized(:,1,1)';...
        NumberOfSupplyOfItemNormalized(:,1,1)';NumberOfNewSocketNormalized(:,1,1)';...
        NumberOfNewLimbNormalized(:,1,1)'])
    xticklabels({'minor repair','major repair','supply of item','new socket','new limb'})
    xtickangle(45)
    set(gca,'FontSize',14)
    title(["Below-elbow Category"; "(age \geq 18 years)"],'FontSize',12)
    legend(strcat("PA = ", num2str(NumberOfDevicesMatrix(1,1,1))),...
        strcat("BP = ", num2str(NumberOfDevicesMatrix(2,1,1))),...
        strcat("EP = ", num2str(NumberOfDevicesMatrix(3,1,1))),'FontSize',12)
    grid on
    grid minor
    ylim([0,0.8])
    ylabel("visits/patient/year")
subplot(3,2,3)
    bar([NumberOfMinorRepairNormalized(:,1,2)';NumberOfMajorRepairNormalized(:,1,2)';...
        NumberOfSupplyOfItemNormalized(:,1,2)';NumberOfNewSocketNormalized(:,1,2)';...
        NumberOfNewLimbNormalized(:,1,2)'])
    xticklabels({'minor repair','major repair','supply of item','new socket','new limb'})
    xtickangle(45)
    set(gca,'FontSize',14)
    title(["Above-elbow Category"; "(age \geq 18 years)"],'FontSize',12)
    legend(strcat("PA = ", num2str(NumberOfDevicesMatrix(1,1,2))),...
        strcat("BP = ", num2str(NumberOfDevicesMatrix(2,1,2))),...
        strcat("EP = ", num2str(NumberOfDevicesMatrix(3,1,2))),'FontSize',12)
    grid on
    grid minor
    ylim([0,0.8])
    ylabel("visits/patient/year")
subplot(3,2,5)
    bar([NumberOfMinorRepairNormalized(:,1,3)';NumberOfMajorRepairNormalized(:,1,3)';...
        NumberOfSupplyOfItemNormalized(:,1,3)';NumberOfNewSocketNormalized(:,1,3)';...
        NumberOfNewLimbNormalized(:,1,3)'])
    xticklabels({'minor repair','major repair','supply of item','new socket','new limb'})
    xtickangle(45)
    set(gca,'FontSize',14)
    title(["Upper Limb Congenital Abnormality Category"; "(age \geq 18 years)"],'FontSize',12)
    legend(strcat("PA = ", num2str(NumberOfDevicesMatrix(1,1,3))),...
        strcat("BP = ", num2str(NumberOfDevicesMatrix(2,1,3))),...
        strcat("EP = ", num2str(NumberOfDevicesMatrix(3,1,3))),'FontSize',12)
    grid on
    grid minor
    ylim([0,0.8])
    ylabel("visits/patient/year")
subplot(3,2,2)
    bar([NumberOfMinorRepairNormalized(:,2,1)';NumberOfMajorRepairNormalized(:,2,1)';...
        NumberOfSupplyOfItemNormalized(:,2,1)';NumberOfNewSocketNormalized(:,2,1)';...
        NumberOfNewLimbNormalized(:,2,1)'])
    xticklabels({'minor repair','major repair','supply of item','new socket','new limb'})
    xtickangle(45)
    set(gca,'FontSize',14)
    title(["Below-elbow Category"; "(age < 18 years)"],'FontSize',12)
    legend(strcat("PA = ", num2str(NumberOfDevicesMatrix(1,2,1))),...
        strcat("BP = ", num2str(NumberOfDevicesMatrix(2,2,1))),...
        strcat("EP = ", num2str(NumberOfDevicesMatrix(3,2,1))),'Location','northwest','FontSize',12)
    grid on
    grid minor
    ylim([0,0.8])
    ylabel("visits/patient/year")
subplot(3,2,4)
    bar([NumberOfMinorRepairNormalized(:,2,2)';NumberOfMajorRepairNormalized(:,2,2)';...
        NumberOfSupplyOfItemNormalized(:,2,2)';NumberOfNewSocketNormalized(:,2,2)';...
        NumberOfNewLimbNormalized(:,2,2)'])
    xticklabels({'minor repair','major repair','supply of item','new socket','new limb'})
    xtickangle(45)
    set(gca,'FontSize',14)
    title(["Above-elbow Category"; "(age < 18 years)"],'FontSize',12)
    legend(strcat("PA = ", num2str(NumberOfDevicesMatrix(1,2,2))),...
        strcat("BP = ", num2str(NumberOfDevicesMatrix(2,2,2))),...
        strcat("EP = ", num2str(NumberOfDevicesMatrix(3,2,2))),'Location','northwest','FontSize',12)
    grid on
    grid minor
    ylim([0,0.8])
    ylabel("visits/patient/year")
subplot(3,2,6)
    bar([NumberOfMinorRepairNormalized(:,2,3)';NumberOfMajorRepairNormalized(:,2,3)';...
        NumberOfSupplyOfItemNormalized(:,2,3)';NumberOfNewSocketNormalized(:,2,3)';...
        NumberOfNewLimbNormalized(:,2,3)'])
    xticklabels({'minor repair','major repair','supply of item','new socket','new limb'})
    xtickangle(45)
    set(gca,'FontSize',14)
    title(["Upper Limb Congenital Abnormality Category"; "(age < 18 years)"],'FontSize',12)
    legend(strcat("PA = ", num2str(NumberOfDevicesMatrix(1,2,3))),...
        strcat("BP = ", num2str(NumberOfDevicesMatrix(2,2,3))),...
        strcat("EP = ", num2str(NumberOfDevicesMatrix(3,2,3))),'Location','northwest','FontSize',12)
    grid on
    grid minor
    ylim([0,0.8])
    ylabel("visits/patient/year")
sgtitle(["Upper Limb Prosthetics Maintainance Data (Jan 2013 to Dec 2018; annual average)";...
    "Note: PA = Passive device; BP = Body-powered device; EP = Externally-powered device"],'FontSize',16)
%% New things interval
Below18INDEX = logical(BELOWELBOWBelow18INDEX+ABOVEELBOWBelow18INDEX+UCABelow18INDEX);
NewSocketInterval = [];
NewLimbInterval = [];
Under18IntervalAgeTable = [];
NewSocketBelow18Devices = 0;
NewLimbBelow18Devices = 0;
for i = PATIENTINDEX(Below18INDEX)
    TEMPFIELDNAMES = fieldnames(S_Patient.(PATIENTFIELDNAMES{i}));
    for j = 1:size(TEMPFIELDNAMES,1)
        TEMPDATESNewSocket = [];
        TEMPDATESNewLimb = [];
        for k = 1:size(S_Patient.(PATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}),1) 
            if S_Patient.(PATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){k,11} == "New Socket" 
                TEMPDATESNewSocket = [TEMPDATESNewSocket;datetime(S_Patient.(PATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){k,12})];
            elseif S_Patient.(PATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){k,11} == "New Limb"
                TEMPDATESNewLimb = [TEMPDATESNewLimb;datetime(S_Patient.(PATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){k,12})];
            end
        end
        if size((TEMPDATESNewSocket),1)>2
            TEMPDATESNewSocket = sort(TEMPDATESNewSocket);
            NewSocketInterval = [NewSocketInterval;diff(TEMPDATESNewSocket)];
            NewSocketBelow18Devices = NewSocketBelow18Devices+1;
        end
        if size((TEMPDATESNewLimb),1)>2
            TEMPDATESNewLimb = sort(TEMPDATESNewLimb);
            NewLimbInterval = [NewLimbInterval;diff(TEMPDATESNewLimb)];
            NewLimbBelow18Devices = NewLimbBelow18Devices+1;
            Under18IntervalAgeTable = [Under18IntervalAgeTable;S_Patient.(PATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){1,[1:2,8,9,10]}];
        end
    end
end
NewSocketInterval = minutes(NewSocketInterval)/60/24;
NewLimbInterval = minutes(NewLimbInterval)/60/24;

%% visits per device type
BodyPoweredVisits = 0;
PassiveVisits = 0;
ExternallyPoweredVisits = 0;
for i = 1:length(TableOri)
    if TableOri{i,9} == "Body powered"
        BodyPoweredVisits = BodyPoweredVisits+1;
    elseif TableOri{i,9} == "Passive"
        PassiveVisits = PassiveVisits +1;
    elseif TableOri{i,9} == "Externally powered"
        ExternallyPoweredVisits = ExternallyPoweredVisits+1;
    end
end
%% Type and gender number of repairs
PassiveMale = 0;
PassiveFemale = 0;
BodyPoweredMale = 0;
BodyPoweredFemale = 0;
ExternallyPoweredMale = 0;
ExternallyPoweredFemale = 0;
for i = 1:length(TableOri)
    if TableOri{i,9} == "Passive"
        if TableOri{i,3} == "Male"
            PassiveMale = PassiveMale+1;
        elseif TableOri{i,3} == "Female"
            PassiveFemale = PassiveFemale+1;
        end
    elseif TableOri{i,9} == "Body powered"
        if TableOri{i,3} == "Male"
            BodyPoweredMale = BodyPoweredMale+1;
        elseif TableOri{i,3} == "Female"
            BodyPoweredFemale = BodyPoweredFemale+1;
        end
    elseif TableOri{i,9} == "Externally powered"
        if TableOri{i,3} == "Male"
            ExternallyPoweredMale = ExternallyPoweredMale+1;
        elseif TableOri{i,3} == "Female"
            ExternallyPoweredFemale = ExternallyPoweredFemale+1;
        end
    end
end

%%
% figure(2)
% ProsthesisTypes = ["Body-powered arm";...
%     "Externally-powered arm";...
%     "Passive arm"];
% ProsthesisTypeCount(1,1) = DeviceCategoryCount(1)+DeviceCategoryCount(2);
% ProsthesisTypeCount(2,1) = DeviceCategoryCount(3);
% ProsthesisTypeCount(3,1) = DeviceCategoryCount(4)+DeviceCategoryCount(5)+DeviceCategoryCount(6);
% for i = 1:size(ProsthesisTypeCount,1)
%     ProsthesisTypeCountLabel(i) = strcat(num2str(ProsthesisTypeCount(i))," (",num2str(round(100*ProsthesisTypeCount(i)/sum(ProsthesisTypeCount))),"%)");
% end
% PIE2 = pie(ProsthesisTypeCount,ProsthesisTypeCountLabel);
% for i = 1:length(ProsthesisTypeCount)
%     T = PIE2(i*2);
%     T.FontSize = 14;
% end
% title("Type Of Prosthesis",'fontsize',18)
% legend(ProsthesisTypes,'fontsize',16)
% %% people who were first fitted after sep 2012
% After2013INDEX = ones(size(TableOri,1),1);
% ReferenceDate = datetime("01/Sep/2012");
% for i = 1:size(TableOri,1)
%     if TableOri{i,5} == "Pre Nov 2001" || TableOri{i,5} == "Pre Nov 2002" ||...
%             TableOri{i,5} == "Unknown" || datetime(TableOri{i,5}) < ReferenceDate
%         After2013INDEX(i) = 0;
%     end
% end
% After2013Table = TableOri(logical(After2013INDEX),:);
% Before2013Table = TableOri(logical(ones(size(TableOri,1),1)-After2013INDEX),:);
% %% people who were first fitted before sep 2012 but got new devices after sep 2012
% Before2013NDINDEX = zeros(size(Before2013Table,1),1);
% i = 1;
% TempINDEX = [];
% NEWLIMBINDICATOR = 0;
% while i <= size(Before2013NDINDEX,1)
%     if i == 1 || Before2013Table{i,1} == Before2013Table{i-1,1}
%         TempINDEX = [TempINDEX; i];
%         if Before2013Table{i,11} == "New Limb"
%             NEWLIMBINDICATOR = 1;
%         end
%         i = i+1;
%     else if NEWLIMBINDICATOR == 1
%             Before2013NDINDEX(TempINDEX) = 1;
%             NEWLIMBINDICATOR = 0;
%         end
%         TempINDEX = i;
%         i = i+1;
%     end
% end
% Before2013NDTable = Before2013Table(logical(Before2013NDINDEX),:);
% %% check number 0f patients
% % After2013Count = 1;
% % Before2013Count = 1;
% % After2013CountINDEX = 1;
% % Before2013CountINDEX = 1;
% % for i = 2:size(After2013Table,1)
% %     if After2013Table{i,1} ~= After2013Table{i-1,1}
% %         After2013Count = After2013Count+1;
% %         After2013CountINDEX = [After2013CountINDEX; i];
% %     end
% % end
% % After2013LofATable = After2013Table(After2013CountINDEX,7);
% % AUCACount = 0;
% % for i = 1:size(After2013LofATable,1)
% %     if After2013LofATable{i} == "Upper Congenital Abnormality"
% %         AUCACount = AUCACount+1;
% %     end
% % end
% % for i = 2:size(Before2013NDTable,1)
% %     if Before2013NDTable{i,1} ~= Before2013NDTable{i-1,1}
% %         Before2013Count = Before2013Count+1;
% %         Before2013CountINDEX = [Before2013CountINDEX; i];
% %     end
% % end
% % Before2013NDLofATable = Before2013NDTable(Before2013CountINDEX,7);
% % BUCACount = 0;
% % for i = 1:size(Before2013NDLofATable,1)
% %     if Before2013NDLofATable{i} == "Upper Congenital Abnormality"
% %         BUCACount = BUCACount+1;
% %     end
% % end
% %% After2013 Below and above 18
% After2013Below18INDEX = zeros(size(After2013Table,1),1);
% for i = 1:size(After2013Table,1)
%     if After2013Table{i,2} < 18
%         After2013Below18INDEX(i) = 1;
%     end
% end
% After2013Below18Table = After2013Table(logical(After2013Below18INDEX),:);
% After2013Above18Table = After2013Table(logical(ones(size(After2013Table,1),1)-After2013Below18INDEX),:);
% 
% %% Before2013ND Below and above 18
% Before2013NDBelow18INDEX = zeros(size(Before2013NDTable,1),1);
% for i = 1:size(Before2013NDTable,1)
%     if Before2013NDTable{i,2} < 18
%         Before2013NDBelow18INDEX(i) = 1;
%     end
% end
% Before2013NDBelow18Table = Before2013NDTable(logical(Before2013NDBelow18INDEX),:);
% Before2013NDAbove18Table = Before2013NDTable(logical(ones(size(Before2013NDTable,1),1)-Before2013NDBelow18INDEX),:);
% 
% % Passive
%     % below elbow
%     % aboove elbow
%     % UCA
% % Body-powered
%     % below elbow
%     % aboove elbow
%     % UCA
% % Extenally-powered
%     % below elbow
%     % aboove elbow
%     % UCA