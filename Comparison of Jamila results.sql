IF OBJECT_ID('tempdb..#TempTable') IS NOT NULL
    DROP TABLE #TempTable

CREATE TABLE #TempTable
(
    [Id] NVARCHAR(100),
    [System] NVARCHAR(100),
    [FirstName] NVARCHAR(100),
    [LastName] NVARCHAR(100),
    [UserEmail] NVARCHAR(100),
    [Station] NVARCHAR(100),
    [LastLogin] NVARCHAR(100),
    [DisabledOn] NVARCHAR(100),
    [Comment] NVARCHAR(100),
    [DateCreated] NVARCHAR(100),
    [DateUploaded] NVARCHAR(100),
    [DoNotReport] NVARCHAR(100)
)


INSERT INTO #TempTable
(
    [Id],
    [System],
    [FirstName],
    [LastName],
    [UserEmail],
    [Station],
    [LastLogin],
    [DisabledOn],
    [Comment],
    [DateCreated],
    [DateUploaded],
    [DoNotReport]
)


--Add new table below 
SELECT *
FROM CMX_Product_Users_COM
UNION
SELECT *
FROM CMX_Product_Users_CCS
UNION
SELECT *
FROM CMX_Product_Users_LNC
UNION
SELECT *
FROM CMX_Product_Users_MGMS

-- SELECT UserEmail FROM CMX_Product_Users_OLD 
--     INNER JOIN CMX_Product_Users_COM
--         ON CurrT.UserEmail <> Temp.UserEmail
-- WHERE CurrT.FirstName = Temp.FirstName
--       AND CurrT.LastName = Temp.LastName

SELECT * FROM CMX_Product_Users_OLD INNER JOIN #TempTable on CMX_Product_Users_OLD.UserEmail = #TempTable.UserEmail

IF OBJECT_ID('tempdb..#TempTable') IS NOT NULL
    DROP TABLE #TempTable