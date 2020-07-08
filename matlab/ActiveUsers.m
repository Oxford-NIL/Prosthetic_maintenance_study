%active users
Cell = table2cell(FinalTable);
LastRepairDate = cell(212,1);
for i = 1:212
    repairs = Cell{i,12};
    LastRepairDate(i) = repairs(1,1);
end
[T,I] = sort(datetime(LastRepairDate),'descend');
RepairDateTable = FinalTable(I,:);
Cell = Cell(I,:);
N18 = 0;
N17 = 0;
N16 = 0;
N15 = 0;
N14 = 0;
N13 = 0;
N12 = 0;
N18NEW = 0;
N17NEW = 0;
N16NEW = 0;
N15NEW = 0;
N14NEW = 0;
N13NEW = 0;
N12NEW = 0;
for j = 1:212
    Var = Cell{j,12};
    if contains(datestr(T(j)),"2018")
        N18 = N18+1;
        if size(Var) == [1 2] & Var(2) == "New Limb" 
            if contains(Cell{j,11},"2001") | datetime(Var{1}) <= datetime(Cell{j,11})
                N18NEW = N18NEW+1;
            end
        end
    elseif contains(datestr(T(j)),"2017")
        N17 = N17+1;
        if size(Var) == [1 2] & Var(2) == "New Limb"
            if contains(Cell{j,11},"2001") | datetime(Var{1}) <= datetime(Cell{j,11})
                N17NEW = N17NEW+1;
            end
        end
    elseif contains(datestr(T(j)),"2016")
        N16 = N16+1;
        if size(Var) == [1 2] & Var(2) == "New Limb"
            if contains(Cell{j,11},"2001") | datetime(Var{1}) <= datetime(Cell{j,11})
                N16NEW = N16NEW+1;
            end
        end
    elseif contains(datestr(T(j)),"2015")
        N15 = N15+1;
        if size(Var) == [1 2] & Var(2) == "New Limb"
            if contains(Cell{j,11},"2001") | datetime(Var{1}) <= datetime(Cell{j,11})
                N15NEW = N15NEW+1;
            end
        end
    elseif contains(datestr(T(j)),"2014")
        N14 = N14+1;
        if size(Var) == [1 2] & Var(2) == "New Limb"
            if contains(Cell{j,11},"2001") | datetime(Var{1}) <= datetime(Cell{j,11})
                N14NEW = N14NEW+1;
            end
        end
    elseif contains(datestr(T(j)),"2013")
        N13 = N13+1;
        if size(Var) == [1 2] & Var(2) == "New Limb"
            if contains(Cell{j,11},"2001") | datetime(Var{1}) <= datetime(Cell{j,11})
                N13NEW = N13NEW+1;
            end
        end
    elseif contains(datestr(T(j)),"2012")
        N12 = N12+1;
        if size(Var) == [1 2] & Var(2) == "New Limb"
            if contains(Cell{j,11},"2001") | datetime(Var{1}) <= datetime(Cell{j,11})
                N12NEW = N12NEW+1;
            end
        end
    end
end
figure(8)
hold on
bar([N18,N17,N16,N15,N14,N13+N12],0.5,'k')
bar(fliplr([N12NEW+N13NEW,N14NEW,N15NEW,N16NEW,N17NEW,N18NEW]),0.5,'w')
legend(["Repair (minor repair, major repair, supply of new items, and supply of new sockets)","Supply of new device and no other repair entries"],'fontsize',18)
title("Date of Last Contact",'fontsize',18)
xlabel('Year','fontsize',18)
ylabel('number of patients','fontsize',18)
xticks([1 2 3 4 5 6])
xticklabels(["2018","2017","2016","2015","2014","2013"])
set(gca,'fontsize',18)
grid on
grid minor
% %% active list by gender
% %active users
% Cell = table2cell(FinalTable);
% LastRepairDate = cell(212,1);
% for i = 1:212
%     repairs = Cell{i,12};
%     LastRepairDate(i) = repairs(end,1);
% end
% [T,I] = sort(datetime(LastRepairDate),'descend');
% RepairDateTable = FinalTable(I,:);
% Cell = Cell(I,:);
% N18M = 0;
% N17M = 0;
% N16M = 0;
% N15M = 0;
% N14M = 0;
% N13M = 0;
% N12M = 0;
% for j = 1:212
%     if contains(datestr(T(j)),"2018")
%         if Cell{j,4} == "Male"
%             N18M = N18M+1;
%         end
%     elseif contains(datestr(T(j)),"2017")
%         if Cell{j,4} == "Male"
%             N17M = N17M+1;
%         end
%     elseif contains(datestr(T(j)),"2016")
%         if Cell{j,4} == "Male"
%             N16M = N16M+1;
%         end
%     elseif contains(datestr(T(j)),"2015")
%         if Cell{j,4} == "Male"
%             N15M = N15M+1;
%         end
%     elseif contains(datestr(T(j)),"2014")
%         if Cell{j,4} == "Male"
%             N14M = N14M+1;
%         end
%     elseif contains(datestr(T(j)),"2013")
%         if Cell{j,4} == "Male"
%             N13M = N13M+1;
%         end
%     elseif contains(datestr(T(j)),"2012")
%         if Cell{j,4} == "Male"
%             N12M = N12M+1;
%         end
%     end
% end
% figure(9)
% hold on
% bar([N18,N17,N16,N15,N14,N13,N12],0.5,'k')
% bar(fliplr([N12M,N13M,N14M,N15M,N16M,N17M,N18M]),0.5,'w')
% legend(["Female","Male"],'fontsize',18)
% title("Date of Last Contact",'fontsize',18)
% xlabel('Year','fontsize',18)
% ylabel('number of patients','fontsize',18)
% xticks([1 2 3 4 5 6 7])
% xticklabels((["2018","2017","2016","2015","2014","2013","2012"]))
% set(gca,'fontsize',18)
% grid on
% grid minor