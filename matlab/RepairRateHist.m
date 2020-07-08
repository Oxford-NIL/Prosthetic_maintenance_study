% histogram(str2double(RepairRankedList(:,2)))
% xlabel("Visits per patient","fontsize",16)
% ylabel("Number of patients","fontsize",16)
% title("Visits per patient from Jan 2013 to Dec 2018","fontsize",20)
% grid on
% grid minor
% set(gca,"FontSize",16)
% median(str2double(RepairRankedList(:,2)))
%% fresh users joined post-2012
New2003 = 0;
New2004 = 0;
New2005 = 0;
New2006 = 0;
New2007 = 0;
New2008 = 0;
New2009 = 0;
New2010 = 0;
New2011 = 0;
New2012 = 0;
New2013 = 0;
New2014 = 0;
New2015 = 0;
New2016 = 0;
New2017 = 0;
New2018 = 0;
PATIENTFIELDNAMES = fieldnames(S_Patient);
for i = 1:length(PATIENTFIELDNAMES)
    TEMPFIELDNAMES = fieldnames(S_Patient.(PATIENTFIELDNAMES{i}));
    TEMPFITTINGDATES = [];
    for j = 1:length(TEMPFIELDNAMES)
        for k = 1:size(S_Patient.(PATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}),1)
            if contains(S_Patient.(PATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){k,5},"Pre")
                TEMPFITTINGDATES = [TEMPFITTINGDATES S_Patient.(PATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){k,5}];
            elseif ~contains(S_Patient.(PATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){k,5},"Unknown")
                TEMPFITTINGDATES = [TEMPFITTINGDATES datetime(S_Patient.(PATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){k,5})];
            end
        end
    end
    if isempty(TEMPFITTINGDATES)
        TEMPFITTINGDATES = "Unknown";
    elseif isdatetime(TEMPFITTINGDATES(1))
        TEMPFITTINGDATES = sort(TEMPFITTINGDATES);
        TEMPFITTINGDATES = datestr(TEMPFITTINGDATES(1));
    end
    if contains(TEMPFITTINGDATES,"2013")|...
            contains(TEMPFITTINGDATES,"2014")|...
            contains(TEMPFITTINGDATES,"2015")|...
            contains(TEMPFITTINGDATES,"2016")
        S_13to16.(PATIENTFIELDNAMES{i}) = S_Patient.(PATIENTFIELDNAMES{i});
    elseif contains(TEMPFITTINGDATES,"2017")|...
            contains(TEMPFITTINGDATES,"2018")
        S_17to18.(PATIENTFIELDNAMES{i}) = S_Patient.(PATIENTFIELDNAMES{i});
    else 
        S_MoreThan6Years.(PATIENTFIELDNAMES{i}) = S_Patient.(PATIENTFIELDNAMES{i});
    end
    if contains(TEMPFITTINGDATES,"2003")
        New2003 = New2003+1;
    elseif contains(TEMPFITTINGDATES,"2004")
        New2004 = New2004+1;
    elseif contains(TEMPFITTINGDATES,"2005")
        New2005 = New2005+1;
    elseif contains(TEMPFITTINGDATES,"2006")
        New2006 = New2006+1;
    elseif contains(TEMPFITTINGDATES,"2007")
        New2007 = New2007+1;
    elseif contains(TEMPFITTINGDATES,"2008")
        New2008 = New2008+1;
    elseif contains(TEMPFITTINGDATES,"2009")
        New2009 = New2009+1;
    elseif contains(TEMPFITTINGDATES,"2010")
        New2010 = New2010+1;
    elseif contains(TEMPFITTINGDATES,"2011")
        New2011 = New2011+1;
    elseif contains(TEMPFITTINGDATES,"2012")
        New2012 = New2012+1;
    elseif contains(TEMPFITTINGDATES,"2013")
        New2013 = New2013+1;
    elseif contains(TEMPFITTINGDATES,"2014")
        New2014 = New2014+1;
    elseif contains(TEMPFITTINGDATES,"2015")
        New2015 = New2015+1;
    elseif contains(TEMPFITTINGDATES,"2016")
        New2016 = New2016+1;
    elseif contains(TEMPFITTINGDATES,"2017")
        New2017 = New2017+1;
    elseif contains(TEMPFITTINGDATES,"2018")
        New2018 = New2018+1;
    end  
