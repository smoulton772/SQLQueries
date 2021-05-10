USE CMX_Accounting

IF OBJECT_ID('tempdb..#TempTable') IS NOT NULL
    DROP TABLE #TempTable
IF OBJECT_ID('tempdb..#ResultsTable') IS NOT NULL
    DROP TABLE #ResultsTable
IF OBJECT_ID('tempdb..#DisAbledTable') IS NOT NULL
    DROP TABLE #DisAbledTable
IF OBJECT_ID('tempdb..#StillActiveTable') IS NOT NULL
    DROP TABLE #StillActiveTable

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

CREATE TABLE #DisAbledTable
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

CREATE TABLE #StillActiveTable
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

CREATE TABLE #ResultsTable
(
    [Last_Login_Rank] NVARCHAR(100),
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


/*
To help select everything from the temp table where email address in disabled on is < march 31 and email address not in lastlogin is > march 1 
*/
/*
 ---  User Disabled after 4/1 and have NOT been active since 4/1
 INSERT INTO #DisAbledTable
([Id], [System], [FirstName], [LastName], [UserEmail], [Station], [LastLogin], [DisabledOn], [Comment], [DateCreated], [DateUploaded], [DoNotReport])

Select * From #TempTable Where UserEmail IN	(select UserEmail from #TempTable where CAST(DisabledOn As Date) >= '4/1/2021')
 and UserEmail NOT IN  (select UserEmail from #TempTable where CAST(LastLogin As DATE) >= '4/01/2021')
 Order By UserEmail

--- Select * From #TempTable Where UserEmail IN ('rodolfo.garcia@dhl.com','cynthia.martinez@dhl.com') Order By UserEmail, DisabledOn, LastLogin

---  User Disabled after 4/1 BUT have been active since 4/1
INSERT INTO #StillActiveTable
([Id], [System], [FirstName], [LastName], [UserEmail], [Station], [LastLogin], [DisabledOn], [Comment], [DateCreated], [DateUploaded], [DoNotReport])

Select * From #TempTable Where UserEmail IN
	(select UserEmail from #TempTable where CAST(DisabledOn As Date) >= '4/1/2021')
 and UserEmail IN  (select UserEmail from #TempTable where CAST(LastLogin As DATE) >= '4/01/2021')
 Order By UserEmail

Select * From #TempTable Where UserEmail IN ('dolores.scarpati@dhl.com','vito.pellegrino@dhl.com', 'deshontay.berry@dhl.com') Order By UserEmail, DisabledOn, LastLogin


Select '' As [Id], '' As [System], 'Disabled Users' As [FirstName], 'Disabled Users' As [LastName], 'Disabled Users' As [UserEmail], '' As [Station], '' As[ LastLogin]
	, '' As [DisabledOn], '' As [Comment], '' As [DateCreated], '' As [DateUploaded], '' As [DoNotReport]
UNION
Select * From #DisAbledTable


Select '' As [Id], '' As [System], 'StillActive Users' As [FirstName], 'StillActive Users' As [LastName], 'StillActive Users' As [UserEmail], '' As [Station], '' As[ LastLogin]
	, '' As [DisabledOn], '' As [Comment], '' As [DateCreated], '' As [DateUploaded], '' As [DoNotReport]
UNION
Select * From #StillActiveTable

Return
*/

--select * from #TempTable  where (DoNotReport is null or DoNotReport = 0) and (DisabledOn > DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0) or Disabledon is NUll)
--order by FirstName , LastName, UserEmail 

--dump the below into a temp table 
INSERT INTO #ResultsTable
(
    [Last_Login_Rank],
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
      AND NOT (UserEmail IS NULL)
      AND UserEmail > '0'
      AND NOT (FirstName IS NULL)
      AND FirstName > '0'
      AND NOT UserEmail LIKE '%cargomatrix.com%'
      AND NOT UserEmail LIKE '%test%'
      AND NOT Useremail LIKE '%user1%'
      AND NOT Useremail LIKE '%user2%'
      AND NOT Useremail LIKE '%user3%'
      AND NOT UserEmail LIKE '%ainonams%'
      AND NOT FirstName LIKE '%Air Import%'
      AND UserEmail NOT IN
          (
              SELECT UserEmail FROM CMX_Bad_Email_address
          )
      AND UserEmail NOT IN
          (
              SELECT UserEmail FROM CMX_Secondary_Email_Addresses
          )

      --- Do Not include User Disabled after 4/1 

      --have been active since 4/1
      AND
      (
          Disabledon IS NULL
          OR Cast(DisabledOn AS DATE) > '4/2/2021'
          OR lastlogin > DATEADD(MONTH, -1, GETDATE())
      )
ORDER BY UserEmail


SELECT *
FROM #ResultsTable
ORDER BY UserEmail

--Below is for adding the additional columns to show all apps user has access to 
SELECT *,
       (
           SELECT TOP 1
                  Station
           FROM #TempTable
           WHERE #TempTable.UserEmail = #ResultsTable.UserEmail
                 AND system = 'MGMS'
           ORDER BY LastLogin DESC
       ) AS MGMS_Station,
       (
           SELECT TOP 1
                  LastLogin
           FROM #TempTable
           WHERE #TempTable.UserEmail = #ResultsTable.UserEmail
                 AND system = 'MGMS'
           ORDER BY LastLogin DESC
       ) AS MGMS_LastLogin,
       (
           SELECT TOP 1
                  Station
           FROM #TempTable
           WHERE #TempTable.UserEmail = #ResultsTable.UserEmail
                 AND system = 'LNC'
           ORDER BY LastLogin DESC
       ) AS LNC_Station,
       (
           SELECT TOP 1
                  LastLogin
           FROM #TempTable
           WHERE #TempTable.UserEmail = #ResultsTable.UserEmail
                 AND system = 'LNC'
           ORDER BY LastLogin DESC
       ) AS LNC_LastLogin,
       (
           SELECT TOP 1
                  Station
           FROM #TempTable
           WHERE #TempTable.UserEmail = #ResultsTable.UserEmail
                 AND system = 'CCS'
           ORDER BY LastLogin DESC
       ) AS CCS_Station,
       (
           SELECT TOP 1
                  LastLogin
           FROM #TempTable
           WHERE #TempTable.UserEmail = #ResultsTable.UserEmail
                 AND system = 'CCS'
           ORDER BY LastLogin DESC
       ) AS CCS_LastLogin,
       (
           SELECT TOP 1
                  Station
           FROM #TempTable
           WHERE #TempTable.UserEmail = #ResultsTable.UserEmail
                 AND system = 'COM'
           ORDER BY LastLogin DESC
       ) AS COM_Station,
       (
           SELECT TOP 1
                  LastLogin
           FROM #TempTable
           WHERE #TempTable.UserEmail = #ResultsTable.UserEmail
                 AND system = 'COM'
           ORDER BY LastLogin DESC
       ) AS COM_LastLogin
FROM #ResultsTable
ORDER BY UserEmail
--select * from #tempTable  WHERE UserEmail > '0' order by UserEmail

/*select * from #temptable where UserEmail in ( 

SELECT CMX_Product_Users_OLD.UserEmail  ---CMX_Product_Users_OLD.*, #ResultsTable.* 
FROM CMX_Product_Users_OLD left JOIN #ResultsTable on CMX_Product_Users_OLD.UserEmail = #ResultsTable.UserEmail where #ResultsTable.UserEmail is NULL
--and (CMX_Product_Users_OLD.DisabledOn is NULL or CMX_Product_Users_OLD.DisabledOn < '0')
 
 ) order by #TempTable.UserEmail */

/*select * from #temptable where UserEmail in ( 

SELECT #ResultsTable.UserEmail  ---CMX_Product_Users_OLD.*, #ResultsTable.* 
FROM CMX_Product_Users_OLD right JOIN #ResultsTable on CMX_Product_Users_OLD.UserEmail = #ResultsTable.UserEmail where CMX_Product_Users_OLD.UserEmail is NULL
-- and (CMX_Product_Users_OLD.DisabledOn is NULL or CMX_Product_Users_OLD.DisabledOn < '0')
 
 ) order by #TempTable.UserEmail*/


IF OBJECT_ID('tempdb..#TempTable') IS NOT NULL
    DROP TABLE #TempTable
IF OBJECT_ID('tempdb..#ResultsTable') IS NOT NULL
    DROP TABLE #ResultsTable
IF OBJECT_ID('tempdb..#DisAbledTable') IS NOT NULL
    DROP TABLE #DisAbledTable
IF OBJECT_ID('tempdb..#StillActiveTable') IS NOT NULL
    DROP TABLE #StillActiveTable