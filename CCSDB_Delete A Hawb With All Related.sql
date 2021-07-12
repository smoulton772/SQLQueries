USE CCSDB

select EntityId, MawbNumberFull, * from US_Customs.USArrivalHeaders where HawbNumber In ('R606524')
select EntityId, MawbNumberFull, * from US_Customs.USArrivalHeaders where MawbNumber In (select MawbNumber from US_Customs.USArrivalHeaders where HawbNumber = 'R606524')
--- select Top 500 EntityId, * from US_Customs.USArrivalHeaders Order By Id DESC

Return

--- 	@Schema Nvarchar(128),		@Table Nvarchar(128),	@Field Nvarchar(256),	@Values Nvarchar(MAX)
exec [dbo].[DeleteWithDependencies] '[US_Customs]', '[USArrivalHeaders]', '[EntityId]', '3410189'

