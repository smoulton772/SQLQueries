--clean up empty spaces 

update CMX_Product_Users_COM set UserEmail = LTRIM (Useremail) where UserEmail like '% %'
  update CMX_Product_Users_com set UserEmail = RTRIM (Useremail) where UserEmail like '% %'

  update CMX_Product_Users_LNC set UserEmail = LTRIM (Useremail) where UserEmail like '% %'
  update CMX_Product_Users_lnc set UserEmail = RTRIM (Useremail) where UserEmail like '% %'
 
 update CMX_Product_Users_Mgms set UserEmail = LTRIM (Useremail) where UserEmail like '% %'
  update CMX_Product_Users_mgms set UserEmail = RTRIM (Useremail) where UserEmail like '% %'
 
 update CMX_Product_Users_ccs set UserEmail = LTRIM (Useremail) where UserEmail like '% %'
  update CMX_Product_Users_ccs set UserEmail = RTRIM (Useremail) where UserEmail like '% %'