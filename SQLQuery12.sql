--identify records with duplicate email addresses within the same system 

SELECT  UserEmail, COUNT(*) FROM CMX_Product_Users_CCS GROUP BY UserEmail --HAVING COUNT(*) > 1 
SELECT  UserEmail, COUNT(*) FROM CMX_Product_Users_LNC GROUP BY  UserEmail --HAVING COUNT(*) > 1

