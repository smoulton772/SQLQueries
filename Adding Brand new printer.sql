-- SCRIPT TO SET UP PRINT SESSIONS  ---
--- P:\DHL MCH and RTP\RTP\Pending Fixes\MGMS Upgrade .Net 4.6.2\Release Package\DB Scripts

USE CMXGlobalDB

/*
	Find a good sample existing HostPlus Tasks to Copy values from

*/

--- Select * from HostPlus_SessionTasks where TaskId = 129 Order By RecID DESC

---- RETURN


Declare @SampleSessionId Int = 888



/*
	FOR NON-ICT PRINTERS
*/

Declare @LocationId Int = 0
Declare @PrinterName nvarchar(20)
Declare @PrinterDescr nvarchar(50)
Declare @Gateway nvarchar(20)
Declare @DBName nvarchar(20)
Declare @department nvarchar(20)
Declare @Session_Name nvarchar(50)
Declare @ReportFolder nvarchar(50)

Declare @printer_list varchar(MAX)
Declare @list_pos Int=0

Declare @SessionTaskId129 Int = 0
Declare @GlobalSessionId Int = 0

---Select  Top 50 * From HostPlus_Sessions Inner Join HostPlus_SessionTasks 
---  On HostPlus_Sessions.RecId = HostPlus_SessionTasks.SessionId Where HostPlus_SessionTasks.Description Like '%Print%LAX%'
---Return

/*
Select  Top 50 * From HostPlus_Sessions Where RecId = 303
Update HostPlus_Sessions Set IsActive=1 Where  RecId = 303

Select * From HostPlus_SessionTasks Where RecID = 975
Update HostPlus_SessionTasks Set IsActive=1 Where  RecId = 975
*/

Declare @HostPlusServer nvarchar(20) = 'DHL0442' -- 'DHL0441'

---List should end with a comma and have no spaces.
---Select @printer_list = 'ELPDIMP,MFEDIMP1,'
SET @printer_list = 'MIADGW4,'
SET @Gateway = 'MIA' --- MGMSUSGLobal
SET @DBName = 'CM' + @Gateway
SET @department = 'GATEWAY' --- IMPORT  WHSE GATEWAY
SET @ReportFolder = 'CargoMatrixReports' + @Gateway  --- CargoMatrixReportsMGMSUSGLobal
SELECT Top 1 @LocationId = RecId From HostPlus_Locations Where Location = @Gateway Order By RecId

While( @list_pos < LEN(@printer_list))
BEGIN

    SET @PrinterName = SUBSTRING(@printer_list,  @list_pos,CHARINDEX(',',@printer_list, @list_pos) - @list_pos)
	SET @Session_Name =  @Gateway + ' ' + @department + ' PRINT SESSION' + ' - ' + @PrinterName
	SET @PrinterDescr =  'GLOBAL PRINT ' + @Gateway + ' ' + @department + ' - ' + @PrinterName

	--- SELECT  'Printer: ' + @PrinterName + ' - Description: ' + @PrinterName + ' - GTWY: ' + @Gateway 
	SELECT  'Session Name: ' + @Session_Name
	SELECT  '@Printer Descr: ' + @PrinterDescr

--- Return 
	--get/create Global sessionid
	IF NOT EXISTS (SELECT 1 from HostPlus_Sessions where Name = @Session_Name)
	BEGIN
		INSERT INTO HostPlus_Sessions (RecDate,UserId,Name,Description,IsActive,Server,SessionTypeId) 
		Values (getdate(),'ADMIN',@Session_Name,@Session_Name,1,@HostPlusServer,3)
		SET @GlobalSessionId = SCOPE_IDENTITY()
	END
	ELSE
	BEGIN
		SELECT TOP 1 @GlobalSessionId = RecId From HostPlus_Sessions where Name = @Session_Name
		---Update HostPlus_Sessions Set IsActive =0, Server = @HostPlusServer where RecId = @GlobalSessionId
	END

	Select 'GlobalSessionId - ' + Cast(@GlobalSessionId As varchar(10))

	--- Set up Printing tasks
	IF NOT EXISTS (Select 1 from HostPlus_SessionTasks where TaskId = 129 and LocationId = @LocationId and Description=@PrinterDescr)
	BEGIN

		Insert Into HostPlus_SessionTasks (RecDate,UserId,SessionId,TaskId,LastDate,NextDate,Timer,TimerWeekDays,TimerType,IsActive,Status,IsTraceable,Locationid,Description)
			Select RecDate,UserId,@GlobalSessionId,TaskId,LastDate,NextDate,Timer,TimerWeekDays,TimerType,1,Status,IsTraceable,@LocationId,@PrinterDescr from HostPlus_SessionTasks where RecId = @SampleSessionId

		SET @SessionTaskId129 = SCOPE_IDENTITY()
		Select 'SessionTaskId129 - ' + Cast(@SessionTaskId129 As varchar(10))


---- Change to PROD Values if needs be


/*
--- UAT
	Insert Into HostPlus_SessionTaskParameters (RecDate,userId,SessionTaskId,Name,Value,ParameterId) Values (getdate(),'ADMIN',@SessionTaskId129,'CONNECTION','Data Source =USQASWS4045,5001; Initial Catalog = ' + @DBName + '; Persist Security Info = True; User ID = CMDBUSER; Password = Convert2008;',236)
	Insert Into HostPlus_SessionTaskParameters (RecDate,userId,SessionTaskId,Name,Value,ParameterId) Values (getdate(),'ADMIN',@SessionTaskId129,'GLOBALCONNECTION','Data Source =USQASWS4045,5001; Initial Catalog = CMXGlobalDB; Persist Security Info = True; User ID = CMDBUSER; Password = Convert2008;',237)
*/

