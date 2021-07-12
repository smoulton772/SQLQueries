--run this every time you do a lnc import 

 --update CMX_Product_Users_LNC set isdisabled = DoNotDisable where DoNotDisable = 1 
  
    --update CMX_Product_Users_LNC set disabledon = LastLogin where IsDisabled = 1 and DisabledOn is NULL