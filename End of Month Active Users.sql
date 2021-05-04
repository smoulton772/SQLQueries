USE CMX_Accounting



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
    [DateCreated] NVARCHAR(100),
    [DateUploaded] NVARCHAR(100),
    [DoNotReport] NVARCHAR(100)
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
    [DateCreated],
    [DateUploaded],
    [DoNotReport]
)


--Add new table below 
SELECT *
FROM CMX_Product_Users_COM
UNION
SELECT *
FROM CMX_Product_Users_CCS
UNION
SELECT *
FROM CMX_Product_Users_LNC
UNION
SELECT *
FROM CMX_Product_Users_MGMS

--select * from #TempTable  where (DoNotReport is null or DoNotReport = 0) and (DisabledOn > DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0) or Disabledon is NUll)
--order by FirstName , LastName, UserEmail 

SELECT *
FROM
(
    SELECT ROW_NUMBER() OVER (PARTITION BY UserEmail ORDER BY LastLogin DESC) Last_Login_Rank,
           *
    FROM #TempTable
) AS TempT
WHERE Last_Login_Rank = 1
      AND
      (
          DoNotReport IS NULL
          OR DoNotReport = 0
      )
      AND
      (
          DisabledOn > DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0)
          OR Disabledon IS NULL
      )
      AND NOT UserEmail LIKE '%cargomatrix.com%'
      AND NOT UserEmail LIKE '%test%'
      AND NOT (
                  Useremail LIKE '%user1%'
                  OR Useremail LIKE '%user2%'
              )
      AND NOT UserEmail LIKE '%ainonams%'
      AND NOT FirstName LIKE '%Air Import%'
      AND NOT FirstName IS NULL
      AND FirstName > '0'
ORDER BY UserEmail



IF OBJECT_ID('tempdb..#TempTable') IS NOT NULL
    DROP TABLE #TempTable
