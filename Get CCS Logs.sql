--For CCS inbound logs'176-644744109' = mastbill, '644744109= Consol', 'S2101849144= cw1 file number')
SELECT TOP (1000) --- TriggerEventType, CreationDateTime,TriggerDateTime,
* FROM CCSDB.[dbo].[HostPlus_InboundFilesLogs] --- Order by ID DESC
Where 1=1 And RecDate > DATEADD(DAY,-121,getdate())
And Reference IN ('176-644744109', '644744109', 'S2101849144')

--for CCS outbound logs
SELECT TOP (100) * FROM CCSDB.dbo.HostPlus_NotesOutbound Order By ID DESC

SELECT TOP (1000) * FROM CCSDB.[dbo].[HostPlus_InboundFilesLogs]
Where
Reference IN ('69989721')