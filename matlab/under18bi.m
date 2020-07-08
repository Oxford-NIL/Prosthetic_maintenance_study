for i = 1:size(TableOri,1)
    if TableOri{i,2} < 18 && TableOri{i,8} == "Bilateral"
        disp(TableOri{i,1})
    end
end
        