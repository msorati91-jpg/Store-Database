-- =============================================
-- Author:		Bayat,Mahnaz
-- Create date: 11.01.2026
-- Description:	Vw_Product_State
-- =============================================
 CREATE VIEW Vw_Product_State
 AS 
	select P.Id,P.Name AS ProductName ,CA.Name AS Category ,PS.Quantity,P.MinStock,P.MaxStock,
	SUM (FD.Quantity) AS SaleCount,
	case
	WHEN SUM (FD.Quantity) > P.MaxStock THEN 'OverSale'
	WHEN SUM (FD.Quantity) < P.MinStock THEN 'LowSale'
	ELSE 'Normal'
	END AS ProduktState
	from Product AS P 
	LEFT JOIN productstock AS PS ON PS.ProductId=P.Id
	LEFT JOIN FactorDetail AS FD ON P.Id=FD.FactorHeaderId
	LEFT JOIN ProductCategory AS CA ON P.CategoryId=CA.Id
	GROUP BY P.Id,P.Name,CA.Name ,PS.Quantity ,P.MinStock,P.MaxStock
