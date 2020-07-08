StudyPatientAgeGender = [Agelist,Genderlist];
for i = 1:length(StudyPatientAgeGender)
    if Genderlist(i) == "Male"
        MaleINDEX(i) = true;
    else
        MaleINDEX(i) = false;
    end
    if CauseOfAmputationlist(i) == "Congenital"
        CongINDEX(i) = true;
    else
        CongINDEX(i) = false;
    end
end
%sum(BELOWELBOWINDEX((CongINDEX) & (~MaleINDEX)))
NonCongenitalTimeTillFirstFittingInWeeks = NonCongenitalTimeTillFirstFitting./7;
sort(NonCongenitalTimeTillFirstFittingInWeeks)