USE CCSDB

Select DateCreated, ParentHeaderId,MawbNumberFull, VoyageFlight, ParentMawbOriginId, ParentMawbDestinationId, * 
From US_Customs.USArrivalHeaders where MawbNumber In ('44055395', '--99887766') Or HawbNumber In ('15250664 ', '--99887766') 
Order By MawbNumber,HawbNumber

Return

/* Update ParentHeaderId for the Hawb */
Update US_Customs.USArrivalHeaders Set ParentHeaderId = '3433621', MawbNumberFull='00644055395', VoyageFlight='0045', ParentMawbOriginId=7676, ParentMawbDestinationId=395   Where  
       MawbNumber = '44055395' And HawbNumber In ('15250664') And Id In(3433625) 
