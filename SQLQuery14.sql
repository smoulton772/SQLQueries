--to identify records disabled in System 1 but Active in other Systems  

SELECT  * FROM CMX_Product_Users_CCS CCS inner join CMX_Product_Users_LNC LNC ON CCS.UserEmail = LNC.UserEmail 

--checks if user with the same email address with different names

SELECT  * FROM CMX_Product_Users_CCS CCS inner join CMX_Product_Users_LNC LNC ON CCS.UserEmail = LNC.UserEmail 
where CCs.FirstName <> lnc.FirstName and ccs.LastName <> lnc.LastName -- no response found

--check for user with the same first name and last name but different email address 
SELECT  * FROM CMX_Product_Users_CCS CCS inner join CMX_Product_Users_LNC LNC ON CCS.UserEmail <> LNC.UserEmail 
where CCs.FirstName = lnc.FirstName and ccs.LastName = lnc.LastName


---query to return distinct list of Users Emails and linked details with latest LastLogin
Select * from CMX_Product_Users_CCS union 
select * from CMX_Product_Users_LNC 

IF OBJECT_ID('tempdb..#TempTable') IS NOT NULL Drop Table #TempTable
 
Create Table #TempTable (

		Id nvarchar(100)
	,[System] nvarchar(100)
      ,[FirstName] nvarchar(100)
      ,[LastName] nvarchar(100)
      ,[UserEmail] nvarchar(100)
      ,[Station] nvarchar(100)
      ,[LastLogin] nvarchar(100)
      ,[DisabledOn] nvarchar(100)
      ,[Comment] nvarchar(100)
      ,[DateCreated] nvarchar(100))

insert into #TempTable ([System]
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

IF OBJECT_ID('tempdb..#TempTable') IS NOT NULL Drop Table #TempTable