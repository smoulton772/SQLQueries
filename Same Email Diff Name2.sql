--Where User is active in system and disabloed in the other 
USE CMX_Accounting


--TempTables


IF OBJECT_ID('tempdb..#TempTable') IS NOT NULL
    DROP TABLE #TempTable

IF OBJECT_ID('tempdb..#ResultsTable') IS NOT NULL
    DROP TABLE #ResultsTable

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

CREATE TABLE #ResultsTable
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
    [Id 2] NVARCHAR(100),
    [System 2] NVARCHAR(100),
    [FirstName 2] NVARCHAR(100),
    [LastName 2] NVARCHAR(100),
    [UserEmail 2] NVARCHAR(100),
    [Station 2] NVARCHAR(100),
    [LastLogin 2] NVARCHAR(100),
    [DisabledOn 2] NVARCHAR(100),
    [Comment 2] NVARCHAR(100),
    [DateCreated 2] NVARCHAR(100)
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





-- drop loop for tables
USE CMX_Accounting

DECLARE @Gateways_List VARCHAR(MAX)

DECLARE @Curr_Table VARCHAR(10)

DECLARE @List_Loc INT = 0



---List should end with a comma and have no spaces.

SELECT @Gateways_List = 'LNC,MGMS,CCS,'

DECLARE @queries VARCHAR(max)

WHILE (@List_Loc < LEN(@Gateways_List))
BEGIN



    SET @Curr_Table = SUBSTRING(@Gateways_List, @List_Loc, CHARINDEX(',', @Gateways_List, @List_Loc) - @List_Loc)



    SELECT 'Current Gateway - ' + @Curr_Table

    DECLARE @tablename VARCHAR(50)

    IF @Curr_Table = 'LNC'
    BEGIN

        SET @tablename = 'CMX_Product_Users_LNC'

    END
    ELSE IF @Curr_Table = 'CCS'
    BEGIN

        SET @tablename = 'CMX_Product_Users_CCS'
    END
    ELSE IF @Curr_Table = 'MGMS'
    BEGIN

        SET @tablename = 'CMX_Product_Users_MGMS'


    END


    -- EXEC('SELECT * FROM ' + @tablename)

    /*
			OPEN CUR_TEST
			FETCH NEXT FROM CUR_TEST INTO @CursorTestID
 
			WHILE @@FETCH_STATUS = 0


			BEGIN
*/
    --select * from CMX_Product_Users_MGMS where ID =  @CursorTestID 
    --SELECT  * FROM CMX_Product_Users_MGMS MGMS inner join #TempTable TEMP ON MGMS.UserEmail = TEMP.UserEmail where MGMS.Id =  @CursorTestID and temp.System <> 'MGMS' and mgms.DisabledOn is not NULL and  (temp.DisabledOn is Null or temp.DisabledOn = '')

    --Only change this query
    --EXEC(' SELECT * FROM ' + @tablename + ' CurrT inner join #TempTable TEMP ON CurrT.UserEmail = TEMP.UserEmail where CurrT.Id =  ' + @CursorTestID + ' and TEMP.System <> '''+ @Curr_table + ''' and CurrT.DisabledOn is not NULL and  (TEMP.DisabledOn is Null or TEMP.DisabledOn = '''')')

    --Email the same in all system but name are not the same

    --EXEC(' SELECT  * FROM ' + @tablename + ' Currt inner join #TempTable TEMP ON Currt.UserEmail = Temp.UserEmail where Currt.FirstName <> Temp.FirstName or Currt.LastName <> Temp.LastName')

    --Name the same but emails different
    --	EXEC(' SELECT  * FROM ' + @tablename + ' CurrT inner join #TempTable TEMP ON CurrT.UserEmail <> Temp.UserEmail where CurrT.FirstName = Temp.FirstName and CurrT.LastName = Temp.LastName')
    ---   SET @RunningTotal += @CursorTestID

    SET @queries
        = 'insert into #ResultsTable (
       [Id]
      ,[System]
      ,[FirstName]
      ,[LastName]
      ,[UserEmail]
      ,[Station]
      ,[LastLogin]
      ,[DisabledOn]
      ,[Comment]
      ,[DateCreated],
	  
	   [Id 2]
      ,[System 2]
      ,[FirstName 2]
      ,[LastName 2]
      ,[UserEmail 2]
      ,[Station 2]
      ,[LastLogin 2]
      ,[DisabledOn 2]
      ,[Comment 2]
      ,[DateCreated 2])
	  SELECT  * FROM ' + @tablename
          + ' CurrT inner join #TempTable TEMP ON CurrT.UserEmail = Temp.UserEmail where CurrT.FirstName <> Temp.FirstName and CurrT.LastName <> Temp.LastName
	  '
    EXEC (@queries)

    --   SELECT  * FROM CMX_Product_Users_LNC CurrT inner join #TempTable TEMP ON CurrT.UserEmail <> Temp.UserEmail where CurrT.FirstName = Temp.FirstName and CurrT.LastName = Temp.LastName  

    /*			  
			  
			  FETCH NEXT FROM CUR_TEST INTO @CursorTestID
			END

			CLOSE CUR_TEST
			DEALLOCATE CUR_TEST
			--GO
--end of cursor loop
*/







    SET @List_Loc = CHARINDEX(',', @Gateways_List, @List_Loc) + 1

    IF (@List_Loc = 0)
        SET @List_Loc = LEN(@Gateways_List)

END

SELECT *
FROM #ResultsTable


IF OBJECT_ID('tempdb..#TempTable') IS NOT NULL
    DROP TABLE #TempTable
IF OBJECT_ID('tempdb..#ResultsTable') IS NOT NULL
    DROP TABLE #ResultsTable