clear
close
clc
load('TableOri.mat')
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
%%
Height = length(TableOri);
i = 1;
S_Details = struct;
S_NumberOfRepairs = struct;
while i <= Height
    Counter = 0;
    DateList = [];
    CategoryList = [];
    DateSort = [];
    j = i;
    while (j <= Height && TableOri{i,1} == TableOri{j,1})
        DateSort = [DateSort, datetime(TableOri{j,12})];
        DateList = [DateList, TableOri{j,12}];
        CategoryList = [CategoryList, TableOri{j,11}];
        Counter = Counter+1;
        j = j+1;
    end
    [~,I] = sort(DateSort);
    S_NumberOfRepairs.(TableOri{i,1}) = Counter;
    S_Details.(TableOri{i,1}).NumberOfRepairs = Counter;
    S_Details.(TableOri{i,1}).Age = TableOri{i,2};
    S_Details.(TableOri{i,1}).Gender = TableOri{i,3};
    S_Details.(TableOri{i,1}).DateOfAmputation = TableOri{i,4};
    S_Details.(TableOri{i,1}).CauseOfAmputation = TableOri{i,6};
    S_Details.(TableOri{i,1}).LevelOfAmputation = TableOri{i,7};
    S_Details.(TableOri{i,1}).Side = TableOri{i,8};
    S_Details.(TableOri{i,1}).TypeOfProsthesis = TableOri{i,9};
    S_Details.(TableOri{i,1}).TypeOfTerminalDevice = TableOri{i,10};
    S_Details.(TableOri{i,1}).DateOfFirstProstheticFitting = TableOri{i,5};
    S_Details.(TableOri{i,1}).Repair = [DateList(I);CategoryList(I)]';
    i = j;
end
%%
Patients = fieldnames(S_NumberOfRepairs);
NPatients = length(Patients);
counterlist = zeros(NPatients,1);
Agelist = zeros(NPatients,1);
for k = 1:NPatients
    counterlist(k) = S_NumberOfRepairs.(Patients{k,1});
    Agelist(k) = S_Details.(Patients{k,1}).Age;
    Genderlist(k) = S_Details.(Patients{k,1}).Gender;
    DateOfAmputationlist(k) = S_Details.(Patients{k,1}).DateOfAmputation;
    CauseOfAmputationlist(k) = S_Details.(Patients{k,1}).CauseOfAmputation;
    LevelOfAmputationlist(k) = S_Details.(Patients{k,1}).LevelOfAmputation;
    Sidelist(k) = S_Details.(Patients{k,1}).Side;
    TypeOfProsthesislist(k) = S_Details.(Patients{k,1}).TypeOfProsthesis;
    TypeOfTerminalDevicelist(k) = S_Details.(Patients{k,1}).TypeOfTerminalDevice;
    DateOfFirstProstheticFittinglist(k) = S_Details.(Patients{k,1}).DateOfFirstProstheticFitting;
    Repairlist(k) = {cellstr(S_Details.(Patients{k,1}).Repair)};
end

