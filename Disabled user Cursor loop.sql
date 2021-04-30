--Where User is active in system and disabloed in the other 
use CMX_Accounting


--TempTables


IF OBJECT_ID('tempdb..#TempTable') IS NOT NULL Drop Table #TempTable

IF OBJECT_ID('tempdb..#ResultsTable') IS NOT NULL Drop Table #ResultsTable

Create Table #TempTable (

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
	  ,[DateUploaded] nvarchar(100))

	  Create Table #ResultsTable (

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

	  ,
	   [Id 2] nvarchar(100)
	  ,[System 2] nvarchar(100)
      ,[FirstName 2] nvarchar(100)
      ,[LastName 2] nvarchar(100)
      ,[UserEmail 2] nvarchar(100)
      ,[Station 2] nvarchar(100)
      ,[LastLogin 2] nvarchar(100)
      ,[DisabledOn 2] nvarchar(100)
      ,[Comment 2] nvarchar(100)
      ,[DateCreated 2] nvarchar(100)
	  ,[DateUploaded 2] nvarchar(100))


insert into #TempTable (
       [Id]
      ,[System]
      ,[FirstName]
      ,[LastName]
      ,[UserEmail]
      ,[Station]
      ,[LastLogin]
      ,[DisabledOn]
      ,[Comment]
      ,[DateCreated]
	  ,[DateUploaded])  

--Add new table below 
Select * from CMX_Product_Users_COM
Union
Select * from CMX_Product_Users_CCS 
union 
select * from CMX_Product_Users_LNC 
union 
select * from CMX_Product_Users_MGMS





-- drop loop for tables
use CMX_Accounting

Declare @Gateways_List Varchar(MAX)

Declare @Curr_Table Varchar(10)

Declare @List_Loc Int = 0

 

---List should end with a comma and have no spaces.

Select @Gateways_List = 'LNC,MGMS,CCS,'

declare @queries varchar(max)

While( @List_Loc < LEN(@Gateways_List))

BEGIN

 

    SET  @Curr_Table = SUBSTRING(@Gateways_List,  @List_Loc,CHARINDEX(',',@Gateways_List, @List_Loc) - @List_Loc)

 

SELECT  'Current Gateway - ' + @Curr_Table

 declare @tablename varchar(50)
 
If @Curr_Table = 'LNC' 

begin
				
				set @tablename = 'CMX_Product_Users_LNC'

end
Else If @Curr_Table = 'CCS'

begin
				
				set @tablename = 'CMX_Product_Users_CCS'
end

Else If @Curr_Table = 'MGMS'

begin

				set @tablename = 'CMX_Product_Users_MGMS'


end

Else If @Curr_Table = 'COM'

begin

				set @tablename = 'CMX_Product_Users_COM'


end

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
	   
	  set @queries = 'insert into #ResultsTable (
       [Id]
      ,[System]
      ,[FirstName]
      ,[LastName]
      ,[UserEmail]
      ,[Station]
      ,[LastLogin]
      ,[DisabledOn]
      ,[Comment]
      ,[DateCreated]
	  ,[DateUploaded],
	  
	   [Id 2]
      ,[System 2]
      ,[FirstName 2]
      ,[LastName 2]
      ,[UserEmail 2]
      ,[Station 2]
      ,[LastLogin 2]
      ,[DisabledOn 2]
      ,[Comment 2]
      ,[DateCreated 2]
	  ,[DateUploaded 2])
	  SELECT  * FROM ' + @tablename + ' CurrT inner join #TempTable TEMP ON CurrT.UserEmail <> Temp.UserEmail where CurrT.FirstName = Temp.FirstName and CurrT.LastName = Temp.LastName
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


 


 

    SET @List_Loc = CHARINDEX(',', @Gateways_List, @List_Loc)+1

    IF (@List_Loc = 0) set @List_Loc = LEN(@Gateways_List)

END

Select * From #ResultsTable


IF OBJECT_ID('tempdb..#TempTable') IS NOT NULL Drop Table #TempTable
IF OBJECT_ID('tempdb..#ResultsTable') IS NOT NULL Drop Table #ResultsTable