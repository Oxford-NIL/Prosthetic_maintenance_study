for i = 1:length(WO2001Table)
    DateOfFitting(i) = datetime(WO2001Table{i,5});
end
DateOfFittingSorted = datestr(sort(DateOfFitting));
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
for i = 1:length(WO2001Table)
    if contains(DateOfFittingSorted(i,:),"2003")
        New2003 = New2003+1;
    elseif contains(DateOfFittingSorted(i,:),"2004")
        New2004 = New2004+1;
    elseif contains(DateOfFittingSorted(i,:),"2005")
        New2005 = New2005+1;
    elseif contains(DateOfFittingSorted(i,:),"2006")
        New2006 = New2006+1;
    elseif contains(DateOfFittingSorted(i,:),"2007")
        New2007 = New2007+1;
    elseif contains(DateOfFittingSorted(i,:),"2008")
        New2008 = New2008+1;
    elseif contains(DateOfFittingSorted(i,:),"2009")
        New2009 = New2009+1;
    elseif contains(DateOfFittingSorted(i,:),"2010")
        New2010 = New2010+1;
    elseif contains(DateOfFittingSorted(i,:),"2011")
        New2011 = New2011+1;
    elseif contains(DateOfFittingSorted(i,:),"2012")
        New2012 = New2012+1;
    elseif contains(DateOfFittingSorted(i,:),"2013")
        New2013 = New2013+1;
    elseif contains(DateOfFittingSorted(i,:),"2014")
        New2014 = New2014+1;
    elseif contains(DateOfFittingSorted(i,:),"2015")
        New2015 = New2015+1;
    elseif contains(DateOfFittingSorted(i,:),"2016")
        New2016 = New2016+1;
    elseif contains(DateOfFittingSorted(i,:),"2017")
        New2017 = New2017+1;
    elseif contains(DateOfFittingSorted(i,:),"2018")
        New2018 = New2018+1;
    end
end
NewcomerList = [["2003";"2004";"2005";"2006";"2007";"2008";"2009";"2010";"2011";"2012";...
    "2013";"2014";"2015";"2016";"2017";"2018"],...
    [New2003;New2004;New2005;New2006;New2007;New2008;New2009;New2010;New2011;...
    New2012;New2013;New2014;New2015;New2016;New2017;New2018;]];