-- =============================================
-- Author:		Bayat,Mahnaz
-- Create date: 11.01.2026
-- Description:	REPORT_Monthlysale In Every YEAR And MONTH
-- =============================================
CREATE PROCEDURE SP_Monthlysale @YEAR INT ,@MONTH INT
AS
	SELECT YEAR  ( FH.CreatedAt ) AS YEAR ,MONTH ( FH.CreatedAt ) AS MONTH
		,COUNT(DISTINCT(FD.FactorHeaderId)) AS TotalFactor
		,COUNT(DISTINCT(FH.CustomerId)) AS TotalCustomer
		,SUM(FD.Quantity) AS TotalQuantity
		,SUM(FD.SubTotal) AS MonthlySale
		,SUM(FD.DiscountAmount) AS DiscountAmount
		,SUM(FD.lineTotal) AS lineTotal
	FROM FactorHeader AS FH 
	INNER JOIN FactorDetail AS FD ON FH.Id=FD.FactorHeaderId
	WHERE YEAR ( FH.CreatedAt )=CASE WHEN @Year ='' THEN YEAR ( FH.CreatedAt ) ELSE @Year END
	AND   MONTH ( FH.CreatedAt )=CASE WHEN @Month ='' THEN MONTH ( FH.CreatedAt ) ELSE @Month END 
	GROUP BY YEAR ( FH.CreatedAt ),MONTH ( FH.CreatedAt )
	ORDER BY YEAR ( FH.CreatedAt ),MONTH ( FH.CreatedAt ) 