Genderlist = Genderlist';
DateOfAmputationlist = DateOfAmputationlist';
CauseOfAmputationlist = CauseOfAmputationlist';
LevelOfAmputationlist = LevelOfAmputationlist';
Sidelist = Sidelist';
TypeOfProsthesislist = TypeOfProsthesislist';
TypeOfTerminalDevicelist = replace(TypeOfTerminalDevicelist',["N/A","None"],"Unknown");
DateOfFirstProstheticFittinglist = DateOfFirstProstheticFittinglist';
Repairlist = Repairlist';

[~,Ind] = sort(counterlist,'descend');
RepairRankedList = [Patients(Ind) num2cell(counterlist(Ind)) num2cell(Agelist(Ind)) Genderlist(Ind)...
    DateOfAmputationlist(Ind) CauseOfAmputationlist(Ind) LevelOfAmputationlist(Ind)...
    Sidelist(Ind) TypeOfProsthesislist(Ind) TypeOfTerminalDevicelist(Ind)...
    DateOfFirstProstheticFittinglist(Ind)];
    
TitleList = ["Patients" "NumaberOfRepairs" "Age" "Gender"...
    "DateOfAmputation" "CauseOfAmputation" "LevelOfAmputation"...
    "Side" "TypeOfProsthesis" "TypeOfTerminalDevice" "DateOfFirstProstheticFitting"];
RepairTable = cell2table(Repairlist(Ind),'VariableNames',"Repairs");
OrganizedTable = [cell2table(cellstr(RepairRankedList),'VariableNames',cellstr(TitleList)) RepairTable];
%DeduplicatedTable
H = height(OrganizedTable);
DeduplicatedTable = OrganizedTable;
OverallDuplicats = 0;
FinalCell = table2cell(OrganizedTable);
for i = 1:H
    CurrentCell = FinalCell{i,12};
    [~,I] = sort(CurrentCell(:,2));
    CurrentCell = CurrentCell(I,:);
    Duplicats = 0;
    L = size(CurrentCell,1);
    if L>1
        DeduplicatedCell = CurrentCell(1,:);
        for j = 2:L
            if sprintf("%s",CurrentCell{j,1})==sprintf("%s",CurrentCell{j-1,1}) && sprintf("%s",CurrentCell{j,2})==sprintf("%s",CurrentCell{j-1,2})
                OverallDuplicats = OverallDuplicats+1;
                Duplicats = Duplicats+1;
            else
                DeduplicatedCell = [DeduplicatedCell;CurrentCell(j,:)];
            end
        end
        DeduplicatedTable{i,2} = cellstr(num2str(str2double(DeduplicatedTable{i,2})-Duplicats));
        [~,Ind] = sort(datetime(DeduplicatedCell(:,1)),'descend');
        DeduplicatedCell = DeduplicatedCell(Ind,:);
        DeduplicatedTable{i,12} = {DeduplicatedCell};
    end
end
counterlist = str2double(DeduplicatedTable{:,2});
[counterlist,INDEX] = sort(counterlist,'descend');
Agelist = Agelist(INDEX);
Genderlist = Genderlist(INDEX);
DateOfAmputationlist = DateOfAmputationlist(INDEX);
CauseOfAmputationlist = CauseOfAmputationlist(INDEX);
LevelOfAmputationlist = LevelOfAmputationlist(INDEX);
Sidelist = Sidelist(INDEX);
TypeOfProsthesislist = TypeOfProsthesislist(INDEX);
TypeOfTerminalDevicelist = TypeOfTerminalDevicelist(INDEX);
DateOfFirstProstheticFittinglist = DateOfFirstProstheticFittinglist(INDEX);
Repairlist = DeduplicatedTable{:,12};
Repairlist = Repairlist(INDEX);
FinalTable = DeduplicatedTable(INDEX,:);
%% age and gender
M0 = 0;
M10 = 0;
M20 = 0;
M30 = 0;
M40 = 0;
M50 = 0;
M60 = 0;
M70 = 0;
M80 = 0;
M90 = 0;
F0 = 0;
F10 = 0;
F20 = 0;
F30 = 0;
F40 = 0;
F50 = 0;
F60 = 0;
F70 = 0;
F80 = 0;
F90 = 0;
for l = 1:NPatients
    if Agelist(l)<=9
        if Genderlist(l) == "Male"
            M0 = M0+1;
        elseif Genderlist(l) == "Female"
            F0 = F0+1;
        else
            disp("warning")
        end
    elseif Agelist(l)>=10 && Agelist(l)<=19
        if Genderlist(l) == "Male"
            M10 = M10+1;
        elseif Genderlist(l) == "Female"
            F10 = F10+1;
        else
            disp("warning")
        end
    elseif Agelist(l)>=20 && Agelist(l)<=29
        if Genderlist(l) == "Male"
            M20 = M20+1;
        elseif Genderlist(l) == "Female"
            F20 = F20+1;
        else
            disp("warning")
        end
    elseif Agelist(l)>=30 && Agelist(l)<=39
        if Genderlist(l) == "Male"
            M30 = M30+1;
        elseif Genderlist(l) == "Female"
            F30 = F30+1;
        else
            disp("warning")
        end
    elseif Agelist(l)>=40 && Agelist(l)<=49
        if Genderlist(l) == "Male"
            M40 = M40+1;
        elseif Genderlist(l) == "Female"
            F40 = F40+1;
        else
            disp("warning")
        end
    elseif Agelist(l)>=50 && Agelist(l)<=59
        if Genderlist(l) == "Male"
            M50 = M50+1;
        elseif Genderlist(l) == "Female"
            F50 = F50+1;
        else
            disp("warning")
        end
    elseif Agelist(l)>=60 && Agelist(l)<=69
        if Genderlist(l) == "Male"
            M60 = M60+1;
        elseif Genderlist(l) == "Female"
            F60 = F60+1;
        else
            disp("warning")
        end
    elseif Agelist(l)>=70 && Agelist(l)<=79
        if Genderlist(l) == "Male"
            M70 = M70+1;
        elseif Genderlist(l) == "Female"
            F70 = F70+1;
        else
            disp("warning")
        end
    elseif Agelist(l)>=80 && Agelist(l)<=89
        if Genderlist(l) == "Male"
            M80 = M80+1;
        elseif Genderlist(l) == "Female"
            F80 = F80+1;
        else
            disp("warning")
        end
    elseif Agelist(l)>=90
        if Genderlist(l) == "Male"
            M90 = M90+1;
        elseif Genderlist(l) == "Female"
            F90 = F90+1;
        else
            disp("warning")
        end
    end
end
figure(1)
hold on
p11 = bar([1 2 3 4 5 6 7 8 9],[100.*[M0+F0 M10+F10 M20+F20 M30+F30 M40+F40 M50+F50 M60+F60 M70+F70 M80+F80+M90+F90]./...
    sum([M0+F0 M10+F10 M20+F20 M30+F30 M40+F40 M50+F50 M60+F60 M70+F70 M80+F80+M90+F90]);...
    100.*[27 27 54 56 47 29 43 36 10]./sum([27 27 54 56 47 29 43 36 10])],0.8,'k');
p12 = bar([1 2 3 4 5 6 7 8 9],[100.*[M0 M10 M20 M30 M40 M50 M60 M70 M80+M90]./...
    sum([M0+F0 M10+F10 M20+F20 M30+F30 M40+F40 M50+F50 M60+F60 M70+F70 M80+F80+M90+F90]);...
    100.*[10 12 31 33 34 22 35 25 8]./sum([27 27 54 56 47 29 43 36 10])],0.8,'w');
p111 = p11(:,1);
p121 = p12(:,1);
p111.FaceColor = [0.8500 0.3250 0.0980];
p121.FaceColor = [0 0.4470 0.7410];
ylim([0 20])
xticks([1 2 3 4 5 6 7 8 9])
xticklabels(["0-9" "10-19" "20-29" "30-39" "40-49" "50-59" "60-69" "70-79" "80+"])
xlabel('age (years)','fontsize',18)
ylabel('Percentage of Patients (%)','fontsize',18)
legend("Female (our study)","Female (Kyberd et al 1997)","Male (our study)","Male (Kyberd et al 1997)",'fontsize',18)
title(["Age Distribution of Patients"; "Left column: our study; Right column: Kyberd et al 1997"],'fontsize',18)
set(gca,'fontsize',18)
grid on
grid minor
NM = sum([M0 M10 M20 M30 M40 M50 M60 M70 M80 M90]);
NF = sum([F0 F10 F20 F30 F40 F50 F60 F70 F80 F90]);
%% Cause
[NCause, Cause] = Count(CauseOfAmputationlist);
NCauseNorm = NCause./sum(NCause);
NCauseLabel = cell(size(NCause));
for  m = 1:length(NCause)
    NCauseLabel{m} = strcat(num2str(NCause(m)),' (',num2str(round(NCauseNorm(m)*100)),'%)');
end
figure(2)
P1 = pie(NCause,NCauseLabel);
for n = 1:length(NCause)
    T = P1(n*2);
    T.FontSize = 14;
end
legend(Cause,'fontsize',16)
title("Cause of Upper Limb Loss/Absence (N = 212)",'fontsize',18)
%% Level
[NLevel,Level] = Count(LevelOfAmputationlist);
NLevelNorm = NLevel./sum(NLevel);
NLevelLabel = cell(size(NLevel));
LevelIndex = zeros(size(NLevel));
for o = 1:length(Level)
    if Level(o)=="Digits (fingers)"
        LevelIndex(1) = o;
    elseif Level(o)=="Partial Hand"
        LevelIndex(2) = o;
    elseif Level(o)=="Wrist Disarticulation"
        LevelIndex(3) = o;
    elseif Level(o)=="Trans-Radial"
        LevelIndex(4) = o;
    elseif Level(o)=="Elbow Disarticulation"
        LevelIndex(5) = o;
    elseif Level(o)=="Trans-Humeral"
        LevelIndex(6) = o;
    elseif Level(o)=="Shoulder Disarticulation"
        LevelIndex(7) = o;
    elseif Level(o)=="Forequarter"
        LevelIndex(8) = o;
    elseif Level(o)=="Upper Congenital Abnormality"
        LevelIndex(9) = o;
    end
end
for  m = 1:length(NLevel)
    NLevelLabel{m} = strcat(num2str(NLevel(m)),' (',num2str(round(NLevelNorm(m)*100)),'%)');
end
figure(3)
P2 = pie(NLevel(LevelIndex),NLevelLabel(LevelIndex));
for n = 1:length(NLevel)
    T = P2(n*2);
    T.FontSize = 14;
end
legend(Level(LevelIndex),'fontsize',16)
title("Level of Upper Limb Loss/Absence (N = 212)",'fontsize',18)
%% Type Of Prosthesis
[NToP,ToP] = Count(TypeOfProsthesislist);
NToPNorm = NToP./sum(NToP);
NToPLabel = cell(size(NToP));
for  m = 1:length(NToP)
    NToPLabel{m} = strcat(num2str(NToP(m)),' (',num2str(round(NToPNorm(m)*100)),'%)');
end
% figure(4)
% P3 = pie(NToP,NToPLabel);
% for n = 1:length(NToP)
%     T = P3(n*2);
%     T.FontSize = 14;
% end
% legend(ToP,'fontsize',16)
% title("Type Of Prosthesis (N = 212)",'fontsize',18)
%% Type Of Device
TypeOfDevicelist = strcat(TypeOfProsthesislist," ",TypeOfTerminalDevicelist);
[NToD,ToD] = Count(TypeOfDevicelist);
NToDNorm = NToD./sum(NToD);
NToDLabel = cell(size(NToD));
for  m = 1:length(NToD)
    NToDLabel{m} = strcat(num2str(NToD(m)),' (',num2str(round(NToDNorm(m)*100)),'%)');
end
% figure(5)
% P4 = pie(NToD,NToDLabel);
% for n = 1:length(NToD)
%     T = P4(n*2);
%     T.FontSize = 14;
% end
% legend(ToD,'fontsize',16)
% title("Type Of Device (N = 212)",'fontsize',18)
%% cause and gender
MCongenital = 0;
MDysvascular = 0;
MInfection = 0;
MNeoplasia = 0;
MNeurological = 0;
MTrauma = 0;
MUnknown = 0;
FCongenital = 0;
FDysvascular = 0;
FInfection = 0;
FNeoplasia = 0;
FNeurological = 0;
FTrauma = 0;
FUnknown = 0;
for l = 1:NPatients
    if CauseOfAmputationlist(l) == "Congenital"
        if Genderlist(l) == "Male"
            MCongenital = MCongenital+1;
        elseif Genderlist(l) == "Female"
            FCongenital = FCongenital+1;
        else
            disp("warning")
        end
    elseif CauseOfAmputationlist(l) == "Dysvascular " %weird space, watch out!
        if Genderlist(l) == "Male"
            MDysvascular = MDysvascular+1;
        elseif Genderlist(l) == "Female"
            FDysvascular = FDysvascular+1;
        else
            disp("warning")
        end
    elseif CauseOfAmputationlist(l) == "Infection"
        if Genderlist(l) == "Male"
            MInfection = MInfection+1;
        elseif Genderlist(l) == "Female"
            FInfection = FInfection+1;
        else
            disp("warning")
        end
    elseif CauseOfAmputationlist(l) == "Neoplasia"
        if Genderlist(l) == "Male"
            MNeoplasia = MNeoplasia+1;
        elseif Genderlist(l) == "Female"
            FNeoplasia = FNeoplasia+1;
        else
            disp("warning")
        end
    elseif CauseOfAmputationlist(l) == "Neurological"
        if Genderlist(l) == "Male"
            MNeurological = MNeurological+1;
        elseif Genderlist(l) == "Female"
            FNeurological = FNeurological+1;
        else
            disp("warning")
        end
    elseif CauseOfAmputationlist(l) == "Trauma"
        if Genderlist(l) == "Male"
            MTrauma = MTrauma+1;
        elseif Genderlist(l) == "Female"
            FTrauma = FTrauma+1;
        else
            disp("warning")
        end
    elseif CauseOfAmputationlist(l) == "Unknown"
        if Genderlist(l) == "Male"
            MUnknown = MUnknown+1;
        elseif Genderlist(l) == "Female"
            FUnknown = FUnknown+1;
        else
            disp("warning")
        end
    end
end

NCauseGender = [MCongenital+FCongenital MDysvascular+FDysvascular MInfection+FInfection MNeoplasia+FNeoplasia MNeurological+FNeurological MTrauma+FTrauma MUnknown+FUnknown];
NCauseMale = [MCongenital MDysvascular MInfection MNeoplasia MNeurological MTrauma MUnknown];

% cause and gender age restricted 0-18
MCongenital18 = 0;
MDysvascular18 = 0;
MInfection18 = 0;
MNeoplasia18 = 0;
MNeurological18 = 0;
MTrauma18 = 0;
MUnknown18 = 0;
FCongenital18 = 0;
FDysvascular18 = 0;
FInfection18 = 0;
FNeoplasia18 = 0;
FNeurological18 = 0;
FTrauma18 = 0;
FUnknown18 = 0;
for l = 1:NPatients
    if CauseOfAmputationlist(l) == "Congenital" && Agelist(l)<=18
        if Genderlist(l) == "Male"
            MCongenital18 = MCongenital18+1;
        elseif Genderlist(l) == "Female"
            FCongenital18 = FCongenital18+1;
        else
            disp("warning")
        end
    elseif CauseOfAmputationlist(l) == "Dysvascular " && Agelist(l)<=18
        if Genderlist(l) == "Male"
            MDysvascular18 = MDysvascular18+1;
        elseif Genderlist(l) == "Female"
            FDysvascular18 = FDysvascular18+1;
        else
            disp("warning")
        end
    elseif CauseOfAmputationlist(l) == "Infection" && Agelist(l)<=18
        if Genderlist(l) == "Male"
            MInfection18 = MInfection18+1;
        elseif Genderlist(l) == "Female"
            FInfection18 = FInfection18+1;
        else
            disp("warning")
        end
    elseif CauseOfAmputationlist(l) == "Neoplasia" && Agelist(l)<=18
        if Genderlist(l) == "Male"
            MNeoplasia18 = MNeoplasia18+1;
        elseif Genderlist(l) == "Female"
            FNeoplasia18 = FNeoplasia18+1;
        else
            disp("warning")
        end
    elseif CauseOfAmputationlist(l) == "Neurological" && Agelist(l)<=18
        if Genderlist(l) == "Male"
            MNeurological18 = MNeurological18+1;
        elseif Genderlist(l) == "Female"
            FNeurological18 = FNeurological18+1;
        else
            disp("warning")
        end
    elseif CauseOfAmputationlist(l) == "Trauma" && Agelist(l)<=18
        if Genderlist(l) == "Male"
            MTrauma18 = MTrauma18+1;
        elseif Genderlist(l) == "Female" && Agelist(l)<=18
            FTrauma18 = FTrauma18+1;
        else
            disp("warning")
        end
    elseif CauseOfAmputationlist(l) == "Unknown" && Agelist(l)<=18
        if Genderlist(l) == "Male"
            MUnknown18 = MUnknown18+1;
        elseif Genderlist(l) == "Female"
            FUnknown18 = FUnknown18+1;
        else
            disp("warning")
        end
    end
end
figure(6)
hold on
NCauseGenderB18 = [MCongenital18+FCongenital18 MDysvascular18+FDysvascular18 MInfection18+FInfection18 MNeoplasia18+FNeoplasia18 MNeurological18+FNeurological18 MTrauma18+FTrauma18 MUnknown18+FUnknown18];
NCauseMaleB18 = [MCongenital18 MDysvascular18 MInfection18 MNeoplasia18 MNeurological18 MTrauma18 MUnknown18];
NCauseGenderA18 = NCauseGender - NCauseGenderB18;
NCauseMaleA18 = NCauseMale - NCauseMaleB18;
[~,Index] = sort(NCauseGender,"descend");
NCauseAll = [NCauseGender;NCauseGenderA18;NCauseGenderB18];
NCauseMaleAll = [NCauseMale;NCauseMaleA18;NCauseMaleB18];
p61 = bar([1 2 3 4 5 6 7],NCauseAll(:,Index),0.8,'k');
p62 = bar([1 2 3 4 5 6 7],NCauseMaleAll(:,Index),0.8,'w');
xticks([1 2 3 4 5 6 7])
xticklabels(Cause(Index))
xlabel('Aetiology','fontsize',18)
ylabel('number of patients','fontsize',18)
legend([p61(:,1),p62(:,2)],"Female","Male",'fontsize',18)
title(["Cause of Upper Limb Loss/Absence";...
    "Left column: All patients; Middle column: Ages above 18; Right column: Ages under 18"],'fontsize',18)
set(gca,'fontsize',18)
grid on
grid minor
%% cause and gender and side
MLCongenital = 0;
MLDysvascular = 0;
MLInfection = 0;
MLNeoplasia = 0;
MLNeurological = 0;
MLTrauma = 0;
MLUnknown = 0;
FLCongenital = 0;
FLDysvascular = 0;
FLInfection = 0;
FLNeoplasia = 0;
FLNeurological = 0;
FLTrauma = 0;
FLUnknown = 0;

MRCongenital = 0;
MRDysvascular = 0;
MRInfection = 0;
MRNeoplasia = 0;
MRNeurological = 0;
MRTrauma = 0;
MRUnknown = 0;
FRCongenital = 0;
FRDysvascular = 0;
FRInfection = 0;
FRNeoplasia = 0;
FRNeurological = 0;
FRTrauma = 0;
FRUnknown = 0;

MBCongenital = 0;
MBDysvascular = 0;
MBInfection = 0;
MBNeoplasia = 0;
MBNeurological = 0;
MBTrauma = 0;
MBUnknown = 0;
FBCongenital = 0;
FBDysvascular = 0;
FBInfection = 0;
FBNeoplasia = 0;
FBNeurological = 0;
FBTrauma = 0;
FBUnknown = 0;
for l = 1:NPatients
    if CauseOfAmputationlist(l) == "Congenital"
        if Genderlist(l) == "Male"
            if Sidelist(l) == "Left"
                MLCongenital = MLCongenital+1;
            elseif Sidelist(l) == "Right"
                MRCongenital = MRCongenital+1;
            else
                MBCongenital = MBCongenital+1;
            end
        elseif Genderlist(l) == "Female"
            if Sidelist(l) == "Left"
                FLCongenital = FLCongenital+1;
            elseif Sidelist(l) == "Right"
                FRCongenital = FRCongenital+1;
            else
                FBCongenital = FBCongenital+1;
            end
        else
            disp("warning")
        end
    elseif CauseOfAmputationlist(l) == "Dysvascular " %weird space, watch out!
        if Genderlist(l) == "Male"
            if Sidelist(l) == "Left"
                MLDysvascular = MLDysvascular+1;
            elseif Sidelist(l) == "Right"
                MRDysvascular = MRDysvascular+1;
            else
                MBDysvascular = MBDysvascular+1;
            end
        elseif Genderlist(l) == "Female"
            if Sidelist(l) == "Left"
                FLDysvascular = FLDysvascular+1;
            elseif Sidelist(l) == "Right"
                FRDysvascular = FRDysvascular+1;
            else
                FBDysvascular = FBDysvascular+1;
            end
        else
            disp("warning")
        end
    elseif CauseOfAmputationlist(l) == "Infection"
        if Genderlist(l) == "Male"
            if Sidelist(l) == "Left"
                MLInfection = MLInfection+1;
            elseif Sidelist(l) == "Right"
                MRInfection = MRInfection+1;
            else
                MBInfection = MBInfection+1;
            end
        elseif Genderlist(l) == "Female"
            if Sidelist(l) == "Left"
                FLInfection = FLInfection+1;
            elseif Sidelist(l) == "Right"
                FRInfection = FRInfection+1;
            else
                FBInfection = FBInfection+1;
            end
        else
            disp("warning")
        end
    elseif CauseOfAmputationlist(l) == "Neoplasia"
        if Genderlist(l) == "Male"
            if Sidelist(l) == "Left"
                MLNeoplasia = MLNeoplasia+1;
            elseif Sidelist(l) == "Right"
                MRNeoplasia = MRNeoplasia+1;
            else
                MBNeoplasia = MBNeoplasia+1;
            end
        elseif Genderlist(l) == "Female"
            if Sidelist(l) == "Left"
                FLNeoplasia = FLNeoplasia+1;
            elseif Sidelist(l) == "Right"
                FRNeoplasia = FRNeoplasia+1;
            else
                FBNeoplasia = FBNeoplasia+1;
            end
        else
            disp("warning")
        end
    elseif CauseOfAmputationlist(l) == "Neurological"
        if Genderlist(l) == "Male"
            if Sidelist(l) == "Left"
                MLNeurological = MLNeurological+1;
            elseif Sidelist(l) == "Right"
                MRNeurological = MRNeurological+1;
            else
                MBNeurological = MBNeurological+1;
            end
        elseif Genderlist(l) == "Female"
            if Sidelist(l) == "Left"
                FLNeurological = FLNeurological+1;
            elseif Sidelist(l) == "Right"
                FRNeurological = FRNeurological+1;
            else
                FBNeurological = FBNeurological+1;
            end
        else
            disp("warning")
        end
    elseif CauseOfAmputationlist(l) == "Trauma"
        if Genderlist(l) == "Male"
            if Sidelist(l) == "Left"
                MLTrauma = MLTrauma+1;
            elseif Sidelist(l) == "Right"
                MRTrauma = MRTrauma+1;
            else
                MBTrauma = MBTrauma+1;
            end
        elseif Genderlist(l) == "Female"
            if Sidelist(l) == "Left"
                FLTrauma = FLTrauma+1;
            elseif Sidelist(l) == "Right"
                FRTrauma = FRTrauma+1;
            else
                FBTrauma = FBTrauma+1;
            end
        else
            disp("warning")
        end
    elseif CauseOfAmputationlist(l) == "Unknown"
        if Genderlist(l) == "Male"
            if Sidelist(l) == "Left"
                MLUnknown = MLUnknown+1;
            elseif Sidelist(l) == "Right"
                MRUnknown = MRUnknown+1;
            else
                MBUnknown = MBUnknown+1;
            end
        elseif Genderlist(l) == "Female"
            if Sidelist(l) == "Left"
                FLUnknown = FLUnknown+1;
            elseif Sidelist(l) == "Right"
                FRUnknown = FRUnknown+1;
            else
                FBUnknown = FBUnknown+1;
            end
        else
            disp("warning")
        end
    end
end
MCongenital = MLCongenital+MRCongenital+MBCongenital;
FCongenital = FLCongenital+FRCongenital+FBCongenital;
MDysvascular = MLDysvascular+MRDysvascular+MBDysvascular;
FDysvascular = FLDysvascular+FRDysvascular+FBDysvascular;
MInfection = MLInfection+MRInfection+MBInfection;
FInfection = FLInfection+FRInfection+FBInfection;
MNeoplasia = MLNeoplasia+MRNeoplasia+MBNeoplasia;
FNeoplasia = FLNeoplasia+FRNeoplasia+FBNeoplasia;
MNeurological = MLNeurological+MRNeurological+MBNeurological;
FNeurological = FLNeurological+FRNeurological+FBNeurological;
MTrauma = MLTrauma+MRTrauma+MBTrauma;
FTrauma = FLTrauma+FRTrauma+FBTrauma;
MUnknown = MLUnknown+MRUnknown+MBUnknown;
FUnknown = FLUnknown+FRUnknown+FBUnknown;

figure(60)
hold on
NCauseGender = [MCongenital+FCongenital MDysvascular+FDysvascular MInfection+FInfection...
    MNeoplasia+FNeoplasia MNeurological+FNeurological MTrauma+FTrauma MUnknown+FUnknown];
NCauseGenderSide = [MLCongenital+FLCongenital MLDysvascular+FLDysvascular MLInfection+FLInfection...
    MLNeoplasia+FLNeoplasia MLNeurological+FLNeurological MLTrauma+FLTrauma MLUnknown+FLUnknown;...
    MRCongenital+FRCongenital MRDysvascular+FRDysvascular MRInfection+FRInfection...
    MRNeoplasia+FRNeoplasia MRNeurological+FRNeurological MRTrauma+FRTrauma MRUnknown+FRUnknown;...
    MBCongenital+FBCongenital MBDysvascular+FBDysvascular MBInfection+FBInfection...
    MBNeoplasia+FBNeoplasia MBNeurological+FBNeurological MBTrauma+FBTrauma MBUnknown+FBUnknown];
NCauseMaleSide = [MLCongenital MLDysvascular MLInfection MLNeoplasia MLNeurological MLTrauma MLUnknown;...
    MRCongenital MRDysvascular MRInfection MRNeoplasia MRNeurological MRTrauma MRUnknown;...
    MBCongenital MBDysvascular MBInfection MBNeoplasia MBNeurological MBTrauma MBUnknown];
[~,Index] = sort(NCauseGender,"descend");
p601 = bar([1 2 3 4 5 6 7],NCauseGenderSide(:,Index),0.8,'k');
p602 = bar([1 2 3 4 5 6 7],NCauseMaleSide(:,Index),0.8,'w');
xticks([1 2 3 4 5 6 7])
xticklabels(Cause(Index))
xlabel('Aetiology','fontsize',18)
ylabel('number of patients','fontsize',18)
legend([p601(:,1),p602(:,1)],"Female","Male",'fontsize',18)
title(["Cause of Upper Limb Loss/Absence - All Patients";"Left column: Unilateral left; Middle column: Unilateral Right; Right column: Bilateral"],'fontsize',18)
set(gca,'fontsize',18)
grid on
grid minor
%% left right bi
MLEFT = 0;
FLEFT = 0;
MRIGHT = 0;
FRIGHT = 0;
MBI = 0;
FBI = 0;
for i = 1:length(RepairRankedList)
    if RepairRankedList{i,4} == "Male"
        if RepairRankedList{i,8} == "Left"
            MLEFT = MLEFT+1;
        elseif RepairRankedList{i,8} == "Right"
            MRIGHT = MRIGHT+1;
        elseif RepairRankedList{i,8} == "Bilateral"
            MBI = MBI+1;
        end
    else
        if RepairRankedList{i,8} == "Left"
            FLEFT = FLEFT+1;
        elseif RepairRankedList{i,8} == "Right"
            FRIGHT = FRIGHT+1;
        elseif RepairRankedList{i,8} == "Bilateral"
            FBI = FBI+1;
        end
    end
end
figure(8)
subplot(1,2,1)
hold on
bar([1 2 3], [100.*[MLEFT MRIGHT MBI]./sum([MLEFT MRIGHT MBI]);100.*[101 104 5]./sum([101 104 5])])
xticks([1 2 3])
xticklabels(["Unilateral (Left)" "Unilateral (Right)" "Bilateral"])
set(gca,'fontsize',18)
ylabel("Percentage of Patients",'fontsize',18)
title("Male",'fontsize',18)
grid on
grid minor
ylim([0 70])
legend(["Our study","Kyberd et al 1997"])
subplot(1,2,2)
hold on
bar([1 2 3], [100.*[FLEFT FRIGHT FBI]./sum([FLEFT FRIGHT FBI]);100.*[71 42 5]./sum([71 42 5])])
xticks([1 2 3])
xticklabels(["Unilateral (Left)" "Unilateral (Right)" "Bilateral"])
set(gca,'fontsize',18)
ylabel("Percentage of Patients",'fontsize',18)
title("Female",'fontsize',18)
grid on
grid minor
sgtitle("Patient Upper Limb Deficient Side Distribution Per Gender",'fontsize',18)
legend(["Our study","Kyberd et al 1997"])