--- PROD
	Insert Into HostPlus_SessionTaskParameters (RecDate,userId,SessionTaskId,Name,Value,ParameterId) Values (getdate(),'ADMIN',@SessionTaskId129,'CONNECTION','Data Source =USQASWV018,5005; Initial Catalog = ' + @DBName + '; Persist Security Info = True; User ID = CMDBUSER; Password = Mgmscbp5prod;',236)
	Insert Into HostPlus_SessionTaskParameters (RecDate,userId,SessionTaskId,Name,Value,ParameterId) Values (getdate(),'ADMIN',@SessionTaskId129,'GLOBALCONNECTION','Data Source =USQASWV018,5005; Initial Catalog = CMXGlobalDB; Persist Security Info = True; User ID = CMDBUSER; Password = Mgmscbp5prod;',237)

		Insert Into HostPlus_SessionTaskParameters (RecDate,userId,SessionTaskId,Name,Value,ParameterId) Values (getdate(),'ADMIN',@SessionTaskId129,'GATEWAY',@Gateway,238)
		Insert Into HostPlus_SessionTaskParameters (RecDate,userId,SessionTaskId,Name,Value,ParameterId) Values (getdate(),'ADMIN',@SessionTaskId129,'PRINTERNAME',@PrinterName,239)
		Insert Into HostPlus_SessionTaskParameters (RecDate,userId,SessionTaskId,Name,Value,ParameterId) Values (getdate(),'ADMIN',@SessionTaskId129,'ISTRACE','True',240)
		Insert Into HostPlus_SessionTaskParameters (RecDate,userId,SessionTaskId,Name,Value,ParameterId) Values (getdate(),'ADMIN',@SessionTaskId129,'IMAGINGSERVICEURL','http://mgms.dhl.com/cargomatrixmgms/DocumentImaging.asmx',241)
		Insert Into HostPlus_SessionTaskParameters (RecDate,userId,SessionTaskId,Name,Value,ParameterId) Values (getdate(),'ADMIN',@SessionTaskId129,'REPORTSERVER','http://mgmsreports.dhl.com/cargomatrix-reportserver1/ReportService.asmx',242)
		Insert Into HostPlus_SessionTaskParameters (RecDate,userId,SessionTaskId,Name,Value,ParameterId) Values (getdate(),'ADMIN',@SessionTaskId129,'REPORTUSER','phx-dc\srv_phxdc-mgmsRptVwr',243)
		Insert Into HostPlus_SessionTaskParameters (RecDate,userId,SessionTaskId,Name,Value,ParameterId) Values (getdate(),'ADMIN',@SessionTaskId129,'REPORTPASSWORD','Fk3i97!3',244)
		Insert Into HostPlus_SessionTaskParameters (RecDate,userId,SessionTaskId,Name,Value,ParameterId) Values (getdate(),'ADMIN',@SessionTaskId129,'REPORTFOLDER',@ReportFolder,245)

		SELECT  'Printer - ' + @PrinterName  + ' - Added'


--- SELECT  'Printer - ' + @PrinterName  + ' - NEEDS TO BE ADDED?'
--- SELECT  'Printer - ' + @PrinterName  + ' - NEEDS TO BE ADDED?'

	END
	Else
		SELECT TOP 1 @SessionTaskId129 = RecId From HostPlus_SessionTasks Where TaskId = 129 and LocationId = @LocationId and Description=@PrinterDescr
		
 Update HostPlus_SessionTasks Set SessionId = @globalSessionId where RecId = @SessionTaskId129

	Select * from HostPlus_SessionTasks where SessionId = @globalSessionId and TaskId = 129 and LocationId = @LocationId and Description=@PrinterDescr
	Select * from HostPlus_SessionTasks where RecId = @SessionTaskId129


	SET @list_pos = CHARINDEX(',', @printer_list, @list_pos)+1
    IF (@list_pos = 0) set @list_pos = LEN(@printer_list) 
	
END


Return


Select * From HostPlus_SessionTasks Where Description Like '%Print%JFK%' Or Description Like '%Print%EWR%'
Select * From HostPlus_SessionTasks Where RecID = 1114
--- Update HostPlus_SessionTasks Set IsActive = 1 Where RecID = 1114
--- Update HostPlus_SessionTasks Set Description = 'GLOBAL PRINT EWR IMPORT - EWRDIMP1' Where RecID = 1114

Select * From HostPlus_Sessions Where RecId = 391
--- Update HostPlus_Sessions Set IsActive = 1 Where RecID = 391
--- Update HostPlus_Sessions Set Name = 'JFK EWR PRINT SESSION - EWRDIMP1' Where RecID = 391
--- Update HostPlus_Sessions Set Description = 'JFK EWR PRINT SESSION - EWRDIMP1' Where RecID = 391

Select top 50 * From HostPlus_SessionTaskParameters Order By RecId DESC

Select top 50 * From HostPlus_SessionTaskParameters Where RecID = 11300
-- Update HostPlus_SessionTaskParameters Set Value='Data Source =USQASWV018,5005; Initial Catalog = CMJFK; Persist Security Info = True; User ID = CMDBUSER; Password = Mgmscbp5prod;' Where RecID = 11300
Select top 50 * From HostPlus_SessionTaskParameters Where RecID = 11301
-- Update HostPlus_SessionTaskParameters Set Value ='Data Source =USQASWV018,5005; Initial Catalog = CMXGlobalDB; Persist Security Info = True; User ID = CMDBUSER; Password = Mgmscbp5prod;' Where RecID = 11301
