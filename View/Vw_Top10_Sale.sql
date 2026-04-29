-- =============================================
-- Author:		Bayat,Mahnaz
-- Create date: 11.01.2026
-- Description:	Vw_Top10_Sale
-- =============================================
CREATE VIEW Vw_Top10_Sale
AS
SELECT    P.Id,CA.Name AS Category,P.Name AS ProducName, 
		  COUNT(DISTINCT Fh.Id) AS TotalFactor,SUM(FD.Quantity) AS TotalQuantity ,
          sum(FD.SubTotal) as TotalTrice
FROM FactorHeader AS FH 
INNER JOIN FactorDetail AS FD ON FH.Id=FD.FactorHeaderId
INNER JOIN PRODUCT AS P ON FD.ProductId=P.Id
INNER JOIN ProductCategory AS CA ON P.CategoryId=CA.Id
GROUP BY P.Id,P.Name,CA.Name
ORDER BY TotalQuantity  DESC OFFSET 0 ROW
