-- =============================================
-- Author:		Bayat,Mahnaz
-- Create date: 11.01.2026
-- Description:	Report_Category_MonthSale
-- =============================================
CREATE VIEW Vw_Category_MonthSale
AS
SELECT CA.Name AS CATEGORY , YEAR  ( fh.CreatedAt ) AS YEARS ,
                   MONTH ( fh.CreatedAt ) AS MONTHS, 
                   SUM(FD.Quantity) AS TotalQuantity ,
                   SUM(FD.SubTotal) AS SaleProduct ,
                   SUM(FD.DiscountPercent) AS TotalDiscount
FROM  FactorHeader AS FH
INNER JOIN  FactorDetail AS FD ON FH.Id=FD.FactorHeaderId
INNER JOIN Product AS P ON FD.ProductId=P.Id
INNER JOIN ProductCategory AS CA ON P.CategoryId=CA.Id
GROUP BY CA.Name,YEAR  ( fh.CreatedAt ),MONTH ( fh.CreatedAt )
ORDER BY YEARS,MONTHS DESC OFFSET 0 ROW
