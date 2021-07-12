/* LNC Handling/Export Docs are printed from CMXGlobalDB.dbo.ReportServer_Jobs */

/* CCS/Import Docs  are printed from CCSDB.dbo.ReportServer_Jobs */


/* For Label Printing: */
USE CMXGlobalDB
SELECT TOP (1000) *  FROM [CMXGlobalDB].[dbo].[HostPlus_Labels]  Order By RecId DESC

/* For Document Printing: */
USE CMXGlobalDB

Select Top 50 * From ReportServer_Printers Order By RecID DESC
/*
Insert Into ReportServer_Printers (Printer, Gateway,Description,Type,IsActive,Trays,TypeID)
	Values ('LAXN', 'LAX', 'LAXN', 'LABEL',1,1,1)
*/

select top 100 * from CMXGlobalDB.dbo.ReportServer_Jobs where Gateway = 'ORD' order by RecId desc

select * from CMXGlobalDB.dbo.ReportServer_Jobs where Parameters like '%14264806%'
--update ReportServer_Jobs set Status = 0 where RecId in (86, 100)

select Top 1000 * from CMXGlobalDB.dbo.ReportServer_Logs Where Job In 
	(select Top 100 RecId from CMXGlobalDB.dbo.ReportServer_Jobs where recDate > '3/25/2021' And Gateway  = 'ORD'  
		Order By RecId DESC)



/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (100) HTks.Description, Sess.Description [Sess Descr], *  
FROM [CMXGlobalDB].[dbo].[HostPlus_SessionTasks] HTks
Left Join [CMXGlobalDB].[dbo].[HostPlus_Sessions] Sess On HTks.SessionId = Sess.RecId
Where HTks.Description Like '%PRINT LABELS%'
Order By HTks.RecDate DESC

Select * From HostPlus_SessionTaskParameters Where SessionTaskId In (1205,1216,1217)

Return
Return

--- Update [CMXGlobalDB].[dbo].[HostPlus_SessionTasks] Set SessionId = 448 Where RecID In (1215,1216)
 Update [CMXGlobalDB].[dbo].[HostPlus_SessionTasks] Set IsActive=1, NextDate=getdate() Where RecID In (1217)

Insert Into [CMXGlobalDB].[dbo].[HostPlus_SessionTasks] ([RecDate] ,[UserId],[Description] ,[SessionId] ,[TaskId] ,[LastDate] ,[NextDate] ,[Timer] ,[TimerWeekDays]
      ,[TimerType] ,[IsActive] ,[IsTraceable] ,[LocationId])
	  Values (getdate(),'ADMIN','PRINT LABELS - LAXP',449,143,'1/2/2000','1/2/2000',10,'MON, TUE, WED, THU, FRI, SAT, SUN', 'SEC', 0,1,1)

Insert Into HostPlus_SessionTaskParameters (RecDate, UserId, SessionTaskId,Name,Value,ParameterId)
Values
(getdate(), 'ADMIN',1217, 'CONNECTION', 'Data Source =usqaswv018\sql05,5005; Initial Catalog = CMXGlobalDB; Persist Security Info = True; User ID = CMDBUSER; Password = Mgmscbp5prod;', '350')
,(getdate(), 'ADMIN',1217, 'PRINTER', 'LAXP', '351')
,(getdate(), 'ADMIN',1217, 'COUNT', '10', '352')


/* CCS/Import Docs */

USE CMXGlobalDB
Select Description, Progress, * from CMXGlobalDB.dbo.HostPlus_sessionTasks where Description Like '%CCS Print%' --- taskID = 129   and RecDate > '3/15/2021'

USE CCSDB
select Top 1000 * from CCSDB.dbo.ReportServer_Jobs where recDate > '3/25/2021' And Gateway  = 'ORD'  
Order By RecId DESC

select Top 100 * from CCSDB.dbo.ReportServer_Jobs where [Parameters] Like '%14264806%'

select Top 1000 * from CCSDB.dbo.ReportServer_Logs Where Job In 
	(select Top 10 RecId from CCSDB.dbo.reportserver_jobs where recDate > '3/25/2021' And Gateway  = 'ORD'  
		Order By RecId DESC)
