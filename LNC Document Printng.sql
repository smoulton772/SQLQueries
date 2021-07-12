
/* For Document Printing: */
USE CMXGlobalDB

Select Top 150 * From ReportServer_Printers Where Printer Like '%ATL%' Order By Printer --- MIADGW3

/*Insert Into ReportServer_Printers (Printer, Gateway,Description,Type,IsActive,Trays,TypeID)
	Values ('ATLDWH2', 'ATL', 'ATL WAREHOUSE2', 'REPORT',1 ,2 , 8)*/


Select Top 150 * From ReportServer_Trays  Where Printer Like '%ATLD%'
Select Top 150 * From ReportServer_Trays  Where Printer Like '%IAD%'


/*Insert Into ReportServer_Trays (Report,Tray,Gateway,Printer, IsHighQuality)
	Values ('WarehousePullTicket', 2, 'ATL', 'ATLDWH2',0)
	, ('CarrierReceipt', 1, 'ATL', 'ATLDWH2',0)

*/


Select  HTks.RecID, HTks.Status, HTks.Error, HTks.IsActive, Progress,HostPlus_Sessions.Server, HTks.Description, Timer, TimerType,  HTks.LastDate, HTks.NextDate, * 
From HostPlus_SessionTasks HTks Left Outer Join HostPlus_Sessions on HTks.SessionId = HostPlus_Sessions.RecId
Where  HTks.IsActive = 1  and LastDate > '6/01/2021' 
   And (HTks.Description Like '%Print%ATL%' Or HTks.Description Like '%ATL%Print%') --Or HTks.Description Like '%Print%DFW%' --Or HTks.Description Like '%DFW%Print%')
Order  By  HTks.LastDate 

Select * From HostPlus_SessionTasks where RecId in (1204 , 1233)
--insert Into HostPlus_SessionTasks (RecDate,UserId,SessionId,TaskId,LastDate,NextDate,Timer,TimerWeekDays,TimerType,IsActive,Status,IsTraceable,Locationid,Description)
			--Select RecDate,UserId,459,TaskId,LastDate,NextDate,Timer,TimerWeekDays,TimerType,1,Status,IsTraceable,9,'LNC PRINT ATL WHSE - ATLDWH2' from HostPlus_SessionTasks where RecId = 1204

Select * From HostPlus_Sessions where RecID  In  (230,459)
/*INSERT INTO HostPlus_Sessions (RecDate,UserId,Name,Description,IsActive,Server,SessionTypeId) 
values (GETDATE(), 'ADMIN',	'ATL WHSE PRINT SESSION - ATLDWH2',	'ATL WHSE PRINT SESSION - ATLDWH2',	1,	'DHL0439', 3)*/

Select * From HostPlus_SessionTasks  Where Description Like '%Print%MIA%' -- Session 261
Select * From HostPlus_SessionTaskParameters Where SessionTaskId In  (1233,1204) ORDER BY NAME , SessionTaskId

	/*Insert Into HostPlus_SessionTaskParameters (RecDate,userId,SessionTaskId,Name,Value,ParameterId) 
		Values (getdate(),'ADMIN',1233,'CONNECTION','Data Source =USQASWV018,5005; Initial Catalog = CMXGlobalDB;  Persist Security Info = True; User ID = CMDBUSER; Password = Mgmscbp5prod;',236)
	Insert Into HostPlus_SessionTaskParameters (RecDate,userId,SessionTaskId,Name,Value,ParameterId) 
		Values (getdate(),'ADMIN',1233,'GLOBALCONNECTION','Data Source =USQASWV018,5005; Initial Catalog = CMXGlobalDB; Persist Security Info = True; User ID = CMDBUSER; Password = Mgmscbp5prod;',237)

	Insert Into HostPlus_SessionTaskParameters (RecDate,userId,SessionTaskId,Name,Value,ParameterId) Values (getdate(),'ADMIN',1233,'GATEWAY','ATL',238)
		Insert Into HostPlus_SessionTaskParameters (RecDate,userId,SessionTaskId,Name,Value,ParameterId) Values (getdate(),'ADMIN',1233,'PRINTERNAME','ATLDWH2',239)
		Insert Into HostPlus_SessionTaskParameters (RecDate,userId,SessionTaskId,Name,Value,ParameterId) Values (getdate(),'ADMIN',1233,'ISTRACE','True',240)
		Insert Into HostPlus_SessionTaskParameters (RecDate,userId,SessionTaskId,Name,Value,ParameterId) Values (getdate(),'ADMIN',1233,'IMAGINGSERVICEURL','http://mgms.dhl.com/cargomatrixmgms/DocumentImaging.asmx',241)
		Insert Into HostPlus_SessionTaskParameters (RecDate,userId,SessionTaskId,Name,Value,ParameterId) Values (getdate(),'ADMIN',1233,'REPORTSERVER','http://mgmsreports.dhl.com/cargomatrix-reportserver1/ReportService.asmx',242)
		Insert Into HostPlus_SessionTaskParameters (RecDate,userId,SessionTaskId,Name,Value,ParameterId) Values (getdate(),'ADMIN',1233,'REPORTUSER','phx-dc\srv_phxdc-mgmsRptVwr',243)
		Insert Into HostPlus_SessionTaskParameters (RecDate,userId,SessionTaskId,Name,Value,ParameterId) Values (getdate(),'ADMIN',1233,'REPORTPASSWORD','Efc$HXYbD%?Th$YM',244)
		Insert Into HostPlus_SessionTaskParameters (RecDate,userId,SessionTaskId,Name,Value,ParameterId) Values (getdate(),'ADMIN',1233,'REPORTFOLDER','CargoMatrixReportsATL',245)
		
		UPDATE HostPlus_SessionTaskParameters SET VALUE = 'http://mgmsreports.dhl.com/Reportserver/ReportService.asmx' WHERE RECID = 12112 */

Select * From HostPlus_Sessions  Where RecId = 261
Select * From HostPlus_Sessions  Where Description Like '%MIA%Print%' -- Session 261

Return

Update HostPlus_SessionTasks Set IsActive = 1 Where RecId = 1200


Select Top 5000 * From ReportServer_Jobs Where Gateway='MIA' And Printer='MIADGW3' And Status = 0 Order By REcID dESC

Select Top 5000 * From ReportServer_Jobs Where Gateway='MIA' And Printer='MIADGW3' And RecDate > '6/24/2021'  Order By RecDate

Select Top 5000 * From ReportServer_Logs Where Gateway='MIA' Order By RecDate DESC

Return

---Select Top 5000 * From 
Update R