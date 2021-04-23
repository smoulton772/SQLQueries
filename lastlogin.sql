--Where User is active in system and disabloed in the other 
USE CMX_Accounting


--TempTables


IF OBJECT_ID('tempdb..#TempTable') IS NOT NULL
    DROP TABLE #TempTable



CREATE TABLE #TempTable
(
    [Id] NVARCHAR(100),
    [System] NVARCHAR(100),
    [FirstName] NVARCHAR(100),
    [LastName] NVARCHAR(100),
    [UserEmail] NVARCHAR(100),
    [Station] NVARCHAR(100),
    [LastLogin] NVARCHAR(100),
    [DisabledOn] NVARCHAR(100),
    [Comment] NVARCHAR(100),
    [DateCreated] NVARCHAR(100)
)



INSERT INTO #TempTable
(
    [Id],
    [System],
    [FirstName],
    [LastName],
    [UserEmail],
    [Station],
    [LastLogin],
    [DisabledOn],
    [Comment],
    [DateCreated]
)


--Add new table below 
--Select * from CMX_Product_Users_***
SELECT *
FROM CMX_Product_Users_CCS
UNION
SELECT *
FROM CMX_Product_Users_LNC
UNION
SELECT *
FROM CMX_Product_Users_MGMS

--select * from #temptable order by UserEmail
--return


SELECT *
FROM
(
    SELECT ROW_NUMBER() OVER (PARTITION BY UserEmail ORDER BY  LastLogin DESC) Last_Login_Rank,
           *
    FROM #TempTable
) AS TempT
WHERE Last_Login_Rank = 1
ORDER BY UserEmail


IF OBJECT_ID('tempdb..#TempTable') IS NOT NULL
    DROP TABLE #TempTable




