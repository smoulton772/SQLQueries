USE CMX_Accounting

IF OBJECT_ID('tempdb..#TempTable') IS NOT NULL
    DROP TABLE #TempTable
IF OBJECT_ID('tempdb..#ResultsTable') IS NOT NULL
    DROP TABLE #ResultsTable
IF OBJECT_ID('tempdb..#DisAbledTable') IS NOT NULL
    DROP TABLE #DisAbledTable
IF OBJECT_ID('tempdb..#StillActiveTable') IS NOT NULL
    DROP TABLE #StillActiveTable

DECLARE @Dateupload Date = '05/18/2021'

CREATE TABLE #TempTable
(
    [Id] NVARCHAR(100),
    [System] NVARCHAR(100),
    [FirstName] NVARCHAR(100),
    [LastName] NVARCHAR(100),
    [UserEmail] NVARCHAR(100),
    [Station] NVARCHAR(100),
    [LastLogin] Date,
    [DisabledOn] Date,
    [Comment] NVARCHAR(100),
    [DateCreated] Date,
    [DateUploaded] Date,
    [DoNotReport] NVARCHAR(100),
	[IsDisabled] bit,
	[DoNotDisable] bit,
	[Notes] NVARCHAR(100)
)

CREATE TABLE #DisAbledTable
(
    [Id] NVARCHAR(100),
    [System] NVARCHAR(100),
    [FirstName] NVARCHAR(100),
    [LastName] NVARCHAR(100),
    [UserEmail] NVARCHAR(100),
    [Station] NVARCHAR(100),
    [LastLogin] Date,
    [DisabledOn] Date,
    [Comment] NVARCHAR(100),
    [DateCreated] Date,
    [DateUploaded] Date,
    [DoNotReport] NVARCHAR(100),
	[IsDisabled] bit,
	[DoNotDisable] bit,
	[Notes] NVARCHAR(100)
	
)

CREATE TABLE #StillActiveTable
(
    [Id] NVARCHAR(100),
    [System] NVARCHAR(100),
    [FirstName] NVARCHAR(100),
    [LastName] NVARCHAR(100),
    [UserEmail] NVARCHAR(100),
    [Station] NVARCHAR(100),
    [LastLogin] Date,
    [DisabledOn] Date,
    [Comment] NVARCHAR(100),
    [DateCreated] Date,
    [DateUploaded] Date,
    [DoNotReport] NVARCHAR(100),
	[IsDisabled] bit,
	[DoNotDisable] bit,
	[Notes] NVARCHAR(100)
	
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
    [LastLogin] Date,
    [DisabledOn] Date,
    [Comment] NVARCHAR(100),
    [DateCreated] Date,
    [DateUploaded] Date,
    [DoNotReport] NVARCHAR(100),
	[IsDisabled] bit,
	[DoNotDisable] bit,
	[Notes] NVARCHAR(100)
	
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
    [DoNotReport], 
	[IsDisabled],
	[DoNotDisable],
	[Notes]
)
--Add new table below 
SELECT *
FROM CMX_Product_Users_COM
--where DateUploaded > @Dateupload
UNION
SELECT *
FROM CMX_Product_Users_MGMS
where DateUploaded > @Dateupload
UNION
--SELECT *
--FROM CMX_Product_Users_LNC
--where DateUploaded > @Dateupload
SELECT TOP (1000) Id, System, FirstName, LastName, userEmail,Station, LastLogin,Null as [DisabledOn],Comment, DateCreated,DateUploaded, DoNotReport, IsDisabled, DoNotDisable, Notes
  FROM CMX_Product_Users_LNC
  where DateUploaded > @Dateupload 
  And IsDisabled = 0 And LastLogin > DATEADD(dd,-45, '5/1/2021') 

UNION ALL

SELECT TOP (1000) ID, System, FirstName, LastName, userEmail,station, LastLogin,

Case
	when  [DisabledOn] is NULL and LastLogin is NOT NULL  then LastLogin
	else DisabledOn end as DisabledOn,

 Comment, DateCreated,DateUploaded, DoNotReport, IsDisabled, DoNotDisable, Notes
  FROM CMX_Product_Users_lnc
  where DateUploaded > @Dateupload 
  and IsDisabled = 1 And DisabledOn > DATEADD(dd,-45, '5/1/2021') 
  
union

SELECT TOP (1000) Id, System, FirstName, LastName, userEmail,Station, LastLogin,Null as [DisabledOn],Comment, DateCreated,DateUploaded, DoNotReport, IsDisabled, DoNotDisable, Notes
  FROM CMX_Product_Users_CCS
  where DateUploaded > @Dateupload 
  And IsDisabled = 0 And LastLogin > DATEADD(dd,-45, '5/1/2021') 

UNION ALL

SELECT TOP (1000) ID, System, FirstName, LastName, userEmail,station, LastLogin,DisabledOn, Comment, DateCreated,DateUploaded, DoNotReport, IsDisabled, DoNotDisable, Notes
  FROM CMX_Product_Users_CCS
  where DateUploaded > @Dateupload 
  and IsDisabled = 1 And DisabledOn > DATEADD(dd,-45, '5/1/2021') 
  
  

--To help select everything from the temp table where email address in disabled on is < march 31 and email address not in lastlogin is > march 1 


 ---  User Disabled after 4/1 and have NOT been active since 4/1
 INSERT INTO #DisAbledTable
