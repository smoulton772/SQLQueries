
--this is used to add the option for the date to be added when ru
ALTER TABLE CMX_Product_Users_mgms ADD CONSTRAINT DF_CMX_Product_Users_mgms DEFAULT GETDATE() FOR DateUploaded

--update colpumn with dates 

update CMX_Product_Users_MGMS set DateUploaded = '4/27/2021'