end
%%
FRESHPATIENTFIELDNAMES = fieldnames(S_13to16);
NumberOfRepairsPerYear = [];
for i = 1:length(FRESHPATIENTFIELDNAMES)
    TEMPFIELDNAMES = fieldnames(S_13to16.(FRESHPATIENTFIELDNAMES{i}));
    TEMPFITTINGDATES = [];
    TempNumberOfRepairs = 0;
    for j = 1:length(TEMPFIELDNAMES)
        for k = 1:size(S_13to16.(FRESHPATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}),1)
            if ~contains(S_13to16.(FRESHPATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){k,5},"Unknown")
                TEMPFITTINGDATES = [TEMPFITTINGDATES datetime(S_13to16.(FRESHPATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){k,5})];
            end
        end
        TempNumberOfRepairs = TempNumberOfRepairs + size(S_13to16.(FRESHPATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}),1);
    end
    TEMPFITTINGDATES = sort(TEMPFITTINGDATES);
    TimeOfPossessoin = days(datetime("31/Dec/2018") - TEMPFITTINGDATES(1))/365;
    NumberOfRepairsPerYear = [NumberOfRepairsPerYear TempNumberOfRepairs/TimeOfPossessoin];
end
LongTermPATIENTFIELDNAMES = fieldnames(S_MoreThan6Years);
for i = 1:length(LongTermPATIENTFIELDNAMES)
    TEMPFIELDNAMES = fieldnames(S_MoreThan6Years.(LongTermPATIENTFIELDNAMES{i}));
    TempNumberOfRepairs = 0;
    for j = 1:length(TEMPFIELDNAMES)
        TempNumberOfRepairs = TempNumberOfRepairs + size(S_MoreThan6Years.(LongTermPATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}),1);
    end
    TimeOfPossessoin = 6;
    NumberOfRepairsPerYear = [NumberOfRepairsPerYear TempNumberOfRepairs/TimeOfPossessoin];
end
hold on
yyaxis left
h = histogram(NumberOfRepairsPerYear,[0:0.5:12]);
x=[];
y=[];
for i = 1:length(h.Values)
    if h.Values(i) ~= 0 
        x=[x i];
        if i == 1
            y=[y 100.*(h.Values(i))./sum(h.Values)];
        else
            y=[y 100.*(h.Values(i))./sum(h.Values)+y(end)];
        end
    end