([Id], [System], [FirstName], [LastName], [UserEmail], [Station], [LastLogin], [DisabledOn], [Comment], [DateCreated], [DateUploaded], [DoNotReport],[IsDisabled],[DoNotDisable],[Notes])

Select * From #TempTable Where UserEmail IN	(select UserEmail from #TempTable where CAST(DisabledOn As Date) >= '4/1/2021')
 and UserEmail NOT IN  (select UserEmail from #TempTable where CAST(LastLogin As DATE) >= '4/01/2021')
 Order By UserEmail

--- Select * From #TempTable Where UserEmail IN ('rodolfo.garcia@dhl.com','cynthia.martinez@dhl.com') Order By UserEmail, DisabledOn, LastLogin

---  User Disabled after 4/1 BUT have been active since 4/1
/*INSERT INTO #StillActiveTable
([Id], [System], [FirstName], [LastName], [UserEmail], [Station], [LastLogin], [DisabledOn], [Comment], [DateCreated], [DateUploaded], [DoNotReport],[IsDisabled],[DoNotDisable],[Notes])

Select * From #TempTable Where UserEmail IN
	(select UserEmail from #TempTable where CAST(DisabledOn As Date) >= '4/1/2021')
 and UserEmail IN  (select UserEmail from #TempTable where CAST(LastLogin As DATE) >= '4/01/2021')
 Order By UserEmail

Select * From #TempTable Where UserEmail IN ('dolores.scarpati@dhl.com','vito.pellegrino@dhl.com', 'deshontay.berry@dhl.com') Order By UserEmail, DisabledOn, LastLogin


Select '' As [Id], '' As [System], 'Disabled Users' As [FirstName], 'Disabled Users' As [LastName], 'Disabled Users' As [UserEmail], '' As [Station], '' As[ LastLogin]
	, '' As [DisabledOn], '' As [Comment], '' As [DateCreated], '' As [DateUploaded], '' As [DoNotReport],  '' As [IsDisabled], '' As [DoNotDisable], '' As [Notes]
UNION
Select * From #DisAbledTable


Select '' As [Id], '' As [System], 'StillActive Users' As [FirstName], 'StillActive Users' As [LastName], 'StillActive Users' As [UserEmail], '' As [Station], '' As[ LastLogin]
	, '' As [DisabledOn], '' As [Comment], '' As [DateCreated], '' As [DateUploaded], '' As [DoNotReport], '' As [IsDisabled], '' As [DoNotDisable], '' As [Notes]
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
    [DoNotReport],
	[IsDisabled],
	[DoNotDisable],
	[Notes]
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
          OR lastlogin > DATEADD(DAY, -45, GETDATE())
      )
ORDER BY UserEmail

--Below is for adding the additional columns to show all apps user has access to 
SELECT [System],
    [FirstName],
    [LastName],
    [UserEmail],
    [Station],
    [LastLogin],
     [DisabledOn], 
	/*Case
	when NOT [DisabledOn] is NULL and (
	LastLogin is NULL or(LastLogin < DisabledOn)) then DisabledOn
	when NOT [DisabledOn] is NULL and (
	LastLogin is NULL or(LastLogin > DisabledOn)) then DisabledOn
	when NOT [DisabledOn] is NULL and ( lastlogin > DATEADD(DAY, -45, GETDATE())) then DisabledOn
	else NULL end as Disabled_Date,*/
    [Comment],
    [DateCreated],
    [DateUploaded],
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
           ORDER BY LastLogin desc
       ) AS COM_Station,
       (
           SELECT TOP 1
                  LastLogin
           FROM #TempTable
           WHERE #TempTable.UserEmail = #ResultsTable.UserEmail
                 AND system = 'COM'
           ORDER BY disabledon DESC
       ) AS COM_LastLogin
FROM #ResultsTable
/*where UserEmail in ('mary.carter@dhl.com','Carlos.torres@dhl.com','ivan.martinez@dhl.com','antoni.kowalski@dhl.com','judy.sprouse_dill@dhl.com','jun.inomata@dhl.com','gandseyiv.george@dhl.com','henze.robert@dhl.com','faulkner.mike@dhl.com','rich.gols@dhl.com','jesus.hernandez@dhl.com','l.hinkelday@dhl.com','agusto.oliva@dhl.com','jose.negrete@dhl.com','christopher.fowler@dhl.com','chuck.cox@dhl.com','sally.esparza@dhl.com','richard.cox2@dhl.com','mark.abbott2@dhl.com','ricardo.rodriguez@dhl.com','zimmerman.eugene@dhl.com','ira.miller@dhl.com')*/
ORDER BY FirstName

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

 SELECT * FROM CMX_Product_Users_OLD right JOIN #ResultsTable on CMX_Product_Users_OLD.firstname = #ResultsTable.UserEmail where CMX_Product_Users_OLD.FirstName is NULL and #ResultsTable.Comment NOT like '%sunset%' 
 
 order by #ResultsTable.DisabledOn desc , #ResultsTable.LastLogin


IF OBJECT_ID('tempdb..#TempTable') IS NOT NULL
    DROP TABLE #TempTable
IF OBJECT_ID('tempdb..#ResultsTable') IS NOT NULL
    DROP TABLE #ResultsTable
IF OBJECT_ID('tempdb..#DisAbledTable') IS NOT NULL
    DROP TABLE #DisAbledTable
IF OBJECT_ID('tempdb..#StillActiveTable') IS NOT NULL
    DROP TABLE #StillActiveTable