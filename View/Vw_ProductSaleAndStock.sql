-- =============================================
-- Author:		Bayat,Mahnaz
-- Create date: 30.03.2026
-- Description:	 Sale And Stock Any Product
-- =============================================
CREATE VIEW Vw_ProductSaleAndStock
AS
	WITH SumSalePerProduct AS(
			SELECT PC.Id AS CtegoryId,PC.Name AS CategoryName,P.Id AS ProductId,P.Name AS Product
			,S.Name AS Supplier,SUM(FD.Quantity) AS SumSaled,MAX(FH.CreatedAt) AS LastSaleDate,P.MinStock,P.MaxStock
			FROM Product AS P
			INNER JOIN Supplier AS S ON S.Id=P.SupplierId
			INNER JOIN ProductCategory AS PC ON PC.Id=P.CategoryId
			INNER JOIN FactorDetail AS FD ON FD.ProductId=P.Id
			INNER JOIN FactorHeader AS FH ON FH.Id=FD.FactorHeaderId
			GROUP BY  PC.Id,PC.Name,P.Id,P.Name,S.Name,P.MinStock,P.MaxStock )
		,ProductStockLastUpdate AS (
			SELECT PS.ProductId,MAX(PS.LastUpdate) AS LastUpdate,MIN(Quantity) AS Quantity
			FROM ProductStock AS PS
			GROUP BY PS.ProductId
			)
	------------------------------------------
	SELECT CtegoryId, CategoryName,SS.ProductId,SS.Product,SS.Supplier, SumSaled,MinStock,MaxStock,LastSaleDate,LastUpdate,Quantity
	FROM SumSalePerProduct AS SS
	INNER JOIN ProductStockLastUpdate AS PSLA ON PSLA.ProductId=SS.ProductId
	ORDER BY CtegoryId,SS.ProductId OFFSET 0 ROWS
