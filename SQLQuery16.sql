-- this is how to combine tables 

IF OBJECT_ID('tempdb..#TempTable') IS NOT NULL Drop Table #TempTable
 
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
      ,[DateCreated] nvarchar(100))
	  
insert into #TempTable ([Id]
	  ,[System]
      ,[FirstName]
      ,[LastName]
      ,[UserEmail]
      ,[Station]
      ,[LastLogin]
      ,[DisabledOn]
      ,[Comment]
      ,[DateCreated])
Select * from CMX_Product_Users_CCS union 
select * from CMX_Product_Users_LNC 
select * from #TempTable
IF OBJECT_ID('tempdb..#TempTable') IS NOT NULL Drop Table #TempTable 