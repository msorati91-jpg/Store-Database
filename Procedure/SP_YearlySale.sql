-- =============================================
-- Author:		Bayat,Mahnaz
-- Create date: 09.03.2026
-- Description:	Total Sale In Every YEAR 
-- =============================================
CREATE PROCEDURE SP_Yearlysale @YEAR INT 
AS
	SELECT YEAR  ( FH.CreatedAt ) AS YEAR 
		,COUNT(DISTINCT(FD.FactorHeaderId)) AS TotalFactor
		,COUNT(DISTINCT(FH.CustomerId)) AS TotalCustomer
		,SUM(FD.Quantity) AS TotalQuantity
		,SUM(FD.SubTotal) AS YearlySale
		,SUM(FD.DiscountAmount) AS DiscountAmount
		,SUM(FD.lineTotal) AS lineTotal
	FROM FactorHeader AS FH 
	INNER JOIN FactorDetail AS FD ON FH.Id=FD.FactorHeaderId
	WHERE YEAR ( FH.CreatedAt )=CASE WHEN @Year ='' THEN YEAR ( FH.CreatedAt ) ELSE @Year END
	GROUP BY YEAR ( FH.CreatedAt )
	ORDER BY YEAR ( FH.CreatedAt )
