--add this to temptable 


SELECT *
FROM
(
    SELECT ROW_NUMBER() OVER (PARTITION BY Email ORDER BY Email, Anniversary DESC) Last_Login_Rank,
           *
    FROM #TempUsers
) AS TempT
WHERE Last_Login_Rank = 1
ORDER BY DBName,
         Email

         --google partition by row number