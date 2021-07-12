USE CCSDB



SELECT TOP (1000) --- TriggerEventType, CreationDateTime,TriggerDateTime,
* FROM CCSDB.[dbo].[HostPlus_InboundFilesLogs]
Where (1=1 And RecDate > DATEADD(DAY,-75,getdate()) -- And TriggerEventType = 'Z41'
And Reference IN ('235-19755805', '19755805', '--C2101219054')
)
Order By Reference, RecDate DESC