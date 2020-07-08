AgeMaleU18 = [];
AgeFemaleU18 = [];
AgeMaleA18 = [];
AgeFemaleA18 = [];
for i = 1:length(RepairRankedList)
    if str2double(RepairRankedList(i,3)) < 18
        if RepairRankedList(i,4) == "Male"
            AgeMaleU18 = [AgeMaleU18 str2double(RepairRankedList(i,3))];
        elseif RepairRankedList(i,4) == "Female"
            AgeFemaleU18 = [AgeFemaleU18 str2double(RepairRankedList(i,3))];
        end
    elseif str2double(RepairRankedList(i,3)) > 18
        if RepairRankedList(i,4) == "Male"
            AgeMaleA18 = [AgeMaleA18 str2double(RepairRankedList(i,3))];
        elseif RepairRankedList(i,4) == "Female"
            AgeFemaleA18 = [AgeFemaleA18 str2double(RepairRankedList(i,3))];
        end
    end
end

disp("AgeU18 = ")
disp([num2str(mean([AgeMaleU18,AgeFemaleU18])),"+/-",num2str(std([AgeMaleU18,AgeFemaleU18]))])
disp("AgeMaleU18 = ")
disp([num2str(mean(AgeMaleU18)),"+/-",num2str(std(AgeMaleU18))])
disp("AgeFemaleU18 = ")
disp([num2str(mean(AgeFemaleU18)),"+/-",num2str(std(AgeFemaleU18))])

disp("AgeA18 = ")
disp([num2str(mean([AgeMaleA18,AgeFemaleA18])),"+/-",num2str(std([AgeMaleA18,AgeFemaleA18]))])
disp("AgeMaleA18 = ")
disp([num2str(mean(AgeMaleA18)),"+/-",num2str(std(AgeMaleA18))])
disp("AgeFemaleA18 = ")
disp([num2str(mean(AgeFemaleA18)),"+/-",num2str(std(AgeFemaleA18))])

disp("AgeMale = ")
disp([num2str(mean([AgeMaleA18,AgeMaleU18])),"+/-",num2str(std([AgeMaleA18,AgeMaleU18]))])
disp("AgeFemale = ")
disp([num2str(mean([AgeFemaleA18,AgeFemaleU18])),"+/-",num2str(std([AgeFemaleA18,AgeFemaleU18]))])