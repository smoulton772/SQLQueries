use CMX_Accounting

Declare @ApplicationList Varchar(MAX)

Declare @Curr_Gateway Varchar(3)

Declare @List_Loc Int = 0

 

---List should end with a comma and have no spaces.

Select @ApplicationList = 'LNC,MGMS,CCS'

 

While( @List_Loc < LEN(@ApplicationList))

BEGIN

 

    SET  @Curr_Gateway = SUBSTRING(@ApplicationList,  @List_Loc,CHARINDEX(',',@ApplicationList, @List_Loc) - @List_Loc)

 

SELECT  'Current Gateway - ' + @Curr_Gateway

 

If @Curr_Gateway = 'LNC'

select  * from  CMX_Product_Users_LNC

Else If @Curr_Gateway = 'CCS'

select  * from  CMX_Product_Users_CCS

/*Else If @Curr_Gateway = 'MGMS'

select * from CMX_Product_Users_MGMS

Else If @Curr_Gateway = 'MIA'

USE CMMIA

Else If @Curr_Gateway = 'ORD'

USE CMORD

Else If @Curr_Gateway = 'YYZ'

USE CMYYZ*/

 

/* Drop Script To Run Here */

 

Select Top 1 * From HostPlus_Incoming

 

/* End of Script To Run Here */

 

    SET @List_Loc = CHARINDEX(',', @ApplicationList, @List_Loc)+1

    IF (@List_Loc = 0) set @List_Loc = LEN(@ApplicationList)

END