end
yyaxis right
ylim([0 100])
p1=plot((x./2)-0.25,y,"--o");
p2=plot([0,12],[80,80],"-");
xlabel("Frequency of annual visits per patient","fontsize",16)
ylabel("Percentage of patients (%)")
set(get(gca,'ylabel'),"Rotation",270)
title(["Pareto analysis of frequency of annual visits per patient from Jan 2013 to Dec 2018"; "for patients with at least two years of prosthetics usage"],"fontsize",20)
yyaxis left
ylabel("Number of patients","fontsize",16)
grid on
grid minor
set(gca,"FontSize",16)
xlim([0,12])
xticks([0:0.5:12])
median(NumberOfRepairsPerYear)
legend([p1,p2],["Cumulative %","80 percent cutoff"])
%%
% FreshPatientP1 = [];
% FreshPatientP2 = [];
% FreshPatientP3 = [];
% FreshPatientB1 = [];
% FreshPatientB2 = [];
% FreshPatientB3 = [];
% FreshPatientE1 = [];
% FreshPatientE2 = [];
% FreshPatientE3 = [];
% FRESHPATIENTFIELDNAMES = fieldnames(S_13to15);
% for i = 1:length(FRESHPATIENTFIELDNAMES)
%     TEMPFIELDNAMES = fieldnames(S_13to15.(FRESHPATIENTFIELDNAMES{i}));
%     TEMPFITTINGDATES = [];
%     for j = 1:length(TEMPFIELDNAMES)
%         for k = 1:size(S_13to15.(FRESHPATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}),1)
%             TEMPFITTINGDATES = [TEMPFITTINGDATES datetime(S_13to16.(PATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){k,5})];
%         end
%     end
%     TEMPFITTINGDATES = sort(TEMPFITTINGDATES);
%     TEMPFITTINGDATES = datestr(TEMPFITTINGDATES(1));
%     
%     np = size(FreshPatientP1,2)+1;
%     nb = size(FreshPatientB1,2)+1;
%     ne = size(FreshPatientE1,2)+1;
%     
%     TempRepairCountP = zeros(5,3); %X = repair type Y = years of possession
%     TempRepairCountB = zeros(5,3);
%     TempRepairCountE = zeros(5,3);
%     
%     for j = 1:length(TEMPFIELDNAMES)
%         if contains(TEMPFIELDNAMES{j},"Passive")
%             for k = 1:size(S_13to15.(FRESHPATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}),1)
%                 if days(datetime(S_13to15.(FRESHPATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){k,12})-...
%                         datetime(S_13to15.(FRESHPATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){k,5}))/365 < 1
%                     if S_13to15.(FRESHPATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){k,11} == "Minor Repair"
%                         TempRepairCountP(1,1) = TempRepairCountP(1,1)+1;
%                     elseif S_13to15.(FRESHPATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){k,11} == "Major Repair"
%                         TempRepairCountP(2,1) = TempRepairCountP(2,1)+1;
%                     elseif S_13to15.(FRESHPATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){k,11} == "Supply of Item"
%                         TempRepairCountP(3,1) = TempRepairCountP(3,1)+1;
%                     elseif S_13to15.(FRESHPATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){k,11} == "New Socket"
%                         TempRepairCountP(4,1) = TempRepairCountP(4,1)+1;
%                     elseif S_13to15.(FRESHPATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){k,11} == "New Limb"
%                         TempRepairCountP(5,1) = TempRepairCountP(5,1)+1;
%                     end
%                 elseif days(datetime(S_13to15.(FRESHPATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){k,12})-...
%                         datetime(S_13to15.(FRESHPATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){k,5}))/365 < 2 &&...
%                         days(datetime(S_13to15.(FRESHPATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){k,12})-...
%                         datetime(S_13to15.(FRESHPATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){k,5}))/365 > 1
%                     if S_13to15.(FRESHPATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){k,11} == "Minor Repair"
%                         TempRepairCountP(1,2) = TempRepairCountP(1,2)+1;
%                     elseif S_13to15.(FRESHPATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){k,11} == "Major Repair"
%                         TempRepairCountP(2,2) = TempRepairCountP(2,2)+1;
%                     elseif S_13to15.(FRESHPATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){k,11} == "Supply of Item"
%                         TempRepairCountP(3,2) = TempRepairCountP(3,2)+1;
%                     elseif S_13to15.(FRESHPATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){k,11} == "New Socket"
%                         TempRepairCountP(4,2) = TempRepairCountP(4,2)+1;
%                     elseif S_13to15.(FRESHPATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){k,11} == "New Limb"
%                         TempRepairCountP(5,2) = TempRepairCountP(5,2)+1;
%                     end
%                 elseif days(datetime(S_13to15.(FRESHPATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){k,12})-...
%                         datetime(S_13to15.(FRESHPATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){k,5}))/365 < 3 &&...
%                         days(datetime(S_13to15.(FRESHPATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){k,12})-...
%                         datetime(S_13to15.(FRESHPATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){k,5}))/365 > 2
%                     if S_13to15.(FRESHPATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){k,11} == "Minor Repair"
%                         TempRepairCountP(1,3) = TempRepairCountP(1,3)+1;
%                     elseif S_13to15.(FRESHPATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){k,11} == "Major Repair"
%                         TempRepairCountP(2,3) = TempRepairCountP(2,3)+1;
%                     elseif S_13to15.(FRESHPATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){k,11} == "Supply of Item"
%                         TempRepairCountP(3,3) = TempRepairCountP(3,3)+1;
%                     elseif S_13to15.(FRESHPATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){k,11} == "New Socket"
%                         TempRepairCountP(4,3) = TempRepairCountP(4,3)+1;
%                     elseif S_13to15.(FRESHPATIENTFIELDNAMES{i}).(TEMPFIELDNAMES{j}){k,11} == "New Limb"
%                         TempRepairCountP(5,3) = TempRepairCountP(5,3)+1;
%                     end