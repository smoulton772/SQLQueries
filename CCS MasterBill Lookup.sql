use CCSDB

select Top 100 DateCreated, * From US_Customs.USArrivalHeaders where
MawbNumber In ('50997225', '---') Or HawbNumber In ('15243266', '---')
Order By MawbNumber, USArrivalHeaders.DateCreated
---Id DESC