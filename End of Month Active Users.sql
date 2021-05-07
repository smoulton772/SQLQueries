USE CMX_Accounting



IF OBJECT_ID('tempdb..#TempTable') IS NOT NULL
    DROP TABLE #TempTable

IF OBJECT_ID('tempdb..#ResultsTable') IS NOT NULL Drop Table #ResultsTable

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


 Create Table #ResultsTable (
	 [Last_Login_Rank] nvarchar(100),
	   [Id] nvarchar(100)
	  ,[System] nvarchar(100)
      ,[FirstName] nvarchar(100)
      ,[LastName] nvarchar(100)
      ,[UserEmail] nvarchar(100)
      ,[Station] nvarchar(100)
      ,[LastLogin] nvarchar(100)
      ,[DisabledOn] nvarchar(100)
      ,[Comment] nvarchar(100)
      ,[DateCreated] nvarchar(100)
	  ,[DateUploaded] nvarchar(100)
	  ,[DoNotReport] nvarchar(100)
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

--dump the below into a temp table 
INSERT INTO #ResultsTable
(  [Last_Login_Rank],
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
	  and UserEmail not in (select UserEmail from CMX_Bad_Email_address) 
	  --- Do Not include User Disabled after 4/1 and have been active since 4/1
	  --and (UserEmail NOT  IN (select useremail from #TempTable where CAST(DisabledOn As Date) >= '4/1/2021')
          --and UserEmail NOT IN  (select useremail from #TempTable where CAST(LastLogin As DATE) >= '4/01/2021'))
    --OR (UserEmail IN (select useremail from #TempTable where CAST(DisabledOn As Date) >= '4/1/2021')
            --and UserEmail IN  (select useremail from #TempTable where CAST(LastLogin As DATE) >= '4/01/2021'))
	 
ORDER BY UserEmail

 ---  User Disabled after 4/1 AND have NOT been active since 4/1
Select * From #TempTable Where UserEmail IN
	(select useremail from #TempTable where CAST(DisabledOn As Date) >= '4/1/2021')
 and UserEmail NOT IN  (select useremail from #TempTable where CAST(LastLogin As DATE) >= '4/01/2021')
 Order By UserEmail

---  User Disabled after 4/1 BUT have been active since 4/1
--Select * From #TempTable Where UserEmail IN
	/*(select useremail from #TempTable where CAST(DisabledOn As Date) >= '4/1/2021')
 and UserEmail IN  (select useremail from #TempTable where CAST(LastLogin As DATE) >= '4/01/2021')
 Order By UserEmail*/


 select * from #ResultsTable order by UserEmail
  select * from #tempTable  WHERE UserEmail > '0' order by UserEmail


  SELECT CMX_Product_Users_OLD.*, #ResultsTable.* FROM CMX_Product_Users_OLD left JOIN #ResultsTable on CMX_Product_Users_OLD.UserEmail = #ResultsTable.UserEmail where #ResultsTable.UserEmail is NULL
  order by CMX_Product_Users_OLD.UserEmail 

IF OBJECT_ID('tempdb..#TempTable') IS NOT NULL
    DROP TABLE #TempTable
	--select everything from the temp table where email address in disabled on is < march 31 and email address not in lastlogin is > march 1 

IF OBJECT_ID('tempdb..#ResultsTable') IS NOT NULL Drop Table #ResultsTable