/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [Id]
      ,[System]
      ,[FirstName]
      ,[LastName]
      ,[UserEmail]
      ,[Station]
      ,[LastLogin]
      ,[DisabledOn]
      ,[Comment]
      ,[DateCreated]
      ,[DateUploaded]
      ,[DoNotReport]
  FROM [CMX_Accounting].[dbo].[CMX_Product_Users_MGMS]
where UserEmail like '% %'
  /*update CMX_Product_Users_MGMS set UserEmail = LTRIM (Useremail) where UserEmail like '% %'
  update CMX_Product_Users_MGMS set UserEmail = RTRIM (Useremail) where UserEmail like '% %'*/

  'NOEMAIL_Jesus.De La Cruz@dhl.com'

  make sure all email address dont have spaces at source 
Update [CMX_Accounting].[dbo].[CMX_Product_Users_COM] Set DateCreated = NULL Where DateCreated < '0'