--Where User is active in system and disabloed in the other 
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



WHILE (@List_Loc < LEN(@Gateways_List))
BEGIN



    SET @Curr_Table = SUBSTRING(@Gateways_List, @List_Loc, CHARINDEX(',', @Gateways_List, @List_Loc) - @List_Loc)



    SELECT 'Current Gateway - ' + @Curr_Table

    DECLARE @tablename VARCHAR(50)

    --start of cursor loop
    DECLARE @CursorTestID INT;
    DECLARE @RunningTotal BIGINT = 0;


    IF @Curr_Table = 'LNC'
    BEGIN

        DECLARE CUR_TEST CURSOR FAST_FORWARD FOR
        SELECT Id RunningTotal
        FROM CMX_Product_Users_LNC
        ORDER BY ID;

        SET @tablename = 'CMX_Product_Users_LNC'

    END
    ELSE IF @Curr_Table = 'CCS'
    BEGIN

        DECLARE CUR_TEST CURSOR FAST_FORWARD FOR
        SELECT Id RunningTotal
        FROM CMX_Product_Users_CCS
        ORDER BY ID;

        SET @tablename = 'CMX_Product_Users_CCS'


    END
    ELSE IF @Curr_Table = 'MGMS'
    BEGIN

        DECLARE CUR_TEST CURSOR FAST_FORWARD FOR
        SELECT Id RunningTotal
        FROM CMX_Product_Users_MGMS
        ORDER BY ID;

        SET @tablename = 'CMX_Product_Users_MGMS'


    END


    --EXEC('SELECT * FROM ' + @tablename)

    OPEN CUR_TEST
    FETCH NEXT FROM CUR_TEST
    INTO @CursorTestID

    WHILE @@FETCH_STATUS = 0
    BEGIN

        --select * from CMX_Product_Users_MGMS where ID =  @CursorTestID 
        --SELECT  * FROM CMX_Product_Users_MGMS MGMS inner join #TempTable TEMP ON MGMS.UserEmail = TEMP.UserEmail where MGMS.Id =  @CursorTestID and temp.System <> 'MGMS' and mgms.DisabledOn is not NULL and  (temp.DisabledOn is Null or temp.DisabledOn = '')

        --Only change this query
        --EXEC(' SELECT * FROM ' + @tablename + ' CurrT inner join #TempTable TEMP ON CurrT.UserEmail = TEMP.UserEmail where CurrT.Id =  ' + @CursorTestID + ' and TEMP.System <> '''+ @Curr_table + ''' and CurrT.DisabledOn is not NULL and  (TEMP.DisabledOn is Null or TEMP.DisabledOn = '''')')

        --Email the same in all system but name are not the same
        --EXEC(' SELECT  * FROM ' + @tablename + ' Currt inner join #TempTable TEMP ON Currt.UserEmail = Temp.UserEmail where Currt.FirstName <> Temp.FirstName or Currt.LastName <> Temp.LastName')
        --Name the same but emails different
        EXEC (' SELECT  * FROM ' + @tablename + ' Currt inner join #TempTable TEMP ON Currt.UserEmail <> Temp.UserEmail where Currt.FirstName <> Temp.FirstName and Currt.LastName = Temp.LastName')
        SET @RunningTotal += @CursorTestID

        FETCH NEXT FROM CUR_TEST
        INTO @CursorTestID
    END




    CLOSE CUR_TEST
    DEALLOCATE CUR_TEST
    --GO
    --end of cursor loop








    SET @List_Loc = CHARINDEX(',', @Gateways_List, @List_Loc) + 1

    IF (@List_Loc = 0)
        SET @List_Loc = LEN(@Gateways_List)

END

IF OBJECT_ID('tempdb..#TempTable') IS NOT NULL
    DROP TABLE #TempTable