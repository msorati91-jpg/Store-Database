--=============================================
-- Author:		<Bayat,Mahnaz>
-- Create date: <2026-03-30 >
-- Description:	<Controling ProductStock That Is Updated With Sale>
-- =============================================
ALTER FUNCTION Fn_CheckUpdateProductStock ()
RETURNS TABLE 
AS
RETURN
	WITH SumSalePerProduct AS(
			SELECT P.Id AS ProductId,(FD.Quantity) AS Quantity,MAX(FH.CreatedAt) AS LastSaleDate
			FROM Product AS P
			INNER JOIN FactorDetail AS FD ON FD.ProductId=P.Id
			INNER JOIN FactorHeader AS FH ON FH.Id=FD.FactorHeaderId
			GROUP BY P.Id,FD.Quantity )
		,ProductStockLastUpdate AS (
			SELECT PS.ProductId,MAX(PS.LastUpdate) AS MaxLastUpdate,MIN(Quantity) AS MinQuantity
			FROM ProductStock AS PS
			GROUP BY PS.ProductId
			)
	------------------------------------------
	SELECT SS.ProductId, Quantity
	FROM SumSalePerProduct AS SS
	INNER JOIN ProductStockLastUpdate AS PSLA ON PSLA.ProductId=SS.ProductId
	WHERE MaxLastUpdate < LastSaleDate

GO

