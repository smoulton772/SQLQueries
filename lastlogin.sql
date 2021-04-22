--add this to temptable 


Select * From (

Select  ROW_NUMBER() OVER (PARTITION BY Email order By Email, Anniversary DESC) Last_Login_Rank, * From #TempUsers

) As TempT

Where Last_Login_Rank = 1

Order By  DBName, Email