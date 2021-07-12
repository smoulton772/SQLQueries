USE CCSDB

--QUERY TO REDIRECT DESTINATION--

--input Params

declare @Station nvarchar(3) = 'CVG'
declare @MAWB nvarchar(30) = '22328832' --  mawb
declare @MAWBNumber nvarchar(30) = '23522328832' -- carrier + mawb
declare @NewDestination nvarchar(3) = 'ORD'


--QUERY START

DECLARE @MAWBHeaderId BIGINT = (Select Id from US_Customs.USArrivalHeaders where MAWBNumberFull = @MawbNumber and HAWBNumber = '')
DECLARE @DestinationId BIGINT = (Select top 1 Id from StaticCore.Ports where CountryId = 233 and ThreeLetterCode = @NewDestination)
DECLARE @CompanyLocationId BIGINT = (Select top 1 Id from acct.CompanyLocations where Code = @Station)
DECLARE @UserId BIGINT = 1
DECLARE @Reason NVARCHAR(2000) = 'Service Ticket <>'

DECLARE @RefId BIGINT

SELECT TOP(1) @RefId= r.Id FROM [Core].[References] r 
INNER JOIN US_Customs.USArrivalHeaders ah ON r.EntityId = ah.EntityId AND ah.Id = @MawbHeaderId

--- Select Top 50 DestinationId, * from US_Customs.USArrivalHeaders where MAWBNumber = @MAWB
Select DestinationId,* from US_Customs.USArrivalHeaders where MAWBNumberFull = @MAWBNumber and HAWBNumber = ''
Select DestinationId,* From US_Customs.USArrivalHeaders WHERE Id = @MawbHeaderId
Select * from StaticCore.Ports where CountryId = 233 and ThreeLetterCode = @Station
Select * from StaticCore.Ports where CountryId = 233 and ThreeLetterCode = @NewDestination

 Return

UPDATE US_Customs.USArrivalHeaders SET DestinationId = @DestinationId, CompanyLocationId = @CompanyLocationId WHERE Id = @MawbHeaderId

UPDATE US_Customs.USArrivalHeaders SET CompanyLocationId = @CompanyLocationId, ParentMAWBDestinationID = @DestinationId WHERE ParentHeaderId = @MawbHeaderId

UPDATE m
SET m.DestinationId = @DestinationId
FROM [Core].Mawbs m
INNER JOIN US_Customs.USArrivalHeaders ah ON m.EntityId = ah.EntityId AND ah.Id = @MawbHeaderId

IF @RefId IS NOT NULL
BEGIN
	INSERT INTO [Core].ReferenceComments ([ReferenceId], [Text], [UserId], [DateCreated])
	VALUES (@RefId, @Reason, @UserId, GETUTCDATE())
END